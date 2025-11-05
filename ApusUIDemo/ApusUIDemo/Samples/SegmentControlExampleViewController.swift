//
//  SegmentControlExampleViewController.swift
//  ApusUI
//
//  Created by SwiftDevelop on 11/5/25.
//

import SwiftUI
import ApusUI

final class SegmentControlExampleViewController: UIViewController {
    
    private let colorView = UIView()
    private let colors: [String] = ["Red", "Green", "Blue"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.subviews {
            UIStackView(.vertical) {
                UISegmentedControl(items: colors) { [weak self] index in
                    self?.updateColorView(at: index)
                }
                .selectedSegmentIndex(0)
                .frame(height: 48)
                
                colorView
            }
            .spacing(16)
            .padding(16)
        }
    }
    
    private func updateColorView(at index: Int) {
        let color = colors[index]
        switch color {
        case "Red":
            colorView.backgroundColor(.red)
        case "Green":
            colorView.backgroundColor(.green)
        case "Blue":
            colorView.backgroundColor(.blue)
        default:
            break
        }
    }
}

#Preview {
    UIViewControllerPreview {
        SegmentControlExampleViewController()
    }
}
