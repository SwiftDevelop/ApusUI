//
//  UIButton+Extension.swift
//  ApusUI
//
//  Created by SwiftDevelop on 10/27/25.
//

import UIKit

// MARK: - Initialization
public extension UIButton {
    /// 액션을 포함하는 버튼을 생성합니다.
    /// - Parameter action: 버튼을 탭했을 때 실행될 클로저입니다.
    convenience init(action: @escaping (UIButton) -> Void) {
        self.init()
        self.onAction(action)
    }
    
    /// 액션과 서브뷰를 포함하는 버튼을 생성합니다.
    /// - Parameters:
    ///   - action: 버튼을 탭했을 때 실행될 클로저입니다.
    ///   - builder: 버튼에 추가될 서브뷰들을 정의하는 Result Builder 클로저입니다.
    convenience init(action: @escaping (UIButton) -> Void, @SubviewBuilder subviews builder: () -> [UIView]) {
        self.init()
        self.onAction(action)
        self.subviews(builder)
    }
}

// MARK: - Extension
public extension UIButton {
    /// 버튼의 제목을 설정합니다.
    /// - Parameters:
    ///   - title: 설정할 제목 문자열입니다.
    ///   - state: 제목을 설정할 컨트롤 상태입니다. 기본값은 `.normal`입니다.
    @discardableResult
    func title(_ title: String, for state: UIControl.State = .normal) -> Self {
        self.setTitle(title, for: state)
        return self
    }
    
    /// 버튼의 제목 색상을 설정합니다.
    /// - Parameters:
    ///   - color: 설정할 색상입니다.
    ///   - state: 제목 색상을 설정할 컨트롤 상태입니다. 기본값은 `.normal`입니다.
    @discardableResult
    func titleColor(_ color: UIColor, for state: UIControl.State = .normal) -> Self {
        self.setTitleColor(color, for: state)
        return self
    }
    
    /// 버튼의 속성 문자열 제목을 설정합니다.
    /// - Parameters:
    ///   - title: 설정할 속성 문자열입니다.
    ///   - state: 제목을 설정할 컨트롤 상태입니다. 기본값은 `.normal`입니다.
    @discardableResult
    func attributedTitle(_ title: NSAttributedString, for state: UIControl.State = .normal) -> Self {
        self.setAttributedTitle(title, for: state)
        return self
    }
    
    /// 버튼 제목의 폰트를 설정합니다.
    /// - Parameters:
    ///   - size: 폰트 크기입니다.
    ///   - weight: 폰트 두께입니다. 기본값은 `.regular`입니다.
    @discardableResult
    func font(size: CGFloat, weight: UIFont.Weight = .regular) -> Self {
        self.titleLabel?.font = UIFont.systemFont(ofSize: size, weight: weight)
        return self
    }
    
    /// 버튼의 배경 이미지를 설정합니다.
    /// - Parameters:
    ///   - image: 설정할 이미지입니다.
    ///   - state: 이미지를 설정할 컨트롤 상태입니다. 기본값은 `.normal`입니다.
    @discardableResult
    func backgroundImage(_ image: UIImage?, for state: UIControl.State = .normal) -> Self {
        self.setBackgroundImage(image, for: state)
        return self
    }
    
    /// 버튼의 이미지를 설정합니다.
    /// - Parameters:
    ///   - image: 설정할 이미지입니다.
    ///   - state: 이미지를 설정할 컨트롤 상태입니다. 기본값은 `.normal`입니다.
    @discardableResult
    func image(_ image: UIImage?, for state: UIControl.State = .normal) -> Self {
        self.setImage(image, for: state)
        return self
    }
    
    /// 에셋 이름으로 버튼의 이미지를 설정합니다.
    /// - Parameters:
    ///   - name: 에셋 카탈로그에 있는 이미지의 이름입니다.
    ///   - state: 이미지를 설정할 컨트롤 상태입니다. 기본값은 `.normal`입니다.
    @discardableResult
    func image(name: String, for state: UIControl.State = .normal) -> Self {
        self.setImage(UIImage(named: name), for: state)
        return self
    }
    
    /// SF Symbol 이름으로 버튼의 이미지를 설정합니다.
    /// - Parameters:
    ///   - systemName: SF Symbol의 이름입니다.
    ///   - state: 이미지를 설정할 컨트롤 상태입니다. 기본값은 `.normal`입니다.
    @discardableResult
    func image(systemName: String, for state: UIControl.State = .normal) -> Self {
        self.setImage(UIImage(systemName: systemName), for: state)
        return self
    }
    
    /// 버튼의 틴트 색상을 설정합니다.
    @discardableResult
    func tintColor(_ color: UIColor) -> Self {
        self.tintColor = color
        return self
    }
    
    /// 버튼의 콘텐츠 여백을 설정합니다. (iOS 13.0 이상)
    @available(iOS 13.0, *)
    @discardableResult
    func contentEdgeInsets(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> Self {
        self.contentEdgeInsets = .init(top: top, left: left, bottom: bottom, right: right)
        return self
    }
    
    /// 버튼의 제목 여백을 설정합니다. (iOS 13.0 이상)
    @available(iOS 13.0, *)
    @discardableResult
    func titleEdgeInsets(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> Self {
        self.titleEdgeInsets = .init(top: top, left: left, bottom: bottom, right: right)
        return self
    }
    
    /// 버튼의 이미지 여백을 설정합니다. (iOS 13.0 이상)
    @available(iOS 13.0, *)
    @discardableResult
    func imageEdgeInsets(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> Self {
        self.imageEdgeInsets = .init(top: top, left: left, bottom: bottom, right: right)
        return self
    }
    
    /// 버튼의 `configuration`을 설정합니다. (iOS 15.0 이상)
    @available(iOS 15.0, *)
    @discardableResult
    func configuration(_ configuration: UIButton.Configuration) -> Self {
        self.configuration = configuration
        return self
    }
    
    /// 버튼의 `configuration`을 업데이트합니다. (iOS 15.0 이상)
    /// - Parameter update: 현재 `configuration`을 수정하는 클로저입니다.
    @available(iOS 15.0, *)
    @discardableResult
    func updateConfiguration(_ update: (inout UIButton.Configuration) -> Void) -> Self {
        if var configuration = self.configuration {
            update(&configuration)
        }
        return self
    }
    
    /// 버튼의 이미지와 제목의 의미론적 순서를 설정합니다.
    @discardableResult
    func semanticContentAttribute(_ semanticContentAttribute: UISemanticContentAttribute) -> Self {
        self.semanticContentAttribute = semanticContentAttribute
        return self
    }
}
