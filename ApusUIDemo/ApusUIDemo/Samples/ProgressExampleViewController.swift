//
//  ProgressExampleViewController.swift
//  ApusUI
//
//  Created by SwiftDevelop on 11/4/25.
//

import SwiftUI
import ApusUI

final class ProgressExampleViewController: UIViewController {
    
    private let progressView = UIProgressView()
    private let progessses: [Float] = [0.0, 0.25, 0.5, 0.75, 1.0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.subviews {
            UIStackView(.vertical) {
                progressView
                    .progress(0.0)
                    .frame(width: view.frame.width, height: 8)
                
                UIStackView(.vertical, data: progessses) { progress in
                    UIButton { [weak self] _ in
                        self?.progressView.progress(progress, animated: true)
                    }
                    .backgroundColor(.systemBlue)
                    .title("\(Int(progress * 100))%")
                    .titleColor(.white)
                    .frame(width: 100, height: 40)
                    .cornerRadius(8)
                }
                .spacing(24)
            }
            .alignment(.center)
            .spacing(24)
            .padding(top: 0, left: 0, right: 0)
        }
    }
}

#Preview {
    UIViewControllerPreview {
        ProgressExampleViewController()
    }
}
