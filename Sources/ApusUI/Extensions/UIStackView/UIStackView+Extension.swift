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
        _ axis: NSLayoutConstraint.Axis = .horizontal,
        alignment: UIStackView.Alignment = .fill,
        spacing: CGFloat = 0
    ) {
        self.init()
        self.axis = axis
        self.alignment = alignment
        self.spacing = spacing
    }
    
    convenience init(_ axis: NSLayoutConstraint.Axis = .horizontal, @SubviewBuilder _ builder: () -> [UIView]) {
        self.init()
        self.axis = axis
        self.arrangedSubviews(builder)
    }
    
    convenience init(_ axis: NSLayoutConstraint.Axis = .horizontal, @SubviewBuilder _ builder: (Self) -> [UIView]) {
        self.init()
        self.axis = axis
        self.arrangedSubviews(builder)
    }
    
    convenience init<T>(_ axis: NSLayoutConstraint.Axis = .horizontal, data: [T], @SubviewBuilder _ builder: (T) -> [UIView]) {
        self.init()
        self.axis = axis
        self.arrangedSubviews(data, builder)
    }
    
    convenience init(_ axis: NSLayoutConstraint.Axis = .horizontal, count: Int, @SubviewBuilder _ builder: (Int) -> [UIView]) {
        self.init()
        self.axis = axis
        self.arrangedSubviews(count, builder)
    }
}

// MARK: - ArragedSubview
public extension UIStackView {
    @discardableResult
    func arrangedSubviews(@SubviewBuilder _ builder: () -> [UIView]) -> Self {
        let views = builder()
        views.forEach { view in
            self.addArrangedSubview(view)
        }
        return self
    }
    
    @discardableResult
    func arrangedSubviews(@SubviewBuilder _ builder: (Self) -> [UIView]) -> Self {
        let views = builder(self)
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

// MARK: - Extensions
public extension UIStackView {
    @discardableResult
    func axis(_ axis: NSLayoutConstraint.Axis) -> Self {
        self.axis = axis
        return self
    }
    
    @discardableResult
    func alignment(_ alignment: UIStackView.Alignment) -> Self {
        self.alignment = alignment
        return self
    }
    
    @discardableResult
    func distribution(_ distribution: UIStackView.Distribution) -> Self {
        self.distribution = distribution
        return self
    }
    
    @discardableResult
    func spacing(_ spacing: CGFloat) -> Self {
        self.spacing = spacing
        return self
    }
}
