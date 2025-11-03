//
//  UIButton+Extension.swift
//  ApusUI
//
//  Created by SwiftDevelop on 10/27/25.
//

import UIKit

@MainActor private enum AssociatedKeys {
    static var actionObservation: UInt8 = 0
}

private final class ActionWrapper {
    let action: (UIButton) -> Void
    
    init(action: @escaping (UIButton) -> Void) {
        self.action = action
    }
    
    @objc func invoke(_ sender: UIButton) {
        action(sender)
    }
}

// MARK: - Extensions
public extension UIButton {
    @discardableResult
    func title(_ title: String, for state: UIControl.State = .normal) -> Self {
        self.setTitle(title, for: state)
        return self
    }
    
    @discardableResult
    func titleColor(_ color: UIColor, for state: UIControl.State = .normal) -> Self {
        self.setTitleColor(color, for: state)
        return self
    }
    
    @discardableResult
    func attributedTitle(_ title: NSAttributedString, for state: UIControl.State = .normal) -> Self {
        self.setAttributedTitle(title, for: state)
        return self
    }
    
    @discardableResult
    func font(size: CGFloat, weight: UIFont.Weight = .regular) -> Self {
        self.titleLabel?.font = UIFont.systemFont(ofSize: size, weight: weight)
        return self
    }
    
    @discardableResult
    func backgroundImage(_ image: UIImage?, for state: UIControl.State = .normal) -> Self {
        self.setBackgroundImage(image, for: state)
        return self
    }
    
    @discardableResult
    func image(_ image: UIImage?, for state: UIControl.State = .normal) -> Self {
        self.setImage(image, for: state)
        return self
    }
    
    @discardableResult
    func image(name: String, for state: UIControl.State = .normal) -> Self {
        self.setImage(UIImage(named: name), for: state)
        return self
    }
    
    @discardableResult
    func image(systemName: String, for state: UIControl.State = .normal) -> Self {
        self.setImage(UIImage(systemName: systemName), for: state)
        return self
    }
    
    @discardableResult
    func tintColor(_ color: UIColor) -> Self {
        self.tintColor = color
        return self
    }
    
    @available(iOS 13.0, *)
    @discardableResult
    func contentEdgeInsets(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> Self {
        self.contentEdgeInsets = .init(top: top, left: left, bottom: bottom, right: right)
        return self
    }
    
    @available(iOS 13.0, *)
    @discardableResult
    func titleEdgeInsets(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> Self {
        self.titleEdgeInsets = .init(top: top, left: left, bottom: bottom, right: right)
        return self
    }
    
    @available(iOS 13.0, *)
    @discardableResult
    func imageEdgeInsets(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> Self {
        self.imageEdgeInsets = .init(top: top, left: left, bottom: bottom, right: right)
        return self
    }
    
    @available(iOS 15.0, *)
    @discardableResult
    func configuration(_ configuration: UIButton.Configuration) -> Self {
        self.configuration = configuration
        return self
    }
    
    @available(iOS 15.0, *)
    @discardableResult
    func updateConfiguration(_ update: (inout UIButton.Configuration) -> Void) -> Self {
        if var configuration = self.configuration {
            update(&configuration)
        }
        return self
    }
    
    @discardableResult
    func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ action: @escaping (UIButton) -> Void) -> Self {
        let wrapper = ActionWrapper(action: action)
        
        var actions = objc_getAssociatedObject(self, &AssociatedKeys.actionObservation) as? [ActionWrapper] ?? []
        actions.append(wrapper)
        objc_setAssociatedObject(self, &AssociatedKeys.actionObservation, actions, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        self.addTarget(wrapper, action: #selector(ActionWrapper.invoke(_:)), for: controlEvents)
        return self
    }
    
    @discardableResult
    func semanticContentAttribute(_ semanticContentAttribute: UISemanticContentAttribute) -> Self {
        self.semanticContentAttribute = semanticContentAttribute
        return self
    }
}
