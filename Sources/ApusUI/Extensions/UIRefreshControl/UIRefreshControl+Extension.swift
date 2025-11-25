//
//  UIRefreshControl+Extension.swift
//  ApusUI
//
//  Created by SwiftDevelop on 11/24/25.
//

import UIKit

// MARK: - AssociatedKey
@MainActor private struct AssociatedKey {
    static var refreshAction: UInt8 = 0
}

// MARK: - ActionWrapper
private final class ActionWrapper {
    let action: () -> Void
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
    
    @MainActor @objc func invoke() {
        action()
    }
}

// MARK: - Initialization
public extension UIRefreshControl {
    /// 새로고침 액션을 포함하는 `UIRefreshControl`을 생성합니다.
    /// - Parameter action: 새로고침이 트리거될 때 실행될 클로저입니다.
    convenience init(action: @escaping () -> Void) {
        self.init()
        self.onChange(action)
    }
}

// MARK: - Extension
public extension UIRefreshControl {
    /// 새로고침 컨트롤의 틴트 색상을 설정합니다.
    /// - Parameter color: 적용할 색상입니다.
    @discardableResult
    func tintColor(_ color: UIColor) -> Self {
        self.tintColor = color
        return self
    }
    
    /// 새로고침 컨트롤의 속성 문자열 제목을 설정합니다.
    /// - Parameter title: 표시할 속성 문자열입니다.
    @discardableResult
    func attributedTitle(_ title: NSAttributedString?) -> Self {
        self.attributedTitle = title
        return self
    }
    
    /// 새로고침이 트리거될 때 호출될 액션을 등록합니다.
    ///
    /// - Warning: 클로저 내에서 `self`를 참조할 경우, 메모리 누수를 방지하기 위해 `[weak self]`를 사용해야 합니다.
    /// - Parameter action: 새로고침이 트리거될 때 실행될 클로저입니다.
    @discardableResult
    func onChange(_ action: @escaping () -> Void) -> Self {
        let wrapper = ActionWrapper(action: action)
        objc_setAssociatedObject(self, &AssociatedKey.refreshAction, wrapper, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        self.addTarget(wrapper, action: #selector(ActionWrapper.invoke), for: .valueChanged)
        return self
    }
}
