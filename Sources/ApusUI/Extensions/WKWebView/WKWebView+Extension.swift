//
//  WKWebView+Extension.swift
//  ApusUI
//
//  Created by SwiftDevelop on 2025/11/26.
//

import WebKit
import UIKit

// MARK: - Initialization
public extension WKWebView {
    /// `WKWebViewConfiguration`을 사용하여 웹뷰를 생성하고, 선택적으로 URL을 로드합니다.
    ///
    /// - Parameters:
    ///   - url: 로드할 `URL` 객체. `nil`이면 초기화만 수행합니다.
    ///   - configuration: `WKWebViewConfiguration`을 설정하기 위한 클로저.
    convenience init(url: URL?, configuration: ((WKWebViewConfiguration) -> Void)? = nil) {
        let webViewConfiguration = WKWebViewConfiguration()
        configuration?(webViewConfiguration)
        self.init(frame: .zero, configuration: webViewConfiguration)
        if let url = url {
            self.load(URLRequest(url: url))
        }
    }

    /// `WKWebViewConfiguration`을 사용하여 웹뷰를 생성하고, 선택적으로 URL 문자열을 로드합니다.
    ///
    /// - Parameters:
    ///   - urlString: 로드할 `String` 형태의 URL. 유효한 URL이 아니면 로드되지 않습니다.
    ///   - configuration: `WKWebViewConfiguration`을 설정하기 위한 클로저.
    convenience init(urlString: String, configuration: ((WKWebViewConfiguration) -> Void)? = nil) {
        let webViewConfiguration = WKWebViewConfiguration()
        configuration?(webViewConfiguration)
        self.init(frame: .zero, configuration: webViewConfiguration)
        if let url = URL(string: urlString) {
            self.load(URLRequest(url: url))
        }
    }

    // MARK: - Loading
    /// 지정된 `URL`을 `WKWebView`에 로드합니다.
    ///
    /// - Parameter url: 로드할 `URL` 객체.
    /// - Returns: 체이닝을 위한 `WKWebView` 인스턴스.
    @discardableResult
    func load(_ url: URL) -> Self {
        self.load(URLRequest(url: url))
        return self
    }
    
    /// 지정된 URL 문자열을 `WKWebView`에 로드합니다.
    ///
    /// - Parameter urlString: 로드할 URL 문자열.
    /// - Returns: 체이닝을 위한 `WKWebView` 인스턴스.
    @discardableResult
    func load(_ urlString: String) -> Self {
        if let url = URL(string: urlString) {
            self.load(URLRequest(url: url))
        }
        return self
    }
}

// MARK: - JavaScript Interaction
public extension WKWebView {
    /// 웹뷰에서 JavaScript 코드를 실행하고 그 결과를 비동기적으로 받습니다.
    ///
    /// - Warning: 클로저 내에서 `self`를 참조할 경우, 메모리 누수를 방지하기 위해 `[weak self]`를 사용해야 합니다.
    /// - Note: 이 메소드는 메인 스레드에서 호출되어야 하며, `completion` 클로저도 메인 스레드에서 실행됩니다.
    /// - Parameters:
    ///   - script: 웹뷰 내에서 실행할 JavaScript 코드 문자열.
    ///   - completion: JavaScript 실행 결과(`Any?`) 또는 에러(`Error`)를 `Result` 타입으로 받는 클로저.
    ///                 결과가 없는 성공적인 실행의 경우 `Result.success(nil)`로 전달됩니다.
    /// - Returns: 체이닝을 위한 `WKWebView` 인스턴스.
    @MainActor
    @discardableResult
    func evaluateJavaScript(_ script: String, completion: ((Result<Any?, Error>) -> Void)? = nil) -> Self {
        self.evaluateJavaScript(script) { result, error in
            if let error = error {
                completion?(.failure(error))
            } else {
                completion?(.success(result))
            }
        }
        return self
    }
}

// MARK: - Delegate Connectors
public extension WKWebView {
    /// `WKWebView`의 `navigationDelegate`를 설정합니다.
    ///
    /// - Parameter delegate: `navigationDelegate`로 설정할 객체.
    /// - Returns: 체이닝을 위한 `WKWebView` 인스턴스.
    @discardableResult
    func navigationDelegate(_ delegate: WKNavigationDelegate?) -> Self {
        self.navigationDelegate = delegate
        return self
    }

    /// `WKWebView`의 `uiDelegate`를 설정합니다.
    ///
    /// - Parameter delegate: `uiDelegate`로 설정할 객체.
    /// - Returns: 체이닝을 위한 `WKWebView` 인스턴스.
    @discardableResult
    func uiDelegate(_ delegate: WKUIDelegate?) -> Self {
        self.uiDelegate = delegate
        return self
    }
}
