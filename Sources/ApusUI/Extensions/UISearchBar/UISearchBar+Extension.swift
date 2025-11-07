//
//  UISearchBar+Extension.swift
//  ApusUI
//
//  Created by SwiftDevelop on 11/5/25.
//

import UIKit

// MARK: - Initializers
public extension UISearchBar {
    /// 특정 스타일로 `UISearchBar`를 생성합니다.
    /// - Parameter style: 검색창의 스타일입니다.
    convenience init(style: UISearchBar.Style = .default) {
        self.init()
        self.style(style)
    }
}

// MARK: - Extension
public extension UISearchBar {
    /// 검색창의 텍스트를 설정합니다.
    @discardableResult
    func text(_ text: String?) -> Self {
        self.text = text
        return self
    }
    
    /// 검색창 위에 표시될 프롬프트 메시지를 설정합니다.
    @discardableResult
    func prompt(_ prompt: String?) -> Self {
        self.prompt = prompt
        return self
    }
    
    /// 플레이스홀더 텍스트를 설정합니다.
    @discardableResult
    func placeholder(_ placeholder: String) -> Self {
        self.placeholder = placeholder
        return self
    }
    
    /// 검색창의 스타일을 설정합니다.
    @discardableResult
    func style(_ style: UISearchBar.Style) -> Self {
        self.searchBarStyle = style
        return self
    }
    
    /// 검색창의 막대 틴트 색상을 설정합니다.
    @discardableResult
    func barTintColor(_ color: UIColor?) -> Self {
        self.barTintColor = color
        return self
    }
    
    /// 취소 버튼의 표시 여부를 설정합니다.
    @discardableResult
    func showsCancelButton(_ shows: Bool, animated: Bool = false) -> Self {
        self.setShowsCancelButton(shows, animated: animated)
        return self
    }
    
    /// 북마크 버튼의 표시 여부를 설정합니다.
    @discardableResult
    func showsBookmarkButton(_ shows: Bool) -> Self {
        self.showsBookmarkButton = shows
        return self
    }
    
    /// 검색 결과 버튼의 표시 여부를 설정합니다.
    @discardableResult
    func showsSearchResultsButton(_ shows: Bool) -> Self {
        self.showsSearchResultsButton = shows
        return self
    }
    
    /// 검색창의 막대 스타일을 설정합니다.
    @discardableResult
    func barStyle(_ style: UIBarStyle) -> Self {
        self.barStyle = style
        return self
    }
    
    /// 검색창의 반투명 여부를 설정합니다.
    @discardableResult
    func isTranslucent(_ isTranslucent: Bool) -> Self {
        self.isTranslucent = isTranslucent
        return self
    }
    
    /// 키보드 타입을 설정합니다.
    @discardableResult
    func keyboardType(_ type: UIKeyboardType) -> Self {
        self.keyboardType = type
        return self
    }
}

