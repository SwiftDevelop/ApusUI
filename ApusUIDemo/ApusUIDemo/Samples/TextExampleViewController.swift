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
                
                UIStackView(axis: .vertical, alignment: .center)
                    .arrangedSubviews(10) { index in
                        UILabel("Hello, ApusUI \(index)")
                    }
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
