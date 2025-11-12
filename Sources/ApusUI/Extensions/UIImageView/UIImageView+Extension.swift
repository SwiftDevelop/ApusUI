//
//  UIImageView+Extension.swift
//  ApusUI
//
//  Created by SwiftDevelop on 10/28/25.
//

import UIKit

// MARK: - Initialization
public extension UIImageView {
    /// 에셋 이름으로 이미지를 표시하는 `UIImageView`를 생성합니다.
    /// - Parameter name: 에셋 카탈로그에 있는 이미지의 이름입니다.
    convenience init(named name: String) {
        self.init(image: UIImage(named: name))
    }
    
    /// SF Symbol 이름으로 이미지를 표시하는 `UIImageView`를 생성합니다.
    /// - Parameter systemName: SF Symbol의 이름입니다.
    convenience init(systemName name: String) {
        self.init(image: UIImage(systemName: name))
    }
}

// MARK: - Extension
public extension UIImageView {
    /// `UIImage` 객체로 이미지를 설정합니다.
    /// - Parameter image: 표시할 `UIImage` 객체입니다.
    @discardableResult
    func image(_ image: UIImage?) -> Self {
        self.image = image
        return self
    }
    
    /// 에셋 이름으로 이미지를 설정합니다.
    /// - Parameter name: 에셋 카탈로그에 있는 이미지의 이름입니다.
    @discardableResult
    func image(named name: String) -> Self {
        self.image = UIImage(named: name)
        return self
    }
    
    /// SF Symbol 이름으로 이미지를 설정합니다.
    /// - Parameter systemName: SF Symbol의 이름입니다.
    @discardableResult
    func image(systemName name: String) -> Self {
        self.image = UIImage(systemName: name)
        return self
    }
    
    /// 콘텐츠가 뷰의 경계에 맞춰지는 방식을 설정합니다.
    /// - Parameter mode: 적용할 콘텐츠 모드입니다.
    @discardableResult
    func contentMode(_ mode: UIView.ContentMode) -> Self {
        self.contentMode = mode
        return self
    }
    
    /// 이미지 뷰의 틴트 색상을 설정합니다.
    /// - Parameter color: 적용할 틴트 색상입니다.
    @discardableResult
    func tintColor(_ color: UIColor) -> Self {
        self.tintColor = color
        return self
    }
}
