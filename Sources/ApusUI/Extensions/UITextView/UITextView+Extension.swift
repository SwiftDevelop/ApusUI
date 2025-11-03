//
//  UITextView+Extension.swift
//  ApusUI
//
//  Created by SwiftDevelop on 10/31/25.
//

import UIKit

public extension UITextView {
    @discardableResult
    func text(_ text: String) -> Self {
        self.text = text
        return self
    }
    
    @discardableResult
    func textColor(_ color: UIColor) -> Self {
        self.textColor = color
        return self
    }
    
    @discardableResult
    func font(size: CGFloat, weight: UIFont.Weight = .regular) -> Self {
        self.font = UIFont.systemFont(ofSize: size, weight: weight)
        return self
    }
    
    @discardableResult
    func textAlignment(_ alignment: NSTextAlignment) -> Self {
        self.textAlignment = alignment
        return self
    }
    
    @discardableResult
    func isEditable(_ editable: Bool) -> Self {
        self.isEditable = editable
        return self
    }
}

