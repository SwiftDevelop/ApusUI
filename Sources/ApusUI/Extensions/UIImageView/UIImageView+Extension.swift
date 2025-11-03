//
//  UIImageView+Extension.swift
//  ApusUI
//
//  Created by SwiftDevelop on 10/28/25.
//

import UIKit

@MainActor private enum AssociatedKeys {
    static var tapAction: UInt8 = 0
}

private final class TapActionWrapper {
    let action: () -> Void
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
    
    @objc func invoke() {
        action()
    }
}

// MARK: - Initialization
public extension UIImageView {
    convenience init(named name: String) {
        self.init(image: UIImage(named: name))
    }
    
    convenience init(systemName name: String) {
        self.init(image: UIImage(systemName: name))
    }
}

// MARK: - Extensions
public extension UIImageView {
    @discardableResult
    func image(_ image: UIImage?) -> Self {
        self.image = image
        return self
    }
    
    @discardableResult
    func image(named name: String) -> Self {
        self.image = UIImage(named: name)
        return self
    }
    
    @discardableResult
    func image(systemName name: String) -> Self {
        self.image = UIImage(systemName: name)
        return self
    }
    
    @discardableResult
    func contentMode(_ mode: UIView.ContentMode) -> Self {
        self.contentMode = mode
        return self
    }
    
    @discardableResult
    func tintColor(_ color: UIColor) -> Self {
        self.tintColor = color
        return self
    }
    
    @discardableResult
    func onTapGesture(_ action: @escaping () -> Void) -> Self {
        self.isUserInteractionEnabled = true
        let wrapper = TapActionWrapper(action: action)
        objc_setAssociatedObject(self, &AssociatedKeys.tapAction, wrapper, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        let tapGesture = UITapGestureRecognizer(target: wrapper, action: #selector(TapActionWrapper.invoke))
        self.addGestureRecognizer(tapGesture)
        
        return self
    }

}
