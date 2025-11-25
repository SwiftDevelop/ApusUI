//
//  UISearchBar+Action.swift
//  ApusUI
//
//  Created by SwiftDevelop on 11/5/25.
//

import UIKit

// MARK: - Delegate Handler
@MainActor private enum AssociatedKeys {
    static var delegateHandlerKey: UInt8 = 0
    static var cancelButtonModeKey: UInt8 = 1
}

internal final class SearchBarDelegateHandler: NSObject, UISearchBarDelegate {
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
        if let handler = objc_getAssociatedObject(self, &AssociatedKeys.delegateHandlerKey) as? SearchBarDelegateHandler {
            return handler
        }
        let handler = SearchBarDelegateHandler()
        objc_setAssociatedObject(self, &AssociatedKeys.delegateHandlerKey, handler, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        self.delegate = handler
        return handler
    }
    
    var cancelButtonMode: CancelButtonMode {
        get {
            objc_getAssociatedObject(self, &AssociatedKeys.cancelButtonModeKey) as? CancelButtonMode ?? .none
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.cancelButtonModeKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

// MARK: - Mode
public extension UISearchBar {
    /// 취소 버튼의 표시 모드를 정의합니다.
    enum CancelButtonMode {
        /// 표시하지 않음
        case none
        /// 항상 표시
        case always
        /// 편집 시작 시 자동으로 표시
        case automatic
    }
}

// MARK: - Action Extension
public extension UISearchBar {
    /// 검색창의 텍스트가 변경될 때마다 호출될 액션을 등록합니다.
    /// - Parameter action: 변경된 텍스트를 파라미터로 받는 클로저입니다.
    @discardableResult
    func onChange(_ action: @escaping (String) -> Void) -> Self {
        delegateHandler.onChange = action
        return self
    }
    
    /// 키보드의 'Search' 버튼을 탭했을 때 호출될 액션을 등록합니다.
    /// - Parameter action: 현재 텍스트를 파라미터로 받는 클로저입니다.
    @discardableResult
    func onSearch(_ action: @escaping (String) -> Void) -> Self {
        delegateHandler.onSearch = action
        return self
    }
    
    /// 취소 버튼을 탭했을 때 호출될 액션과 버튼 표시 모드를 설정합니다.
    /// - Parameters:
    ///   - mode: 취소 버튼 표시 모드입니다.
    ///   - action: 취소 버튼을 탭했을 때 실행될 클로저입니다.
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
    
    /// 텍스트 편집이 시작될 때 호출될 액션을 등록합니다.
    /// - Parameter action: 편집 시작 시의 텍스트를 파라미터로 받는 클로저입니다.
    @discardableResult
    func onEditingBegan(_ action: @escaping (String) -> Void) -> Self {
        delegateHandler.onEditingBegan = action
        return self
    }
    
    /// 텍스트 편집이 종료될 때 호출될 액션을 등록합니다.
    /// - Parameter action: 편집 종료 시의 텍스트를 파라미터로 받는 클로저입니다.
    @discardableResult
    func onEditingEnded(_ action: @escaping (String) -> Void) -> Self {
        delegateHandler.onEditingEnded = action
        return self
    }
}
