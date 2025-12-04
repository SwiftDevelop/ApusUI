//
//  WKWebView+WKUIDelegate.swift
//  ApusUI
//
//  Created by SwiftDevelop on 2025/12/01.
//

import WebKit
import UIKit

// MARK: - Enums
public enum JavaScriptPanel {
    case alert(message: String, completion: () -> Void)
    case confirm(message: String, completion: (Bool) -> Void)
    case prompt(prompt: String, defaultText: String?, completion: (String?) -> Void)
}

// MARK: - AssociatedKeys
@MainActor private enum AssociatedKeys {
    static var uiDelegateKey: UInt8 = 0
}

// MARK: - Delegate Handler
internal final class WebViewUIDelegateHandler: NSObject, WKUIDelegate {
    
    // MARK: - Properties
    var onCreateWebView: ((WKWebViewConfiguration, WKNavigationAction) -> WKWebView?)?
    var onDidClose: ((WKWebView) -> Void)?
    
    var onShowAlert: ((String, @escaping () -> Void) -> Void)?
    var onShowConfirm: ((String, @escaping (Bool) -> Void) -> Void)?
    var onShowPrompt: ((String, String?, @escaping (String?) -> Void) -> Void)?
    
    // MARK: - WKUIDelegate Methods (New Window Creation)
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        return onCreateWebView?(configuration, navigationAction)
    }

    func webViewDidClose(_ webView: WKWebView) {
        onDidClose?(webView)
    }

    // MARK: - WKUIDelegate Methods (JavaScript Panels)
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        if let onShowAlert = onShowAlert {
            onShowAlert(message, completionHandler)
        } else {
            // 핸들러가 없으면 아무 작업 없이 즉시 완료 처리
            completionHandler()
        }
    }

    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        if let onShowConfirm = onShowConfirm {
            onShowConfirm(message, completionHandler)
        } else {
            // 핸들러가 없으면 'false'(취소)를 기본값으로 완료 처리
            completionHandler(false)
        }
    }

    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        if let onShowPrompt = onShowPrompt {
            onShowPrompt(prompt, defaultText, completionHandler)
        } else {
            // 핸들러가 없으면 'nil'(취소)을 기본값으로 완료 처리
            completionHandler(nil)
        }
    }
}

// MARK: - Internal Extension
internal extension WKWebView {
    /// `WKWebView`에 대한 `WebViewUIDelegateHandler`를 가져오거나 생성합니다.
    /// 이 핸들러는 `uiDelegate`로 자동 설정됩니다.
    var uiDelegateHandler: WebViewUIDelegateHandler {
        // self를 잠금 기준으로 사용하여, 여러 스레드가 동시 접근하는 것을 막습니다.
        objc_sync_enter(self)
        // 이 코드 블록이 어떤 방식으로든 종료될 때, 잠금을 해제하도록 보장합니다.
        defer { objc_sync_exit(self) }

        // 핸들러가 이미 생성되었는지 다시 확인합니다.
        if let handler = objc_getAssociatedObject(self, &AssociatedKeys.uiDelegateKey) as? WebViewUIDelegateHandler {
            return handler
        }
        
        // 핸들러가 없으면 새로 생성하고 등록합니다.
        let handler = WebViewUIDelegateHandler()
        objc_setAssociatedObject(self, &AssociatedKeys.uiDelegateKey, handler, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        self.uiDelegate = handler
        return handler
    }
}

// MARK: - Public Declarative API
public extension WKWebView {
    /// 웹뷰에서 JavaScript `alert`, `confirm`, `prompt` 패널이 호출될 때 실행될 액션을 설정합니다.
    ///
    /// - Warning: 클로저 내에서 `self`를 참조할 경우, 메모리 누수를 방지하기 위해 `[weak self]`를 사용해야 합니다.
    /// - Note: 이 클로저는 메인 스레드에서 호출됩니다.
    /// - Parameter action: `JavaScriptPanel` enum을 파라미터로 받는 클로저.
    ///   사용자는 `switch` 구문을 통해 각 패널 타입에 맞는 UI를 구현하고,
    ///   반드시 연관 값으로 전달된 `completion` 클로저를 호출해야 합니다.
    /// - Returns: 체이닝을 위한 WKWebView 인스턴스.
    @MainActor
    @discardableResult
    func onShowJavaScriptPanel(_ action: @escaping (JavaScriptPanel) -> Void) -> Self {
        uiDelegateHandler.onShowAlert = { message, completion in
            action(.alert(message: message, completion: completion))
        }
        uiDelegateHandler.onShowConfirm = { message, completion in
            action(.confirm(message: message, completion: completion))
        }
        uiDelegateHandler.onShowPrompt = { prompt, defaultText, completion in
            action(.prompt(prompt: prompt, defaultText: defaultText, completion: completion))
        }
        return self
    }

