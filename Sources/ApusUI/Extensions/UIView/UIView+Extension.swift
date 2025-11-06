//
//  UIView+Extension.swift
//  ApusUI
//
//  Created by SwiftDevelop on 10/28/25.
//

import UIKit

// MARK: - Initialization
public extension UIView {
    convenience init(@SubviewBuilder _ builder: () -> [UIView]) {
        self.init()
        self.subviews(builder)
    }
    
    convenience init(_ color: UIColor? = nil) {
        self.init()
        self.backgroundColor = color
    }
    
    convenience init(_ color: UIColor? = nil, @SubviewBuilder _ builder: () -> [UIView]) {
        self.init()
        self.backgroundColor = color
        self.subviews(builder)
    }
}

// MARK: - Extension
public extension UIView {
    @discardableResult
    func backgroundColor(_ color: UIColor) -> Self {
        self.backgroundColor = color
        return self
    }
    
    @discardableResult
    func cornerRadius(_ radius: CGFloat) -> Self {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        return self
    }
    
    @discardableResult
    func border(width: CGFloat, color: UIColor) -> Self {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
        return self
    }
    
    @discardableResult
    func shadow(color: UIColor = .black, opacity: Float, offset: CGSize = .zero, radius: CGFloat) -> Self {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false
        return self
    }
    
    @discardableResult
    func alpha(_ value: CGFloat) -> Self {
        self.alpha = value
        return self
    }
    
    @discardableResult
    func hidden(_ isHidden: Bool = true) -> Self {
        self.isHidden = isHidden
        return self
    }
}
