//
//  UISlider+Extension.swift
//  ApusUI
//
//  Created by SwiftDevelop on 11/4/25.
//

import UIKit

// MARK: - AssociatedKey
@MainActor private struct AssociatedKey {
    static var sliderActionKey: UInt8 = 0
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
    /// 값이 변경될 때 호출될 액션을 포함하는 `UISlider`를 생성합니다.
    /// - Parameter action: 슬라이더의 값이 변경될 때 호출될 클로저입니다.
    convenience init(action: @escaping (Float) -> Void) {
        self.init()
        self.onChange(action)
    }
}

// MARK: - Extensions
public extension UISlider {
    /// 슬라이더의 현재 값을 설정합니다.
    /// - Parameters:
    ///   - value: 설정할 값입니다.
    ///   - animated: 변경 사항을 애니메이션으로 보여줄지 여부입니다.
    @discardableResult
    func value(_ value: Float, animated: Bool = false) -> Self {
        self.setValue(value, animated: animated)
        if let wrapper = objc_getAssociatedObject(self, &AssociatedKey.sliderActionKey) as? ActionWrapper {
            wrapper.invoke()
        }
        return self
    }
    
    /// 슬라이더의 최소값을 설정합니다.
    @discardableResult
    func minimumValue(_ value: Float) -> Self {
        self.minimumValue = value
        return self
    }
    
    /// 슬라이더의 최대값을 설정합니다.
    @discardableResult
    func maximumValue(_ value: Float) -> Self {
        self.maximumValue = value
        return self
    }
    
    /// 슬라이더의 최소값 트랙 부분의 틴트 색상을 설정합니다.
    @discardableResult
    func minimumTrackTintColor(_ color: UIColor?) -> Self {
        self.minimumTrackTintColor = color
        return self
    }
    
    /// 슬라이더의 최대값 트랙 부분의 틴트 색상을 설정합니다.
    @discardableResult
    func maximumTrackTintColor(_ color: UIColor?) -> Self {
        self.maximumTrackTintColor = color
        return self
    }
    
    /// 슬라이더의 Thumb(움직이는 원)의 틴트 색상을 설정합니다.
    @discardableResult
    func thumbTintColor(_ color: UIColor?) -> Self {
        self.thumbTintColor = color
        return self
    }
    
    /// 특정 상태에 대한 최소값 트랙 이미지를 설정합니다.
    @discardableResult
    func minimumTrackTintImage(_ image: UIImage?, for state: UIControl.State = .normal) -> Self {
        self.setMinimumTrackImage(image, for: state)
        return self
    }
    
    /// 특정 상태에 대한 최대값 트랙 이미지를 설정합니다.
    @discardableResult
    func maximumTrackTintImage(_ image: UIImage?, for state: UIControl.State = .normal) -> Self {
        self.setMaximumTrackImage(image, for: state)
        return self
    }
    
    /// 특정 상태에 대한 Thumb 이미지를 설정합니다.
    @discardableResult
    func thumbImage(_ image: UIImage?, for state: UIControl.State = .normal) -> Self {
        self.setThumbImage(image, for: state)
        return self
    }
    
    /// 슬라이더의 값이 변경될 때 호출될 액션을 등록합니다.
    /// - Parameter action: 변경된 값을 파라미터로 받는 클로저입니다.
    @discardableResult
    func onChange(_ action: @escaping (Float) -> Void) -> Self {
        let wrapper = ActionWrapper(action: action, control: self)
        objc_setAssociatedObject(self, &AssociatedKey.sliderActionKey, wrapper, .OBJC_ASSOCIATION_RETAIN)
        self.addTarget(wrapper, action: #selector(ActionWrapper.invoke), for: .valueChanged)
        return self
    }
}
