//
//  UISlider+Extension.swift
//  ApusUI
//
//  Created by SwiftDevelop on 11/4/25.
//

import UIKit

// MARK: - AssociatedKey
@MainActor private struct AssociatedKey {
    static var sliderAction: UInt8 = 0
}

// MARK: - ActionWrapper
private class ActionWrapper {
    let action: (Float) -> Void
    weak var control: UISlider?
    
    init(action: @escaping (Float) -> Void, control: UISlider?) {
        self.action = action
        self.control = control
    }
    
    @MainActor @objc func invoke() {
        action(control?.value ?? 0)
    }
}

// MARK: - Initialization
public extension UISlider {
    convenience init(action: @escaping (Float) -> Void) {
        self.init()
        self.onChange(action)
    }
}

// MARK: - Extensions
public extension UISlider {
    @discardableResult
    func value(_ value: Float, animated: Bool = false) -> Self {
        self.setValue(value, animated: animated)
        return self
    }
    
    @discardableResult
    func minimumValue(_ value: Float) -> Self {
        self.minimumValue = value
        return self
    }
    
    @discardableResult
    func maximumValue(_ value: Float) -> Self {
        self.maximumValue = value
        return self
    }
    
    @discardableResult
    func minimumTrackTintColor(_ color: UIColor?) -> Self {
        self.minimumTrackTintColor = color
        return self
    }
    
    @discardableResult
    func maximumTrackTintColor(_ color: UIColor?) -> Self {
        self.maximumTrackTintColor = color
        return self
    }
    
    @discardableResult
    func thumbTintColor(_ color: UIColor?) -> Self {
        self.thumbTintColor = color
        return self
    }
    
    @discardableResult
    func minimumTrackTintImage(_ image: UIImage?, for state: UIControl.State = .normal) -> Self {
        self.setMinimumTrackImage(image, for: state)
        return self
    }
    
    @discardableResult
    func maximumTrackTintImage(_ image: UIImage?, for state: UIControl.State = .normal) -> Self {
        self.setMaximumTrackImage(image, for: state)
        return self
    }
    
    @discardableResult
    func thumbImage(_ image: UIImage?, for state: UIControl.State = .normal) -> Self {
        self.setThumbImage(image, for: state)
        return self
    }
    
    @discardableResult
    func onChange(_ action: @escaping (Float) -> Void) -> Self {
        let wrapper = ActionWrapper(action: action, control: self)
        objc_setAssociatedObject(self, &AssociatedKey.sliderAction, wrapper, .OBJC_ASSOCIATION_RETAIN)
        self.addTarget(wrapper, action: #selector(ActionWrapper.invoke), for: .valueChanged)
        return self
    }
}

