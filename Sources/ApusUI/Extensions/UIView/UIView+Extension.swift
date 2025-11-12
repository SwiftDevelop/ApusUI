//
//  UIView+Extension.swift
//  ApusUI
//
//  Created by SwiftDevelop on 10/28/25.
//

import UIKit

// MARK: - Initialization
public extension UIView {
    /// `SubviewBuilder`를 사용하여 서브뷰를 포함하는 `UIView`를 생성합니다.
    convenience init(@SubviewBuilder _ builder: () -> [UIView]) {
        self.init()
        self.subviews(builder)
    }
    
    /// 특정 배경색을 가진 `UIView`를 생성합니다.
    convenience init(_ color: UIColor? = nil) {
        self.init()
        self.backgroundColor = color
    }
    
    /// 특정 배경색과 서브뷰를 가진 `UIView`를 생성합니다.
    convenience init(_ color: UIColor? = nil, @SubviewBuilder _ builder: () -> [UIView]) {
        self.init()
        self.backgroundColor = color
        self.subviews(builder)
    }
}

// MARK: - Extension
public extension UIView {
    /// 뷰의 배경색을 설정합니다.
    @discardableResult
    func backgroundColor(_ color: UIColor) -> Self {
        self.backgroundColor = color
        return self
    }
    
    /// 뷰의 모서리 반경을 설정합니다.
    @discardableResult
    func cornerRadius(_ radius: CGFloat) -> Self {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        return self
    }
    
    /// 뷰의 테두리를 설정합니다.
    /// - Parameters:
    ///   - width: 테두리 두께입니다.
    ///   - color: 테두리 색상입니다.
    @discardableResult
    func border(width: CGFloat, color: UIColor) -> Self {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
        return self
    }
    
    /// 뷰의 그림자를 설정합니다.
    /// - Parameters:
    ///   - color: 그림자 색상입니다.
    ///   - opacity: 그림자 불투명도입니다.
    ///   - offset: 그림자 오프셋입니다.
    ///   - radius: 그림자 반경입니다.
    @discardableResult
    func shadow(color: UIColor = .black, opacity: Float, offset: CGSize = .zero, radius: CGFloat) -> Self {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false
        return self
    }
    
    /// 뷰의 알파(투명도) 값을 설정합니다.
    @discardableResult
    func alpha(_ value: CGFloat) -> Self {
        self.alpha = value
        return self
    }
    
    /// 뷰의 숨김 상태를 설정합니다.
    @discardableResult
    func hidden(_ isHidden: Bool = true) -> Self {
        self.isHidden = isHidden
        return self
    }
}
