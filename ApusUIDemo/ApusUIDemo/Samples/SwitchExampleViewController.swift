//
//  SwitchExampleViewController.swift
//  ApusUI
//
//  Created by SwiftDevelop on 11/3/25.
//

import SwiftUI
import ApusUI

final class SwitchExampleViewController: UIViewController {
    
    private let textLabel: UILabel = {
        UILabel("Switch Off")
            .textColor(.darkText)
            .font(size: 20, weight: .semibold)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.subviews {
            UIStackView(.vertical) {
                textLabel
                UISwitch { [weak self] isOn in
                    self?.textLabel.text("Switch \(isOn ? "On" : "Off")")
                }
                .center()
            }
            .alignment(.center)
            .spacing(8)
            .center()
        }
    }
}

#Preview {
    UIViewControllerPreview {
        SwitchExampleViewController()
    }
}
