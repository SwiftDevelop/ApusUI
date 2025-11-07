//
//  UIPreviewProvider.swift
//  ApusUI
//
//  Created by SwiftDevelop on 10/24/25.
//

import UIKit
import SwiftUI

#if DEBUG
/// SwiftUI Preview에서 UIView를 래핑하여 보여주는 `UIViewRepresentable`입니다.
public struct UIViewPreview<View: UIView>: UIViewRepresentable {
    public let view: View
    
    /// 뷰 빌더 클로저를 사용하여 Preview를 생성합니다.
    public init(_ builder: @escaping () -> View) {
        view = builder()
    }
    
    /// SwiftUI가 뷰를 생성할 때 호출됩니다.
    public func makeUIView(context: Context) -> View {
        return view
    }
    
    /// SwiftUI가 뷰를 업데이트할 때 호출됩니다.
    public func updateUIView(_ uiView: View, context: Context) {
        uiView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
}

/// SwiftUI Preview에서 UIViewController를 래핑하여 보여주는 `UIViewControllerRepresentable`입니다.
public struct UIViewControllerPreview<ViewController: UIViewController>: UIViewControllerRepresentable {
    public let viewController: ViewController
    
    /// 뷰 컨트롤러 빌더 클로저를 사용하여 Preview를 생성합니다.
    public init(_ builder: @escaping () -> ViewController) {
        viewController = builder()
    }
    
    /// SwiftUI가 뷰 컨트롤러를 생성할 때 호출됩니다.
    public func makeUIViewController(context: Context) -> ViewController {
        return viewController
    }
    
    /// SwiftUI가 뷰 컨트롤러를 업데이트할 때 호출됩니다.
    public func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        
    }
}
#endif
