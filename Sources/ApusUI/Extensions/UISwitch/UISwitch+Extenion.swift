//
//  UISwitch+Extenion.swift
//  ApusUI
//
//  Created by SwiftDevelop on 11/3/25.
//

import UIKit

// MARK: - AssociatedKey
@MainActor private struct AssociatedKey {
    static var switchAction: UInt8 = 0
}

// MARK: - ActionWrapper
private class ActionWrapper {
    let action: (Bool) -> Void
    weak var control: UISwitch?
    
    init(action: @escaping (Bool) -> Void, control: UISwitch) {
        self.action = action
        self.control = control
    }
    
    @MainActor @objc func invoke() {
        action(control?.isOn ?? false)
    }
}

// MARK: - Initialization
public extension UISwitch {
    convenience init(_ action: @escaping (Bool) -> Void) {
        self.init()
        self.onChange(action)
    }
}

// MARK: - Extension
public extension UISwitch {
    @discardableResult
    func isOn(_ on: Bool) -> Self {
        self.isOn = on
        return self
    }
    
    @discardableResult
    func onTintColor(_ color: UIColor?) -> Self {
        self.onTintColor = color
        return self
    }
    
    @discardableResult
    func thumbTintColor(_ color: UIColor?) -> Self {
        self.thumbTintColor = color
        return self
    }
    
    @discardableResult
    func onChange(_ action: @escaping (Bool) -> Void) -> Self {
        let wrapper = ActionWrapper(action: action, control: self)
        objc_setAssociatedObject(self, &AssociatedKey.switchAction, wrapper, .OBJC_ASSOCIATION_RETAIN)
        self.addTarget(wrapper, action: #selector(ActionWrapper.invoke), for: .valueChanged)
        return self
    }
}
