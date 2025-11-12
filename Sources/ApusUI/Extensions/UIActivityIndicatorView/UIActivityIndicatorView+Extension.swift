//
//  UIActivityIndicatorView+Extension.swift
//  ApusUI
//
//  Created by SwiftDevelop on 11/3/25.
//

import UIKit

public extension UIActivityIndicatorView {
    /// 애니메이션 상태를 설정합니다.
    /// - Parameter animating: 애니메이션을 시작하려면 true, 중지하려면 false를 전달합니다.
    @discardableResult
    func isAnimating(_ animating: Bool) -> Self {
        if animating {
            self.startAnimating()
        } else {
            self.stopAnimating()
        }
        return self
    }
    
    /// 인디케이터의 색상을 설정합니다.
    /// - Parameter color: 적용할 색상입니다.
    @discardableResult
    func color(_ color: UIColor) -> Self {
        self.color = color
        return self
    }
    
    /// 인디케이터의 스타일을 설정합니다.
    /// - Parameter style: 적용할 스타일입니다.
    @discardableResult
    func style(_ style: UIActivityIndicatorView.Style) -> Self {
        self.style = style
        return self
    }
}

