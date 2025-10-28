//
//  ButtonExampleViewController.swift
//  ApusUIDemo
//
//  Created by SwiftDevelop on 10/27/25.
//

import SwiftUI
import ApusUI

final class ButtonExampleViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view
            .subviews {
                UIButton()
                    .addAction { [weak self] button in
                        button.isSelected.toggle()
                        self?.changeBackgroundColor(button)
                    }
                    .backgroundColor(.systemBlue)
                    .title("Lock", for: .normal)
                    .title("Unlock", for: .selected)
                    .titleColor(.white)
                    .font(size: 24, weight: .semibold)
                    .image(systemName: "lock.fill", for: .normal)
                    .image(systemName: "lock.open.fill", for: .selected)
                    .tintColor(.white)
                    .imageEdgeInsets(left: -2, right: 2)
                    .titleEdgeInsets(left: 2, right: -2)
                    .frame(width: 200, height: 100)
                    .cornerRadius(16)
                    .center()
            }
    }
    
    private func changeBackgroundColor(_ sender: UIButton) {
        sender.backgroundColor(sender.isSelected ? .systemRed : .systemBlue)
    }
}

#Preview {
    UIViewControllerPreview {
        ButtonExampleViewController()
    }
}
