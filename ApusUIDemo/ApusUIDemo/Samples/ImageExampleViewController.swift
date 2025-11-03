//
//  ImageExampleViewController.swift
//  ApusUI
//
//  Created by SwiftDevelop on 11/3/25.
//

import SwiftUI
import ApusUI

final class ImageExampleViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.subviews {
            UIImageView(systemName: "star.fill")
                .onTapGesture {
                    print("Star image view was tapped!")
                }
                .contentMode(.scaleAspectFill)
                .frame(width: 100, height: 100)
                .center()
        }
    }
}

#Preview {
    UIViewControllerPreview {
        ImageExampleViewController()
    }
}
