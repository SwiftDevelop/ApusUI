//
//  WKWebView+Extension.swift
//  ApusUI
//
//  Created by JJP on 2025/11/26.
//

import WebKit
import UIKit
import Foundation

// MARK: - AssociatedKeys for onProgress
@MainActor private enum ProgressAssociatedKeys {
    static var estimatedProgressObservationKey: UInt8 = 0
}

// MARK: - KVOObserver for estimatedProgress
@MainActor private final class WKWebViewProgressObserver: NSObject {
    private let action: @MainActor (Double) -> Void
    private var observation: NSKeyValueObservation?

    init(webView: WKWebView, action: @escaping @MainActor (Double) -> Void) {
        self.action = action
        super.init()
        self.observation = webView.observe(\.estimatedProgress, options: [.new]) { [weak self] _, change in
            guard let self, let value = change.newValue else { return }
            DispatchQueue.main.async {
                self.action(value)
            }
        }
    }

    deinit {
        observation?.invalidate()
    }
}

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
}

// MARK: - Extension for onProgress
public extension WKWebView {
    /// `estimatedProgress` 값이 변경될 때마다 호출될 액션을 등록합니다.
    ///
    /// - Warning: 클로저 내에서 `WKWebView`를 소유하는 객체(`self`)를 강하게 참조(`self` 사용)하면
    ///            강한 순환 참조(retain cycle)가 발생하여 메모리 릭으로 이어질 수 있습니다.
    ///            이를 방지하기 위해 클로저 캡처 리스트에 `[weak self]` 또는 `[unowned self]`를 사용하여
    ///            `self`를 약하게 또는 미소유 참조로 캡처해야 합니다.
    /// - Parameter action: `estimatedProgress`의 새 `Double` 값을 파라미터로 받는 클로저입니다 (0.0 ~ 1.0).
    /// - Returns: 체이닝을 위한 `WKWebView` 인스턴스.
    @MainActor
    @discardableResult
    func onProgress(_ action: @escaping @MainActor (Double) -> Void) -> Self {
        var observers = objc_getAssociatedObject(self, &ProgressAssociatedKeys.estimatedProgressObservationKey) as? [WKWebViewProgressObserver] ?? []

        let observer = WKWebViewProgressObserver(webView: self, action: action)
        observers.append(observer)

        objc_setAssociatedObject(self, &ProgressAssociatedKeys.estimatedProgressObservationKey, observers, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        return self
    }
}
