//
//  UIView+Subviews.swift
//  ApusUI
//
//  Created by SwiftDevelop on 10/24/25.
//

import UIKit

public extension UIView {
    @discardableResult
    func subviews(@SubviewBuilder _ builder: () -> [UIView]) -> Self {
        let views = builder()
        views.forEach { subview in
            self.addSubview(subview)
            subview.applyPendingConstraints()
        }
        return self
    }
}
