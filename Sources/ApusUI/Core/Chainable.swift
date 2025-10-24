//
//  Chainable.swift
//  ApusUI
//
//  Created by SwiftDevelop on 10/24/25.
//

import UIKit

public protocol Chainable: AnyObject { }

public extension Chainable {
    @discardableResult
    func apply(_ configure: (Self) -> Void) -> Self {
        configure(self)
        return self
    }
}

extension UIView: Chainable { }
