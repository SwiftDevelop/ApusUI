//
//  UISwitch+Extension.swift
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
    /// 값이 변경될 때 호출될 액션을 포함하는 `UISwitch`를 생성합니다.
    /// - Parameter action: 스위치의 상태가 변경될 때 호출될 클로저입니다.
    convenience init(action: @escaping (Bool) -> Void) {
        self.init()
        self.onChange(action)
    }
}

// MARK: - Extensions
public extension UISwitch {
    /// 스위치의 On/Off 상태를 설정합니다.
    /// - Parameter on: On 상태로 설정하려면 true, Off 상태는 false를 전달합니다.
    @discardableResult
    func isOn(_ on: Bool) -> Self {
        self.isOn = on
        if let wrapper = objc_getAssociatedObject(self, &AssociatedKey.switchAction) as? ActionWrapper {
            wrapper.invoke()
        }
        return self
    }
    
    /// 스위치가 On 상태일 때의 틴트 색상을 설정합니다.
    @discardableResult
    func onTintColor(_ color: UIColor?) -> Self {
        self.onTintColor = color
        return self
    }
    
    /// 스위치의 Thumb(움직이는 원)의 틴트 색상을 설정합니다.
    @discardableResult
    func thumbTintColor(_ color: UIColor?) -> Self {
        self.thumbTintColor = color
        return self
    }
    
    /// 스위치의 값이 변경될 때 호출될 액션을 등록합니다.
    /// - Parameter action: 변경된 `isOn` 상태를 파라미터로 받는 클로저입니다.
    @discardableResult
    func onChange(_ action: @escaping (Bool) -> Void) -> Self {
        let wrapper = ActionWrapper(action: action, control: self)
        objc_setAssociatedObject(self, &AssociatedKey.switchAction, wrapper, .OBJC_ASSOCIATION_RETAIN)
        self.addTarget(wrapper, action: #selector(ActionWrapper.invoke), for: .valueChanged)
        return self
    }
}
