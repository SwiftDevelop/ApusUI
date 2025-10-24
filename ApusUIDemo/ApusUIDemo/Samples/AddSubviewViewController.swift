//
//  AddSubviewViewController.swift
//  ApusUIDemo
//
//  Created by SwiftDevelop on 10/24/25.
//

import UIKit
import SwiftUI
import ApusUI

final class AddSubviewsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view
            .backgroundColor(.darkGray)
            .subviews {
                UIView()
                    .backgroundColor(.gray)
                    .frame(width: 200, height: 200)
                    .subviews {
                        UIView()
                            .backgroundColor(.lightGray)
                            .frame(width: 100, height: 100)
                            .center()
                    }
                    .center()
                
                UIView()
                    .backgroundColor(.white)
                    .frame(width: 50, height: 50)
                    .center()
            }
    }
}

#Preview {
    UIViewControllerPreview {
        AddSubviewsViewController()
    }
    .edgesIgnoringSafeArea(.all)
}
