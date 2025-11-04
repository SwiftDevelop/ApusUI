//
//  UIProgressView+Extension.swift
//  ApusUI
//
//  Created by SwiftDevelop on 11/4/25.
//

import UIKit

public extension UIProgressView {
    @discardableResult
    func progress(_ progress: Float, animated: Bool = false) -> Self {
        self.setProgress(progress, animated: animated)
        return self
    }
    
    @discardableResult
    func progressTintColor(_ color: UIColor?) -> Self {
        self.progressTintColor = color
        return self
    }
    
    @discardableResult
    func trackTintColor(_ color: UIColor?) -> Self {
        self.trackTintColor = color
        return self
    }
    
    @discardableResult
    func trackImage(_ image: UIImage?) -> Self {
        self.trackImage = image
        return self
    }
}
