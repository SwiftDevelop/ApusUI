//
//  UITextView+Extension.swift
//  ApusUI
//
//  Created by SwiftDevelop on 10/31/25.
//

import UIKit

public extension UITextView {
    /// 텍스트 뷰의 텍스트를 설정합니다.
    @discardableResult
    func text(_ text: String) -> Self {
        self.text = text
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
    
    /// 텍스트 뷰의 편집 가능 여부를 설정합니다.
    @discardableResult
    func isEditable(_ editable: Bool) -> Self {
        self.isEditable = editable
        return self
    }
}

