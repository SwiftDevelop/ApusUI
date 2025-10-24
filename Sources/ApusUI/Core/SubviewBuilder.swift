//
//  SubviewBuilder.swift
//  ApusUI
//
//  Created by SwiftDevelop on 10/24/25.
//

import UIKit

@resultBuilder
public struct SubviewBuilder {
    public static func buildBlock(_ components: UIView...) -> [UIView] {
        components
    }
    
    public static func buildOptional(_ component: [UIView]?) -> [UIView] {
        component ?? []
    }
    
    public static func buildEither(first component: [UIView]) -> [UIView] {
        component
    }
    
    public static func buildEither(second component: [UIView]) -> [UIView] {
        component
    }
    
    public static func buildArray(_ components: [[UIView]]) -> [UIView] {
        components.flatMap { $0 }
    }
}