    /// `onNewWindow(_ create: ...)` 또는 `onNewWindow(_ create: ..., didClose: ...)`를 통해 생성된
    /// 새 웹뷰(창)가 닫혔을 때 실행될 액션을 설정합니다.
    ///
    /// - Warning: 클로저 내에서 `self`를 참조할 경우, 메모리 누수를 방지하기 위해 `[weak self]`를 사용해야 합니다.
    /// - Note: 이 클로저는 메인 스레드에서 호출됩니다.
    /// - Parameter close: 닫힌 `WKWebView` 인스턴스를 파라미터로 받는 클로저.
    /// - Returns: 체이닝을 위한 WKWebView 인스턴스.
    @MainActor
    @discardableResult
    func onNewWindowDidClose(_ close: @escaping (WKWebView) -> Void) -> Self {
        uiDelegateHandler.onDidClose = close
        return self
    }

    /// 웹페이지에서 새 창(웹뷰) 생성을 요청할 때 실행될 액션을 설정합니다。
    ///
    /// 이 메소드는 새 창이 닫힐 때의 동작은 설정하지 않습니다.
    ///
    /// - Warning: 클로저 내에서 `self`를 참조할 경우, 메모리 누수를 방지하기 위해 `[weak self]`를 사용해야 합니다.
    /// - Note: 이 클로저는 메인 스레드에서 호출됩니다.
    /// - Parameter create: `WKWebViewConfiguration`과 `WKNavigationAction`을 파라미터로 받고
    ///   생성된 `WKWebView` 인스턴스를 반환하는 클로저.
    ///   **반환된 `WKWebView` 인스턴스는 반드시 뷰 계층에 추가되어야 합니다.**
    ///   새 웹뷰를 생성하여 반환하면 해당 웹뷰에 페이지가 로드되고, `nil`을 반환하면 새 창 생성이 취소됩니다.
    /// - Returns: 체이닝을 위한 WKWebView 인스턴스.
    @MainActor
    @discardableResult
    func onNewWindow(_ create: @escaping (WKWebViewConfiguration, WKNavigationAction) -> WKWebView?) -> Self {
        uiDelegateHandler.onCreateWebView = create
        return self
    }

    /// 웹페이지에서 새 창(웹뷰) 생성을 요청할 때와 해당 웹뷰가 닫힐 때 실행될 액션을 모두 설정합니다。
    ///
    /// - Warning: 클로저 내에서 `self`를 참조할 경우, 메모리 누수를 방지하기 위해 `[weak self]`를 사용해야 합니다.
    /// - Note: 이 클로저는 메인 스레드에서 호출됩니다.
    /// - Parameters:
    ///   - create: `WKWebViewConfiguration`과 `WKNavigationAction`을 파라미터로 받고
    ///     생성된 `WKWebView` 인스턴스를 반환하는 클로저.
    ///     **반환된 `WKWebView` 인스턴스는 반드시 뷰 계층에 추가되어야 합니다.**
    ///     새 웹뷰를 생성하여 반환하면 해당 웹뷰에 페이지가 로드되고, `nil`을 반환하면 새 창 생성이 취소됩니다.
    ///   - didClose: 닫힌 `WKWebView` 인스턴스를 파라미터로 받는 클로저.
    /// - Returns: 체이닝을 위한 WKWebView 인스턴스.
    @MainActor
    @discardableResult
    func onNewWindow(_ create: @escaping (WKWebViewConfiguration, WKNavigationAction) -> WKWebView?, didClose: @escaping (WKWebView) -> Void) -> Self {
        uiDelegateHandler.onCreateWebView = create
        uiDelegateHandler.onDidClose = didClose
        return self
    }
}
