//
//  UISearchBar+Action.swift
//  ApusUI
//
//  Created by SwiftDevelop on 11/5/25.
//

import UIKit

// MARK: - Delegate Handler
@MainActor private enum AssociatedKeys {
    static var delegateHandler: UInt8 = 0
    static var cancelButtonMode: UInt8 = 1
}

internal class SearchBarDelegateHandler: NSObject, UISearchBarDelegate {
    var onChange: ((String) -> Void)?
    var onSearch: ((String) -> Void)?
    var onCancel: (() -> Void)?
    var onEditingBegan: ((String) -> Void)?
    var onEditingEnded: ((String) -> Void)?

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        onChange?(searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        onSearch?(searchBar.text ?? "")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        onCancel?()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar.cancelButtonMode == .automatic {
            searchBar.setShowsCancelButton(true, animated: true)
        }
        
        onEditingBegan?(searchBar.text ?? "")
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        let text = searchBar.text ?? ""
        
        if searchBar.cancelButtonMode == .automatic {
            searchBar.setShowsCancelButton(!text.isEmpty, animated: true)
        }
        
        onEditingEnded?(text)
    }
}

// MARK: - Internal Properties
internal extension UISearchBar {
    var delegateHandler: SearchBarDelegateHandler {
        if let handler = objc_getAssociatedObject(self, &AssociatedKeys.delegateHandler) as? SearchBarDelegateHandler {
            return handler
        }
        let handler = SearchBarDelegateHandler()
        objc_setAssociatedObject(self, &AssociatedKeys.delegateHandler, handler, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        self.delegate = handler
        return handler
    }
    
    var cancelButtonMode: CancelButtonMode {
        get {
            objc_getAssociatedObject(self, &AssociatedKeys.cancelButtonMode) as? CancelButtonMode ?? .none
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.cancelButtonMode, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

// MARK: - Mode
public extension UISearchBar {
    enum CancelButtonMode {
        case none
        case always
        case automatic
    }
}

// MARK: - Action Extension
public extension UISearchBar {
    @discardableResult
    func onChange(_ action: @escaping (String) -> Void) -> Self {
        delegateHandler.onChange = action
        return self
    }
    
    @discardableResult
    func onSearch(_ action: @escaping (String) -> Void) -> Self {
        delegateHandler.onSearch = action
        return self
    }
    
    @discardableResult
    func onCancel(_ mode: CancelButtonMode = .none, action: (() -> Void)? = nil) -> Self {
        switch mode {
        case .none:
            setShowsCancelButton(false, animated: false)
        case .always:
            setShowsCancelButton(true, animated: false)
        case .automatic:
            break
        }
        
        cancelButtonMode = mode
        delegateHandler.onCancel = action
        return self
    }
    
    @discardableResult
    func onEditingBegan(_ action: @escaping (String) -> Void) -> Self {
        delegateHandler.onEditingBegan = action
        return self
    }
    
    @discardableResult
    func onEditingEnded(_ action: @escaping (String) -> Void) -> Self {
        delegateHandler.onEditingEnded = action
        return self
    }
}
