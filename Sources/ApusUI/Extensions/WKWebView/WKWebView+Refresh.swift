//
//  WKWebView+Refresh.swift
//  ApusUI
//
//  Created by SwiftDevelop on 2025/11/25.
//

import WebKit
import UIKit

public extension WKWebView {
    /// `WKWebView`에 새로고침 컨트롤을 추가하고, 새로고침 시 실행될 액션을 설정합니다.
    ///
    /// - Warning: 클로저 내에서 `self`를 참조할 경우, 메모리 누수를 방지하기 위해 `[weak self]`를 사용해야 합니다.
    /// - Parameter action: 새로고침이 트리거될 때 실행될 클로저입니다. 클로저는 `WKWebView` 인스턴스와 `UIRefreshControl` 인스턴스를 파라미터로 받으며,
    ///                   비동기 작업 완료 후 `endRefreshing()`을 호출해야 합니다.
    /// - Returns: 체이닝을 위한 `WKWebView` 인스턴스.
    @discardableResult
    func onRefresh(_ action: @escaping (WKWebView, UIRefreshControl) -> Void) -> Self {
        let refreshControl = UIRefreshControl { [weak self] control in
            guard let self = self else { return }
            action(self, control)
        }
        self.scrollView.refreshControl = refreshControl
        return self
    }

    /// [사용자 정의] 제공된 `UIRefreshControl` 인스턴스를 사용하여 "pull-to-refresh" 기능을 추가합니다.
    ///
    /// 이 메서드는 사용자가 미리 커스텀한 `UIRefreshControl`에 액션을 설정하고 스크롤 뷰에 연결할 때 사용합니다.
    ///
    /// - Warning: 클로저 내에서 `self`를 참조할 경우, 메모리 누수를 방지하기 위해 `[weak self]`를 사용해야 합니다.
    /// - Parameters:
    ///   - control: 사용자가 직접 생성하고 설정한 `UIRefreshControl` 인스턴스.
    ///   - action: 새로고침이 트리거될 때 실행될 클로저입니다. 클로저는 `WKWebView` 인스턴스와 제공된 `UIRefreshControl` 인스턴스를 파라미터로 받습니다.
    /// - Returns: 체이닝을 위한 WKWebView 인스턴스.
    @discardableResult
    func onRefresh(control: UIRefreshControl, action: @escaping (WKWebView, UIRefreshControl) -> Void) -> Self {
        control.onChange { [weak self] innerControl in
            guard let self = self else { return }
            action(self, innerControl)
        }
        self.scrollView.refreshControl = control
        return self
    }
}
