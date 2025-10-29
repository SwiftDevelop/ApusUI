//
//  AddSubviewExampleViewController.swift
//  ApusUIDemo
//
//  Created by SwiftDevelop on 10/24/25.
//

import SwiftUI
import ApusUI

final class AddSubviewExampleViewController: UIViewController {
    
    // MARK: UI Components
    
    private let whiteView: UIView = {
        UIView(.white)
            .frame(width: 50, height: 50)
            .center()
    }()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view
            .backgroundColor(.darkGray)
            .subviews {
                UIView(.gray) { view in
                    UIView(.lightGray)
                        .frame(width: 100, height: 100)
                        .center()
                }
                .frame(width: 200, height: 200)
                .center()
            }
    }
}

#Preview {
    UIViewControllerPreview {
        AddSubviewExampleViewController()
    }
    .edgesIgnoringSafeArea(.all)
}
