//
//  UIScrollView+Extension.swift
//  ApusUI
//
//  Created by SwiftDevelop on 10/27/25.
//

import UIKit

// MARK: - AssociatedKeys
@MainActor private enum AssociatedKeys {
    static var contentOffsetObservations: UInt8 = 0
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
        var observers = objc_getAssociatedObject(self, &AssociatedKeys.contentOffsetObservations) as? [KVOObserver] ?? []
        
        let observer = KVOObserver(scrollView: self, action: action)
        observers.append(observer)
        
        objc_setAssociatedObject(self, &AssociatedKeys.contentOffsetObservations, observers, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        return self
    }
}
