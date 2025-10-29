//
//  StackExampleViewController.swift
//  ApusUIDemo
//
//  Created by SwiftDevelop on 10/24/25.
//

import SwiftUI
import ApusUI

final class StackExampleViewController: UIViewController {
    
    private let colors: [UIColor] = [.red, .orange, .yellow, .green, .blue, .purple]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view
            .backgroundColor(.white)
            .subviews {
//                UIStackView(axis: .vertical, alignment: .fill, spacing: 0)
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
//                    .arrangedSubviews(colors) { color in
//                        UIStackView()
//                            .arrangedSubviews(10) { index in
//                                let alpha: CGFloat = 0.1 + (CGFloat(index) * 0.1)
//                                UIView()
//                                    .backgroundColor(color.withAlphaComponent(alpha))
//                            }
//                            .distribution(.fillEqually)
//                    }
//                    .distribution(.fillEqually)
//                    .padding()
                
                makeSimpleStackView()
//                makeCountedStackView()
//                makeDataDrivenStackView()
//                makeMixedStackView()
                    .distribution(.fillEqually)
                    .padding()
            }
    }
    
    private func makeSimpleStackView() -> UIStackView {
        UIStackView(.vertical) {
            UIView(.red)
            UIView(.orange)
            UIView(.yellow)
            UIView(.green)
            UIView(.blue)
            UIView(.purple)
        }
        .alignment(.fill)
        .spacing(0)
    }
    
    private func makeCountedStackView() -> UIStackView {
        UIStackView(.vertical, count: colors.count) { index in
            UIView(colors[index])
        }
        .alignment(.fill)
        .spacing(0)
    }
    
    private func makeDataDrivenStackView() -> UIStackView {
        UIStackView(.vertical, data: colors) { color in
            UIView(color)
        }
        .alignment(.fill)
        .spacing(0)
    }
    
    private func makeMixedStackView() -> UIStackView {
        UIStackView(.vertical, data: colors) { color in
            UIStackView(count: 10) { index in
                let alpha: CGFloat = 0.1 + (CGFloat(index) * 0.1)
                UIView(color.withAlphaComponent(alpha))
            }
            .distribution(.fillEqually)
        }
        .alignment(.fill)
        .spacing(0)
    }
}

#Preview {
    UIViewControllerPreview {
        StackExampleViewController()
    }
}
