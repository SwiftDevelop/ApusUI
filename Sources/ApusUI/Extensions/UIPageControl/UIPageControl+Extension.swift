//
//  UIPageControl+Extension.swift
//  ApusUI
//
//  Created by SwiftDevelop on 11/7/25.
//

import UIKit

// MARK: - AssociatedKey
@MainActor private struct AssociatedKey {
    static var pageActionKey: UInt8 = 0
}

// MARK: - ActionWrapper
private class ActionWrapper {
    let action: (Int) -> Void
    weak var control: UIPageControl?
    
    init(action: @escaping (Int) -> Void, control: UIPageControl?) {
        self.action = action
        self.control = control
    }
    
    @MainActor @objc func invoke() {
        guard let control else { return }
        action(control.currentPage)
    }
}

// MARK: - Initialization
public extension UIPageControl {
    /// `UIPageControl`을 생성하고 초기화합니다.
    /// - Parameters:
    ///   - numberOfPages: 전체 페이지 수입니다.
    ///   - currentPage: 초기 현재 페이지 인덱스입니다.
    ///   - onChange: 페이지가 변경될 때 호출될 클로저입니다.
    convenience init(numberOfPages: Int, currentPage: Int = 0, onChange: @escaping (Int) -> Void) {
        self.init()
        self.numberOfPages = numberOfPages
        self.onChange(onChange)
        self.currentPage(currentPage)
    }
}

// MARK: - Extension
public extension UIPageControl {
    /// 전체 페이지 수를 설정합니다.
    /// - Parameter pages: 설정할 전체 페이지 수입니다.
    @discardableResult
    func numberOfPages(_ pages: Int) -> Self {
        self.numberOfPages = pages
        return self
    }
    
    /// 현재 페이지를 설정합니다.
    /// - Parameter page: 설정할 현재 페이지 인덱스입니다.
    @discardableResult
    func currentPage(_ page: Int) -> Self {
        self.currentPage = page
        return self
    }
    
    /// 페이지 표시기의 틴트 색상을 설정합니다.
    /// - Parameter color: 적용할 색상입니다.
    @discardableResult
    func pageIndicatorTintColor(_ color: UIColor?) -> Self {
        self.pageIndicatorTintColor = color
        return self
    }
    
    /// 현재 페이지 표시기의 틴트 색상을 설정합니다.
    /// - Parameter color: 적용할 색상입니다.
    @discardableResult
    func currentPageIndicatorTintColor(_ color: UIColor?) -> Self {
        self.currentPageIndicatorTintColor = color
        return self
    }
    
    /// 페이지가 변경될 때 호출될 액션을 등록합니다.
    /// - Parameter action: 페이지 변경 시 호출될 클로저이며, 현재 페이지 인덱스를 파라미터로 받습니다.
    @discardableResult
    func onChange(_ action: @escaping (Int) -> Void) -> Self {
        let wrapper = ActionWrapper(action: action, control: self)
        objc_setAssociatedObject(self, &AssociatedKey.pageActionKey, wrapper, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        self.addTarget(wrapper, action: #selector(ActionWrapper.invoke), for: .valueChanged)
        return self
    }
}
