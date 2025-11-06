//
//  ButtonExampleViewController.swift
//  ApusUIDemo
//
//  Created by SwiftDevelop on 10/27/25.
//

import SwiftUI
import ApusUI

final class ButtonExampleViewController: UIViewController {
    
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view
            .subviews {
                makeUnusingInit()
                    .backgroundColor(.systemBlue)
                    .frame(width: 200, height: 100)
                    .cornerRadius(16)
                    .center()
            }
    }
    
    private func makeUnusingInit() -> UIButton {
        UIButton()
            .title("Lock", for: .normal)
            .title("Unlock", for: .selected)
            .titleColor(.white)
            .font(size: 24, weight: .semibold)
            .image(systemName: "lock.fill", for: .normal)
            .image(systemName: "lock.open.fill", for: .selected)
            .tintColor(.white)
            .imageEdgeInsets(left: -2, right: 2)
            .titleEdgeInsets(left: 2, right: -2)
            .onAction { [weak self] button in
                self?.handleButtonAction(button)
            }
    }
    
    private func makeUsingInit() -> UIButton {
        UIButton { [weak self] button in
            self?.handleButtonAction(button)
        }
        .subviews {
            UIStackView(.horizontal) {
                iconImageView
                    .image(systemName: "lock.fill")
                    .tintColor(.white)
                titleLabel
                    .text("Lock")
                    .textColor(.white)
                    .font(size: 24, weight: .semibold)
            }
            .alignment(.center)
            .spacing(4)
            .center()
        }
    }
    
    private func makeUsingInitWithSubviews() -> UIButton {
        UIButton { [weak self] button in
            self?.handleButtonAction(button)
        } subviews: {
            UIStackView(.horizontal) {
                iconImageView
                    .image(systemName: "lock.fill")
                    .tintColor(.white)
                titleLabel
                    .text("Lock")
                    .textColor(.white)
                    .font(size: 24, weight: .semibold)
            }
            .alignment(.center)
            .spacing(4)
            .center()
        }
    }
    
    private func handleButtonAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        sender.backgroundColor(sender.isSelected ? .systemRed : .systemBlue)
        iconImageView.image(systemName: sender.isSelected ? "lock.open.fill" : "lock.fill")
        titleLabel.text(sender.isSelected ? "Unlock" : "Lock")
    }
}

#Preview {
    UIViewControllerPreview {
        ButtonExampleViewController()
    }
}
