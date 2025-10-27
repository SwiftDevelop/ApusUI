//
//  UIStackView+Extension.swift
//  ApusUI
//
//  Created by SwiftDevelop on 10/24/25.
//

import UIKit

// MARK: - Initialization
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

// MARK: - Extensions
public extension UIStackView {
    @discardableResult
    func distribution(_ distribution: UIStackView.Distribution) -> Self {
        self.distribution = distribution
        return self
    }
    
    @discardableResult
    func arrangedSubviews(@SubviewBuilder _ builder: () -> [UIView]) -> Self {
        let views = builder()
        views.forEach { view in
            self.addArrangedSubview(view)
        }
        return self
    }
    
    @discardableResult
    func arrangedSubviews<T>(_ data: [T], @SubviewBuilder _ builder: (T) -> [UIView]) -> Self {
        for item in data {
            let views = builder(item)
            views.forEach { view in
                self.addArrangedSubview(view)
            }
        }
        return self
    }
    
    @discardableResult
    func arrangedSubviews(_ count: Int, @SubviewBuilder _ builder: (Int) -> [UIView]) -> Self {
        for i in 0..<count {
            let views = builder(i)
            views.forEach { view in
                self.addArrangedSubview(view)
            }
        }
        return self
    }
}
