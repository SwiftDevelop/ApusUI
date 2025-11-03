//
//  UIButton+Action.swift
//  ApusUI
//
//  Created by SwiftDevelop on 11/3/25.
//

import UIKit

// MARK: - AssociatedKeys
@MainActor private enum AssociatedKeys {
    static var actionObservation: UInt8 = 0
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

// MARK: - Action Extensions
public extension UIButton {
    @discardableResult
    func onAction(for controlEvents: UIControl.Event = .touchUpInside, _ action: @escaping (UIButton) -> Void) -> Self {
        let wrapper = ActionWrapper(action: action)
        
        var actions = objc_getAssociatedObject(self, &AssociatedKeys.actionObservation) as? [ActionWrapper] ?? []
        actions.append(wrapper)
        objc_setAssociatedObject(self, &AssociatedKeys.actionObservation, actions, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        self.addTarget(wrapper, action: #selector(ActionWrapper.invoke(_:)), for: controlEvents)
        return self
    }
}
