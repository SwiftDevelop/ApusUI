//
//  SubviewBuilder.swift
//  ApusUI
//
//  Created by SwiftDevelop on 10/24/25.
//

import UIKit

/// 여러 UIView를 배열로 쉽게 구성할 수 있도록 하는 Result Builder입니다.
@resultBuilder
public struct SubviewBuilder {
    /// 여러 뷰 배열을 하나의 배열로 결합합니다.
    public static func buildBlock(_ components: [UIView]...) -> [UIView] {
        components.flatMap { $0 }
    }
    
    /// 옵셔널 뷰 배열을 처리합니다. nil일 경우 빈 배열을 반환합니다.
    public static func buildOptional(_ component: [UIView]?) -> [UIView] {
        component ?? []
    }
    
    /// `if`문의 'then' 블록에 해당하는 뷰를 반환합니다.
    public static func buildEither(first component: [UIView]) -> [UIView] {
        component
    }
    
    /// `if`문의 'else' 블록에 해당하는 뷰를 반환합니다.
    public static func buildEither(second component: [UIView]) -> [UIView] {
        component
    }
    
    /// 뷰의 배열을 단일 배열로 평탄화합니다.
    public static func buildArray(_ components: [[UIView]]) -> [UIView] {
        components.flatMap { $0 }
    }
    
    /// 단일 뷰를 배열로 변환합니다.
    public static func buildExpression(_ expression: UIView) -> [UIView] {
        [expression]
    }
    
    /// 뷰의 배열을 그대로 반환합니다.
    public static func buildExpression(_ expression: [UIView]) -> [UIView] {
        expression
    }
}
