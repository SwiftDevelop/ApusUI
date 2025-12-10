//
//  AlertExampleViewController.swift
//  ApusUIDemo
//
//  Created by SwiftDevelop on 12/4/25.
//

import SwiftUI
import ApusUI

final class AlertExampleViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.subviews {
            UIStackView(.vertical, spacing: 24) {
                UIButton { [weak self] _ in
                    guard let self = self else { return }
                    for i in 0..<3 {
                        UIAlertController(style: .alert)
                            .title("Login \(i)")
                            .message("Please enter your credentials.")
                            .addTextField { $0.placeholder = "ID" }
                            .addTextField { $0.placeholder = "Password"; $0.isSecureTextEntry = true }
                            .addActionWithTextFields(title: "OK") { texts in
                                print("Entered texts: \(texts)")
                            }
                            .addAction(title: "Cancel", style: .cancel)
                            .present(from: self)
                    }
                }
                .title("Show Alert")
                .backgroundColor(.systemBlue)
                
                UIButton { [weak self] _ in
                    guard let self = self else { return }
                    for i in 0..<3 {
                        UIAlertController(style: .actionSheet)
                            .title("ActionSheet \(i)")
                            .message("This is Message!")
                            .addAction(title: "OK")
                            .addAction(title: "Cancel", style: .cancel)
                            .present(from: self)
                    }
                }
                .title("Show ActionSheet")
                .backgroundColor(.systemBlue)
            }
            .distribution(.fillEqually)
            .frame(height: 128)
            .padding(horizontal: 32)
            .centerY()
        }
    }
}

#Preview {
    UIViewControllerPreview {
        AlertExampleViewController()
    }
}
