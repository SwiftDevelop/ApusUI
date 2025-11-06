//
//  SearchBarExampleViewController.swift
//  ApusUI
//
//  Created by SwiftDevelop on 11/5/25.
//

import SwiftUI
import ApusUI

final class SearchBarExampleViewController: UIViewController {
    
    private let textView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.subviews {
            UIStackView(.vertical) {
                UISearchBar(style: .minimal)
                    .placeholder("검색어를 입력하세요.")
                    .onChange { [weak self] text in
                        self?.textView.text(text)
                    }
                    .onEditingBegan { _ in
                        print("Editing Began")
                    }
                    .onEditingEnded { _ in
                        print("Editing Ended")
                    }
                    .onCancel(.automatic) {
                        print("Tapped Cancel")
                    }
                
                textView
                    .backgroundColor(.black.withAlphaComponent(0.05))
                    .font(size: 20)
                    .isEditable(false)
            }
            .spacing(16)
            .padding()
        }
    }
}

#Preview {
    UIViewControllerPreview {
        SearchBarExampleViewController()
    }
    .edgesIgnoringSafeArea(.bottom)
}
