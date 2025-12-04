//
//  WKWebView+NavigationDelegate.swift
//  ApusUI
//
//  Created by SwiftDevelop on 2025/11/25.
//

import WebKit
import UIKit

// MARK: - Enums
public enum NavigationState {
    /// 웹뷰가 탐색을 시작했을 때의 상태입니다.
    case didStartProvisional(webView: WKWebView, navigation: WKNavigation)
    /// 웹뷰가 콘텐츠 로딩을 시작했음을 커밋했을 때의 상태입니다.
    case didCommit(webView: WKWebView, navigation: WKNavigation)
    /// 웹뷰의 메인 프레임 탐색이 완료되었을 때의 상태입니다.
    case didFinish(webView: WKWebView, navigation: WKNavigation)
    /// 초기 탐색 중 오류가 발생했을 때의 상태입니다.
    case didFailProvisional(webView: WKWebView, navigation: WKNavigation, error: Error)
    /// 콘텐츠를 로드하는 중 오류가 발생했을 때의 상태입니다.
    case didFail(webView: WKWebView, navigation: WKNavigation, error: Error)
}

public enum NavigationActionPolicy {
    case allow, cancel
}

public enum NavigationResponsePolicy {
    case allow
    case cancel
    @available(iOS 14.5, macOS 11.3, *)
    case download
}

// MARK: - AssociatedKeys
@MainActor private enum AssociatedKeys {
    static var navigationDelegateKey: UInt8 = 0
}

// MARK: - Delegate Handler
/// WKNavigationDelegate 프로토콜을 선언형 방식으로 처리하기 위한 핸들러 클래스.
internal final class WebViewNavigationDelegateHandler: NSObject, WKNavigationDelegate {
    
    // MARK: - Properties
    var onNavigation: ((NavigationState) -> Void)?
    var onDecidePolicyForAction: ((WKNavigationAction) -> NavigationActionPolicy)?
    var onDecidePolicyForResponse: ((WKNavigationResponse) -> NavigationResponsePolicy)?
    var onReceiveAuthChallenge: ((URLAuthenticationChallenge, @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) -> Void)?
    var onProcessDidTerminate: ((WKWebView) -> Void)?
    
    // MARK: - WKNavigationDelegate: State Reporting
    /// 웹뷰가 페이지 탐색을 시작할 때 호출됩니다.
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        onNavigation?(.didStartProvisional(webView: webView, navigation: navigation))
    }
    
    /// 웹뷰가 콘텐츠를 받기 시작할 때 호출됩니다.
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        onNavigation?(.didCommit(webView: webView, navigation: navigation))
    }
    
    /// 웹뷰 탐색이 완료되면 호출됩니다.
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        onNavigation?(.didFinish(webView: webView, navigation: navigation))
    }

    /// 웹뷰 탐색 중 오류가 발생하면 호출됩니다.
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        onNavigation?(.didFail(webView: webView, navigation: navigation, error: error))
    }
    
    /// 페이지를 로드하는 초기 단계에서 오류가 발생하면 호출됩니다.
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        onNavigation?(.didFailProvisional(webView: webView, navigation: navigation, error: error))
    }
    
    // MARK: - WKNavigationDelegate: Policy Decisions
    /// 탐색 허용 여부를 결정하기 위해 호출됩니다.
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let policy = onDecidePolicyForAction?(navigationAction) {
            switch policy {
            case .allow:
                decisionHandler(.allow)
            case .cancel:
                decisionHandler(.cancel)
            }
        } else {
            decisionHandler(.allow)
        }
    }
    
    /// 탐색 응답을 받은 후 허용 여부를 결정하기 위해 호출됩니다.
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if let policy = onDecidePolicyForResponse?(navigationResponse) {
            switch policy {
            case .allow:
                decisionHandler(.allow)
            case .cancel:
                decisionHandler(.cancel)
            case .download:
                if #available(iOS 14.5, macOS 11.3, *) {
                    decisionHandler(.download)
                } else {
                    // .download를 지원하지 않는 하위 버전에서는 기본값으로 .allow 처리
                    decisionHandler(.allow)
                }
            }
        } else {
            decisionHandler(.allow)
        }
    }
    
    // MARK: - WKNavigationDelegate: Authentication
    /// 웹뷰가 서버로부터 인증을 요구받았을 때 호출됩니다.
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if let onReceiveAuthChallenge = onReceiveAuthChallenge {
            onReceiveAuthChallenge(challenge, completionHandler)
        } else {
            completionHandler(.performDefaultHandling, nil)
        }
    }
    
    // MARK: - WKNavigationDelegate: Process Termination
    /// 웹뷰의 콘텐츠 프로세스가 비정상 종료되었을 때 호출됩니다.
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        onProcessDidTerminate?(webView)
    }
}

