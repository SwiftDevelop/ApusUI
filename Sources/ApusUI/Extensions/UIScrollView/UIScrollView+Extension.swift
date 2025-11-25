//
//  UIScrollView+Extension.swift
//  ApusUI
//
//  Created by SwiftDevelop on 10/27/25.
//

import UIKit

// MARK: - AssociatedKeys
@MainActor private enum AssociatedKeys {
    static var contentOffsetObservationsKey: UInt8 = 0
}

// MARK: - KVOObserver
@MainActor private final class KVOObserver: NSObject {
    private let action: @MainActor (CGPoint) -> Void
    private var observation: NSKeyValueObservation?
    
    init(scrollView: UIScrollView, action: @escaping @MainActor (CGPoint) -> Void) {
        self.action = action
        super.init()
        self.observation = scrollView.observe(\.contentOffset, options: [.new]) { [weak self] _, change in
            guard let self, let value = change.newValue else { return }
            DispatchQueue.main.async {
                self.action(value)
            }
        }
    }
    
    deinit {
        observation?.invalidate()
    }
}

// MARK: - Initialization
public extension UIScrollView {
    /// 서브뷰를 포함하는 `UIScrollView`를 생성합니다.
    /// - Parameter builder: 스크롤 뷰에 추가될 서브뷰들을 정의하는 Result Builder 클로저입니다.
    convenience init(@SubviewBuilder _ builder: (UIScrollView) -> [UIView]) {
        self.init()
        self.subviews(builder)
    }
}

// MARK: - Extension
public extension UIScrollView {
    /// 콘텐츠 주변의 여백(inset)을 설정합니다.
    @discardableResult
    func contentInset(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> Self {
        self.contentInset = .init(top: top, left: left, bottom: bottom, right: right)
        return self
    }

    /// 수직 스크롤 인디케이터의 표시 여부를 설정합니다.
    @discardableResult
    func showsVerticalScrollIndicator(_ shows: Bool) -> Self {
        self.showsVerticalScrollIndicator = shows
        return self
    }

    /// 수평 스크롤 인디케이터의 표시 여부를 설정합니다.
    @discardableResult
    func showsHorizontalScrollIndicator(_ shows: Bool) -> Self {
        self.showsHorizontalScrollIndicator = shows
        return self
    }

    /// 페이징 스크롤 사용 여부를 설정합니다.
    @discardableResult
    func isPagingEnabled(_ enabled: Bool) -> Self {
        self.isPagingEnabled = enabled
        return self
    }

    /// 스크롤 가능 여부를 설정합니다.
    @discardableResult
    func isScrollEnabled(_ enabled: Bool) -> Self {
        self.isScrollEnabled = enabled
        return self
    }

    /// 스크롤 경계를 넘었을 때 바운스 효과 사용 여부를 설정합니다.
    @discardableResult
    func bounces(_ bounces: Bool) -> Self {
        self.bounces = bounces
        return self
    }
    
    /// `contentOffset`이 변경될 때마다 호출될 액션을 등록합니다.
    /// - Parameter action: `contentOffset`의 새 `CGPoint` 값을 파라미터로 받는 클로저입니다.
    @MainActor
    @discardableResult
    func onContentOffsetChange(_ action: @escaping @MainActor (CGPoint) -> Void) -> Self {
        var observers = objc_getAssociatedObject(self, &AssociatedKeys.contentOffsetObservationsKey) as? [KVOObserver] ?? []
        
        let observer = KVOObserver(scrollView: self, action: action)
        observers.append(observer)
        
        objc_setAssociatedObject(self, &AssociatedKeys.contentOffsetObservationsKey, observers, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        return self
    }
    
    /// [편의성] 스크롤 뷰에 "pull-to-refresh" 기능을 추가합니다.
    ///
    /// 이 메서드는 내부적으로 `UIRefreshControl`을 생성하고 액션을 설정합니다.
    ///
    /// - Warning: 클로저 내에서 `self`를 참조할 경우, 메모리 누수를 방지하기 위해 `[weak self]`를 사용해야 합니다.
    /// - Parameter action: 새로고침이 트리거될 때 실행될 클로저입니다. 클로저는 생성된 `UIRefreshControl` 인스턴스를 파라미터로 받습니다.
    /// - Returns: 체이닝을 위한 UIScrollView 인스턴스.
    @discardableResult
    func onRefresh(_ action: @escaping (UIRefreshControl) -> Void) -> Self {
        let refreshControl = UIRefreshControl(action: action)
        self.refreshControl = refreshControl
        return self
    }
    
    /// [사용자 정의] 제공된 `UIRefreshControl` 인스턴스를 사용하여 "pull-to-refresh" 기능을 추가합니다.
    ///
    /// 이 메서드는 사용자가 미리 커스텀한 `UIRefreshControl`에 액션을 설정하고 스크롤 뷰에 연결할 때 사용합니다.
    ///
    /// - Warning: 클로저 내에서 `self`를 참조할 경우, 메모리 누수를 방지하기 위해 `[weak self]`를 사용해야 합니다.
    /// - Parameters:
    ///   - control: 사용자가 직접 생성하고 설정한 `UIRefreshControl` 인스턴스.
    ///   - action: 새로고침이 트리거될 때 실행될 클로저입니다. 클로저는 제공된 `UIRefreshControl` 인스턴스를 파라미터로 받습니다.
    /// - Returns: 체이닝을 위한 UIScrollView 인스턴스.
    @discardableResult
    func onRefresh(control: UIRefreshControl, action: @escaping (UIRefreshControl) -> Void) -> Self {
        control.onChange(action)
        self.refreshControl = control
        return self
    }
}
