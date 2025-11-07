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
    /// 뷰에 탭 제스처가 발생했을 때 실행될 액션을 추가합니다.
    /// - Parameter action: 뷰가 탭되었을 때 실행될 클로저입니다.
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
