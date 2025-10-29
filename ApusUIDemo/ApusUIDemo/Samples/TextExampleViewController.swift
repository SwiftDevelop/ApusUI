//
//  TextExampleViewController.swift
//  ApusUI
//
//  Created by SwiftDevelop on 10/27/25.
//

import SwiftUI
import ApusUI

final class TextExampleViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view
            .subviews {
//                UILabel("Hello, ApusUI!")
//                    .center()
                
                UIStackView(.vertical, count: 10) { index in
                    UILabel("Hello, ApusUI \(index)")
                }
                .alignment(.center)
                .distribution(.fillEqually)
                .padding()
            }
    }
}

#Preview {
    UIViewControllerPreview {
        TextExampleViewController()
    }
}
