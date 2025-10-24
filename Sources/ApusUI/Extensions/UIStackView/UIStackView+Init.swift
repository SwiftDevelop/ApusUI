//
//  UIStackView+Init.swift
//  ApusUI
//
//  Created by SwiftDevelop on 10/24/25.
//

import UIKit

public extension UIStackView {
    convenience init(
        axis: NSLayoutConstraint.Axis = .horizontal,
        alignment: UIStackView.Alignment = .fill,
        spacing: CGFloat = 0
    ) {
        self.init()
        self.axis = axis
        self.alignment = alignment
        self.spacing = spacing
    }
}
