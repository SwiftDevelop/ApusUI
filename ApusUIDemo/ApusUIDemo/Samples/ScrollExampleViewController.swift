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
                UIScrollView {
                    UIStackView(.vertical, count: 100) { index in
                        UILabel("Hello, ApusUI! \(index)")
                            .frame(height: 50)
                        UIView(.lightGray)
                            .frame(height: 1)
                    }
                    .frame(width: view.frame.width)
                    .padding()
                }
                .contentInset(left: 16, right: -16)
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
