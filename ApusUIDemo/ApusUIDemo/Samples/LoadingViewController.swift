//
//  LoadingViewController.swift
//  ApusUI
//
//  Created by SwiftDevelop on 11/3/25.
//

import SwiftUI
import ApusUI

final class LoadingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.subviews {
            UIActivityIndicatorView(style: .large)
                .color(.systemBlue)
                .isAnimating(true)
                .center()
        }
    }
}

#Preview {
    UIViewControllerPreview {
        LoadingViewController()
    }
}
