//
//  UIButton+Action.swift
//  ApusUI
//
//  Created by SwiftDevelop on 11/3/25.
//

import UIKit

// MARK: - AssociatedKeys
@MainActor private enum AssociatedKeys {
    static var actionObservationKey: UInt8 = 0
}

// MARK: - ActionWrapper
private final class ActionWrapper {
    let action: (UIButton) -> Void
    
    init(action: @escaping (UIButton) -> Void) {
        self.action = action
    }
    
    @objc func invoke(_ sender: UIButton) {
        action(sender)
    }
}

// MARK: - Extension
public extension UIButton {
    /// 버튼에 대한 클로저 기반 액션을 추가합니다.
    /// - Parameters:
    ///   - controlEvents: 액션을 트리거할 UIControl 이벤트입니다. 기본값은 `.touchUpInside`입니다.
    ///   - action: 버튼이 이벤트에 응답할 때 실행될 클로저입니다.
    @discardableResult
    func onAction(for controlEvents: UIControl.Event = .touchUpInside, _ action: @escaping (UIButton) -> Void) -> Self {
        let wrapper = ActionWrapper(action: action)
        
        var actions = objc_getAssociatedObject(self, &AssociatedKeys.actionObservationKey) as? [ActionWrapper] ?? []
        actions.append(wrapper)
        objc_setAssociatedObject(self, &AssociatedKeys.actionObservationKey, actions, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        self.addTarget(wrapper, action: #selector(ActionWrapper.invoke(_:)), for: controlEvents)
        return self
    }
}
