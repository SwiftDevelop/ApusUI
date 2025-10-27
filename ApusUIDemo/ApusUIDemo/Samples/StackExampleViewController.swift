//
//  StackExampleViewController.swift
//  ApusUIDemo
//
//  Created by SwiftDevelop on 10/24/25.
//

import UIKit
import SwiftUI
import ApusUI

final class StackExampleViewController: UIViewController {
    
    private let colors: [UIColor] = [.red, .orange, .yellow, .green, .blue, .purple]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view
            .backgroundColor(.white)
            .subviews {
                UIStackView(axis: .vertical, alignment: .fill, spacing: 0)
//                    .arrangedSubviews {
//                        UIView()
//                            .backgroundColor(.red)
//                        UIView()
//                            .backgroundColor(.orange)
//                        UIView()
//                            .backgroundColor(.yellow)
//                        UIView()
//                            .backgroundColor(.green)
//                        UIView()
//                            .backgroundColor(.blue)
//                        UIView()
//                            .backgroundColor(.purple)
//                    }
                
//                    .arrangedSubviews(colors.count) { index in
//                        UIView()
//                            .backgroundColor(colors[index])
//                    }
                
                    .arrangedSubviews(colors) { color in
                        UIStackView()
                            .arrangedSubviews(10) { index in
                                let alpha: CGFloat = 0.1 + (CGFloat(index) * 0.1)
                                UIView()
                                    .backgroundColor(color.withAlphaComponent(alpha))
                            }
                            .distribution(.fillEqually)
                    }
                    .distribution(.fillEqually)
                    .padding()
            }
    }
}

#Preview {
    UIViewControllerPreview {
        StackExampleViewController()
    }
}
