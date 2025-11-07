//
//  UILabel+Extension.swift
//  ApusUI
//
//  Created by SwiftDevelop on 10/27/25.
//

import UIKit

// MARK: - Initialization
public extension UILabel {
    /// 초기 텍스트를 설정하여 `UILabel`을 생성합니다.
    /// - Parameter text: 라벨에 표시될 초기 문자열입니다.
    convenience init(_ text: String?) {
        self.init()
        self.text = text
    }
}

// MARK: - Extensions
public extension UILabel {
    /// 라벨의 텍스트를 설정합니다.
    /// - Parameter text: 표시할 문자열입니다.
    @discardableResult
    func text(_ text: String) -> Self {
        self.text = text
        return self
    }
    
    /// 라벨의 텍스트 색상을 설정합니다.
    /// - Parameter color: 적용할 텍스트 색상입니다.
    @discardableResult
    func textColor(_ color: UIColor) -> Self {
        self.textColor = color
        return self
    }
    
    /// 라벨의 폰트를 시스템 폰트로 설정합니다.
    /// - Parameters:
    ///   - size: 폰트 크기입니다.
    ///   - weight: 폰트 두께입니다. 기본값은 `.regular`입니다.
    @discardableResult
    func font(size: CGFloat, weight: UIFont.Weight = .regular) -> Self {
        self.font = UIFont.systemFont(ofSize: size, weight: weight)
        return self
    }
    
    /// 라벨의 폰트를 설정합니다.
    /// - Parameter font: 적용할 `UIFont` 객체입니다.
    @discardableResult
    func font(_ font: UIFont) -> Self {
        self.font = font
        return self
    }
    
    /// 라벨의 텍스트 정렬을 설정합니다.
    /// - Parameter alignment: 적용할 텍스트 정렬 방식입니다.
    @discardableResult
    func textAlignment(_ alignment: NSTextAlignment) -> Self {
        self.textAlignment = alignment
        return self
    }
    
    /// 라벨이 텍스트를 표시할 최대 줄 수를 설정합니다.
    /// - Parameter lines: 최대 줄 수입니다. 0은 줄 수 제한 없음을 의미합니다.
    @discardableResult
    func numberOfLines(_ lines: Int) -> Self {
        self.numberOfLines = lines
        return self
    }
    
}
