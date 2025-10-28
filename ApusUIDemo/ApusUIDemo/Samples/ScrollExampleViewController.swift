//
//  ScrollExampleViewController.swift
//  ApusUIDemo
//
//  Created by SwiftDevelop on 10/27/25.
//

import SwiftUI
import ApusUI

final class ScrollExampleViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view
            .subviews {
                UIScrollView()
                    .contentInset(left: 16, right: -16)
                    .subviews {
                        UIStackView(axis: .vertical)
                            .arrangedSubviews(100) { index in
                                UILabel("Hello, ApusUI! \(index)")
                                    .frame(height: 50)
                                UIView()
                                    .backgroundColor(.lightGray)
                                    .frame(height: 1)
                            }
                            .frame(width: view.frame.width)
                            .padding()
                    }
                    .onContentOffsetChange { point in
                        print(point)
                    }
                    .padding()
            }
    }
}

#Preview {
    UIViewControllerPreview {
        ScrollExampleViewController()
    }
}
