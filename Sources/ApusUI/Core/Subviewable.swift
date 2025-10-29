//
//  Subviewable.swift
//  ApusUI
//
//  Created by SwiftDevelop on 10/29/25.
//

import UIKit

public protocol Subviewable: AnyObject { }

@MainActor
public extension Subviewable {
    @discardableResult
    func subviews(@SubviewBuilder _ builder: () -> [UIView]) -> Self {
        let views = builder()
        views.forEach { subview in
            (self as? UIView)?.addSubview(subview)
            subview.applyPendingConstraints()
        }
        return self
    }
    
    @discardableResult
    func subviews(@SubviewBuilder _ builder: (Self) -> [UIView]) -> Self {
        let views = builder(self)
        views.forEach { subview in
            (self as? UIView)?.addSubview(subview)
            subview.applyPendingConstraints()
        }
        return self
    }
}

extension UIView: Subviewable { }
