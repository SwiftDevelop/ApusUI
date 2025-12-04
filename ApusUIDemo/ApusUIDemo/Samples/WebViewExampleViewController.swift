//
//  WebViewExampleViewController.swift
//  ApusUIDemo
//
//  Created by SwiftDevelop on 2025/11/25.
//

import SwiftUI
import ApusUI
import WebKit

final class WebViewExampleViewController: UIViewController {
    
    private let webView: WKWebView = {
        WKWebView(urlString: "https://www.apple.com/kr/") { configuration in
            configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        }
    }()
    private let progressView = UIProgressView()
    private let goBackButton: UIButton = {
        UIButton().image(systemName: "chevron.left")
    }()
    private let goForwardButton: UIButton = {
        UIButton().image(systemName: "chevron.right")
    }()
    private let reloadButton: UIButton = {
        UIButton().image(systemName: "arrow.clockwise")
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.subviews {
            UIStackView(.vertical) {
                webView
                    .onNavigation { state in
                        switch state {
                        case .didStartProvisional(let webView, _):
                            print("Navigation started: \(webView.url?.absoluteString ?? "N/A")")
                        case .didCommit(let webView, _):
                            print("Navigation committed: \(webView.url?.absoluteString ?? "N/A")")
                        case .didFinish(let webView, _):
                            print("Page finished loading: \(webView.url?.absoluteString ?? "N/A")")
                        case .didFailProvisional(_, _, let error):
                            print("Provisional navigation failed: \(error.localizedDescription)")
                        case .didFail(_, _, let error):
                            print("Content loading failed: \(error.localizedDescription)")
                        }
                    }
                    .onDecidePolicyForAction { navigationAction -> NavigationActionPolicy in
                        // 외부 링크는 Safari에서 열기
                        if let url = navigationAction.request.url,
                           let host = url.host,
                           !host.contains("apple.com"),
                           navigationAction.navigationType == .linkActivated {
                            UIApplication.shared.open(url)
                            return .cancel
                        }
                        return .allow
                    }
                    .onRefresh { webView, refreshControl in
                        print("Refresh triggered!")
                        // Reload the web view
                        webView.reload()
                        
                        // End refreshing after a short delay
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            refreshControl.endRefreshing()
                        }
                    }
                    .onProgress { [weak self] value in
                        print("Progress: \(value)")
                        self?.progressView.progress = Float(value)
                        self?.progressView.progress(Float(value), animated: true)
                    }
                    .onCanGoBackChange { [weak self] canGoBack in
                        print("Can go back: \(canGoBack)")
                        guard canGoBack else { return }
                        self?.goBackButton.onAction { [weak self] _ in
                            self?.webView.goBack()
                        }
                    }
                    .onCanGoForwardChange { [weak self] canGoForward in
                        print("Can go forward: \(canGoForward)")
                        guard canGoForward else { return }
                        self?.goForwardButton.onAction { [weak self] _ in
                            self?.webView.goForward()
                        }
                    }
                
                UIStackView(.horizontal) {
                    goBackButton
                    goForwardButton
                    reloadButton
                        .onAction { [weak self] _ in
                            self?.webView.reload()
                        }
                }
                .distribution(.fillEqually)
                .frame(height: 50)
            }
            .padding()
            
            progressView
                .frame(height: 2)
                .padding(top: 0)
                .padding(horizontal: 0)
        }
    }
}

#Preview {
    UIViewControllerPreview {
        WebViewExampleViewController()
    }
}
