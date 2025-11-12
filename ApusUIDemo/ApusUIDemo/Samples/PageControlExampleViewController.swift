//
//  PageControlExampleViewController.swift
//  ApusUI
//
//  Created by SwiftDevelop on 11/12/25.
//

import SwiftUI
import ApusUI

final class PageControlExampleViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        UIScrollView()
            .isPagingEnabled(true)
            .showsHorizontalScrollIndicator(false)
    }()
    
    private let pageControl: UIPageControl = {
        UIPageControl()
            .pageIndicatorTintColor(.lightGray)
            .currentPageIndicatorTintColor(.black)
    }()
    
    private let colors: [UIColor] = [.red, .blue, .green]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.subviews {
            scrollView
                .subviews {
                    UIStackView(.horizontal, data: colors) { color in
                        UIView(color)
                            .frame(width: view.frame.width, height: view.frame.height)
                    }
                    .padding()
                }
                .onContentOffsetChange { [weak self] offset in
                    guard let self else { return }
                    let page = Int(round(offset.x / view.frame.width))
                    pageControl.currentPage(page)
                }
                .padding()
                .edgesIgnoringSafeArea()
            
            pageControl
                .numberOfPages(colors.count)
                .onChange { [weak self] page in
                    guard let self else { return }
                    let point = CGPoint(x: CGFloat(page) * view.frame.width, y: 0)
                    scrollView.setContentOffset(point, animated: true)
                }
                .padding(horizontal: 0)
                .padding(bottom: 0)
        }
    }
}

#Preview {
    UIViewControllerPreview {
        PageControlExampleViewController()
    }
    .edgesIgnoringSafeArea(.all)
}
