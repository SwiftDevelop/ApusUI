//
//  UITextField+Extension.swift
//  ApusUI
//
//  Created by SwiftDevelop on 10/31/25.
//

import UIKit

public extension UITextField {
    /// 텍스트 필드의 텍스트를 설정합니다.
    @discardableResult
    func text(_ text: String) -> Self {
        self.text = text
        return self
    }
    
    /// 플레이스홀더 텍스트를 설정합니다.
    @discardableResult
    func placeholder(_ placeholder: String) -> Self {
        self.placeholder = placeholder
        return self
    }
    
    /// 텍스트 색상을 설정합니다.
    @discardableResult
    func textColor(_ color: UIColor) -> Self {
        self.textColor = color
        return self
    }
    
    /// 폰트를 시스템 폰트로 설정합니다.
    /// - Parameters:
    ///   - size: 폰트 크기입니다.
    ///   - weight: 폰트 두께입니다.
    @discardableResult
    func font(size: CGFloat, weight: UIFont.Weight = .regular) -> Self {
        self.font = UIFont.systemFont(ofSize: size, weight: weight)
        return self
    }
    
    /// 텍스트 정렬을 설정합니다.
    @discardableResult
    func textAlignment(_ alignment: NSTextAlignment) -> Self {
        self.textAlignment = alignment
        return self
    }
    
    /// 테두리 스타일을 설정합니다.
    @discardableResult
    func borderStyle(_ style: UITextField.BorderStyle) -> Self {
        self.borderStyle = style
        return self
    }
}