// MARK: - Internal Extension
internal extension WKWebView {
    /// `WKWebView`에 대한 `WebViewNavigationDelegateHandler`를 가져오거나 생성합니다.
    /// 이 핸들러는 `navigationDelegate`로 자동 설정됩니다.
    var navigationDelegateHandler: WebViewNavigationDelegateHandler {
        // self를 잠금 기준으로 사용하여, 여러 스레드가 동시 접근하는 것을 막습니다.
        objc_sync_enter(self)
        // 이 코드 블록이 어떤 방식으로든 종료될 때, 잠금을 해제하도록 보장합니다.
        defer { objc_sync_exit(self) }

        // 핸들러가 이미 생성되었는지 다시 확인합니다.
        if let handler = objc_getAssociatedObject(self, &AssociatedKeys.navigationDelegateKey) as? WebViewNavigationDelegateHandler {
            return handler
        }
        
        // 핸들러가 없으면 새로 생성하고 등록합니다.
        let handler = WebViewNavigationDelegateHandler()
        objc_setAssociatedObject(self, &AssociatedKeys.navigationDelegateKey, handler, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        self.navigationDelegate = handler
        return handler
    }
}

// MARK: - Public Declarative API
public extension WKWebView {
    /// 웹뷰의 탐색 상태 변경에 따라 실행될 액션을 설정합니다.
    ///
    /// - Parameter action: `NavigationState`를 파라미터로 받는 클로저.
    /// - Returns: 체이닝을 위한 WKWebView 인스턴스.
    @MainActor
    @discardableResult
    func onNavigation(_ action: @escaping (NavigationState) -> Void) -> Self {
        navigationDelegateHandler.onNavigation = action
        return self
    }
    
    /// 탐색 액션에 대한 정책을 결정하는 클로저를 설정합니다.
    ///
    /// - Parameter decision: `WKNavigationAction`을 받아 `NavigationActionPolicy`를 반환하는 클로저.
    /// - Returns: 체이닝을 위한 WKWebView 인스턴스.
    @MainActor
    @discardableResult
    func onDecidePolicyForAction(_ decision: @escaping (WKNavigationAction) -> NavigationActionPolicy) -> Self {
        navigationDelegateHandler.onDecidePolicyForAction = decision
        return self
    }
    
    /// 탐색 응답에 대한 정책을 결정하는 클로저를 설정합니다.
    ///
    /// - Parameter decision: `WKNavigationResponse`를 받아 `NavigationResponsePolicy`를 반환하는 클로저.
    /// - Returns: 체이닝을 위한 WKWebView 인스턴스.
    @MainActor
    @discardableResult
    func onDecidePolicyForResponse(_ decision: @escaping (WKNavigationResponse) -> NavigationResponsePolicy) -> Self {
        navigationDelegateHandler.onDecidePolicyForResponse = decision
        return self
    }
    
    /// 웹뷰가 서버로부터 인증을 요구받았을 때 실행될 액션을 설정합니다.
    ///
    /// - Parameter action: `URLAuthenticationChallenge`와 `completionHandler`를 파라미터로 받는 클로저.
    ///   클로저 내부에서 반드시 `completionHandler`를 호출해야 합니다.
    /// - Returns: 체이닝을 위한 WKWebView 인스턴스.
    @MainActor
    @discardableResult
    func onReceiveAuthChallenge(_ action: @escaping (URLAuthenticationChallenge, @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) -> Void) -> Self {
        navigationDelegateHandler.onReceiveAuthChallenge = action
        return self
    }

    /// 웹뷰의 콘텐츠 프로세스가 비정상 종료되었을 때 실행될 액션을 설정합니다.
    ///
    /// - Parameter action: 종료된 `WKWebView` 인스턴스를 파라미터로 받는 클로저.
    /// - Returns: 체이닝을 위한 WKWebView 인스턴스.
    @MainActor
    @discardableResult
    func onProcessDidTerminate(_ action: @escaping (WKWebView) -> Void) -> Self {
        navigationDelegateHandler.onProcessDidTerminate = action
        return self
    }
}
