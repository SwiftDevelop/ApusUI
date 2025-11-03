//
//  UIImageView+Extension.swift
//  ApusUI
//
//  Created by SwiftDevelop on 10/28/25.
//

import UIKit

// MARK: - Initialization
public extension UIImageView {
    convenience init(named name: String) {
        self.init(image: UIImage(named: name))
    }
    
    convenience init(systemName name: String) {
        self.init(image: UIImage(systemName: name))
    }
}

// MARK: - Extensions
public extension UIImageView {
    @discardableResult
    func image(_ image: UIImage?) -> Self {
        self.image = image
        return self
    }
    
    @discardableResult
    func image(named name: String) -> Self {
        self.image = UIImage(named: name)
        return self
    }
    
    @discardableResult
    func image(systemName name: String) -> Self {
        self.image = UIImage(systemName: name)
        return self
    }
    
    @discardableResult
    func contentMode(_ mode: UIView.ContentMode) -> Self {
        self.contentMode = mode
        return self
    }
    
    @discardableResult
    func tintColor(_ color: UIColor) -> Self {
        self.tintColor = color
        return self
    }

}
