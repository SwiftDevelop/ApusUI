//
//  TextExampleViewController.swift
//  ApusUI
//
//  Created by SwiftDevelop on 10/27/25.
//

import SwiftUI
import ApusUI

final class TextExampleViewController: UIViewController {
    
    private let textLabel = UILabel()
    private let textField = UITextField()
    private let textView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view
            .subviews {
                UIStackView(.vertical) {
                    textLabel
                        .text("텍스트를 입력하세요.")
                        .frame(height: 40)
                    
                    UIView()
                    
                    UIStackView(.horizontal) {
                        textField
                            .borderStyle(.roundedRect)
                            .placeholder("텍스트를 입력하세요.")
                        
                        UIButton(.systemBlue)
                            .onAction { [weak self] _ in
                                guard let self else { return }
                                textLabel.text(textField.text ?? "")
                            }
                            .title("완료")
                            .frame(width: 56)
                            .cornerRadius(12)
                    }
                    .spacing(16)
                    .frame(height: 40)
                    
                    UIView()
                    
                    textView
                        .font(size: 15)
                        .frame(height: 200)
                        .border(width: 1, color: .black.withAlphaComponent(0.1))
                        .cornerRadius(12)
                    
                    UIButton(.systemBlue)
                        .onAction { [weak self] _ in
                            guard let self else { return }
                            textLabel.text(textView.text)
                        }
                        .title("완료")
                        .frame(height: 40)
                        .cornerRadius(12)
                }
                .spacing(16)
                .distribution(.fill)
                .padding(24)
            }
    }
}

#Preview {
    UIViewControllerPreview {
        TextExampleViewController()
    }
}
