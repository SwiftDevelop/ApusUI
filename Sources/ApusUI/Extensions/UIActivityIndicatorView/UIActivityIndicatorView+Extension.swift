//
//  UIActivityIndicatorView+Extension.swift
//  ApusUI
//
//  Created by SwiftDevelop on 11/3/25.
//

import UIKit

public extension UIActivityIndicatorView {
    @discardableResult
    func isAnimating(_ animating: Bool) -> Self {
        if animating {
            self.startAnimating()
        } else {
            self.stopAnimating()
        }
        return self
    }
    
    @discardableResult
    func color(_ color: UIColor) -> Self {
        self.color = color
        return self
    }
    
    @discardableResult
    func style(_ style: UIActivityIndicatorView.Style) -> Self {
        self.style = style
        return self
    }
}

