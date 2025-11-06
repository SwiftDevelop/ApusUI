//
//  UIView+Action.swift
//  ApusUI
//
//  Created by SwiftDevelop on 11/6/25.
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

// MARK: - Extension
public extension UIView {
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
