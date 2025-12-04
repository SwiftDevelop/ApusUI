//
//  WKWebView+KVO.swift
//  ApusUI
//
//  Created by SwiftDevelop on 2025/12/01.
//

import WebKit
import UIKit
import Foundation

// MARK: - AssociatedKeys
@MainActor private enum AssociatedKeys {
    static var estimatedProgressObservationKey: UInt8 = 0
    static var canGoBackObservationKey: UInt8 = 1
    static var canGoForwardObservationKey: UInt8 = 2
}

// MARK: - WKWebView KVOObserver
@MainActor
private final class WKWebViewKVOObserver<Value: Sendable>: NSObject {
    private let action: @MainActor (Value) -> Void
    private var observation: NSKeyValueObservation?

    init(
        webView: WKWebView,
        keyPath: KeyPath<WKWebView, Value>,
        action: @escaping @MainActor (Value) -> Void
    ) {
        self.action = action
        super.init()
        self.observation = webView.observe(keyPath, options: [.new]) { [weak self] _, change in
            guard let self, let value = change.newValue else { return }
            // The observation block may not be on the main thread.
            // Dispatch to the main actor to be safe.
            Task { @MainActor in
                self.action(value)
            }
        }
    }

    deinit {
        observation?.invalidate()
    }
}

// MARK: - KVO Extensions
public extension WKWebView {
    /// `estimatedProgress` 값이 변경될 때마다 호출될 액션을 등록합니다.
    ///
    /// - Warning: 클로저 내에서 `self`를 참조할 경우, 메모리 누수를 방지하기 위해 `[weak self]`를 사용해야 합니다.
    /// - Parameter action: `estimatedProgress`의 새 `Double` 값을 파라미터로 받는 클로저입니다 (0.0 ~ 1.0).
    /// - Returns: 체이닝을 위한 `WKWebView` 인스턴스.
    @MainActor
    @discardableResult
    func onProgress(_ action: @escaping @MainActor (Double) -> Void) -> Self {
        var observers = objc_getAssociatedObject(self, &AssociatedKeys.estimatedProgressObservationKey) as? [WKWebViewKVOObserver<Double>] ?? []

        let observer = WKWebViewKVOObserver<Double>(webView: self, keyPath: \.estimatedProgress, action: action)
        observers.append(observer)

        objc_setAssociatedObject(self, &AssociatedKeys.estimatedProgressObservationKey, observers, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        return self
    }

    /// `canGoBack` 속성값이 변경될 때마다 호출될 액션을 등록합니다.
    ///
    /// - Warning: 클로저 내에서 `self`를 참조할 경우, 메모리 누수를 방지하기 위해 `[weak self]`를 사용해야 합니다.
    /// - Parameter action: `canGoBack`의 새 `Bool` 값을 파라미터로 받는 클로저입니다.
    /// - Returns: 체이닝을 위한 `WKWebView` 인스턴스.
    @MainActor
    @discardableResult
    func onCanGoBackChange(_ action: @escaping @MainActor (Bool) -> Void) -> Self {
        var observers = objc_getAssociatedObject(self, &AssociatedKeys.canGoBackObservationKey) as? [WKWebViewKVOObserver<Bool>] ?? []

        let observer = WKWebViewKVOObserver<Bool>(webView: self, keyPath: \.canGoBack, action: action)
        observers.append(observer)

        objc_setAssociatedObject(self, &AssociatedKeys.canGoBackObservationKey, observers, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        return self
    }

    /// `canGoForward` 속성값이 변경될 때마다 호출될 액션을 등록합니다.
    ///
    /// - Warning: 클로저 내에서 `self`를 참조할 경우, 메모리 누수를 방지하기 위해 `[weak self]`를 사용해야 합니다.
    /// - Parameter action: `canGoForward`의 새 `Bool` 값을 파라미터로 받는 클로저입니다.
    /// - Returns: 체이닝을 위한 `WKWebView` 인스턴스.
    @MainActor
    @discardableResult
    func onCanGoForwardChange(_ action: @escaping @MainActor (Bool) -> Void) -> Self {
        var observers = objc_getAssociatedObject(self, &AssociatedKeys.canGoForwardObservationKey) as? [WKWebViewKVOObserver<Bool>] ?? []

        let observer = WKWebViewKVOObserver<Bool>(webView: self, keyPath: \.canGoForward, action: action)
        observers.append(observer)

        objc_setAssociatedObject(self, &AssociatedKeys.canGoForwardObservationKey, observers, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        return self
    }
}
