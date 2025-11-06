//
//  UISearchBar+Extension.swift
//  ApusUI
//
//  Created by SwiftDevelop on 11/5/25.
//

import UIKit

// MARK: - Initializers
public extension UISearchBar {
    convenience init(style: UISearchBar.Style = .default) {
        self.init()
        self.style(style)
    }
}

// MARK: - Extension
public extension UISearchBar {
    @discardableResult
    func text(_ text: String?) -> Self {
        self.text = text
        return self
    }
    
    @discardableResult
    func prompt(_ prompt: String?) -> Self {
        self.prompt = prompt
        return self
    }
    
    @discardableResult
    func placeholder(_ placeholder: String) -> Self {
        self.placeholder = placeholder
        return self
    }
    
    @discardableResult
    func style(_ style: UISearchBar.Style) -> Self {
        self.searchBarStyle = style
        return self
    }
    
    @discardableResult
    func barTintColor(_ color: UIColor?) -> Self {
        self.barTintColor = color
        return self
    }
    
    @discardableResult
    func showsCancelButton(_ shows: Bool, animated: Bool = false) -> Self {
        self.setShowsCancelButton(shows, animated: animated)
        return self
    }
    
    @discardableResult
    func showsBookmarkButton(_ shows: Bool) -> Self {
        self.showsBookmarkButton = shows
        return self
    }
    
    @discardableResult
    func showsSearchResultsButton(_ shows: Bool) -> Self {
        self.showsSearchResultsButton = shows
        return self
    }
    
    @discardableResult
    func barStyle(_ style: UIBarStyle) -> Self {
        self.barStyle = style
        return self
    }
    
    @discardableResult
    func isTranslucent(_ isTranslucent: Bool) -> Self {
        self.isTranslucent = isTranslucent
        return self
    }
    
    @discardableResult
    func keyboardType(_ type: UIKeyboardType) -> Self {
        self.keyboardType = type
        return self
    }
}

