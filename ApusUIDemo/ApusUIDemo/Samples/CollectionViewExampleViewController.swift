//
//  CollectionViewExampleViewController.swift
//  ApusUI
//
//  Created by SwiftDevelop on 11/17/25.
//

import SwiftUI
import ApusUI

final class CollectionViewExampleViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        UICollectionView(scrollDirection: .vertical)
            .register(UICollectionViewCell.self)
            .minimumSpacing(line: spacing, interItem: spacing)
            .contentInset(left: spacing, right: spacing)
            .refreshControl(refreshControl)
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        UIRefreshControl()
            .onChange { [weak self] in
                self?.refreshItems()
            }
    }()
    
    private var items: [UIColor] = [.red, .systemRed, .orange, .systemOrange, .yellow, .systemYellow, .green, .systemGreen, .blue, .systemBlue, .purple, .systemPurple]
    private let spacing: CGFloat = 10
    private let columnCount: CGFloat = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.subviews {
            collectionView
                .items(from: self, keyPath: \.items) { collectionView, indexPath, item in
                    let cell = collectionView.dequeue(for: indexPath)
                    cell.backgroundColor(item)
                    return cell
                }
                .itemSize(width: (view.frame.width - spacing * (columnCount + 1)) / columnCount, height: 100)
                .onSelect { [weak self] indexPath in
                    self?.updateItems(at: indexPath)
                }
                .padding()
        }
    }
    
    private func updateItems(at indexPath: IndexPath) {
        let selectedItem = items.remove(at: indexPath.item)
        items.insert(selectedItem, at: 0)
        collectionView.reloadData()
    }
    
    private func refreshItems() {
        items = [.red, .systemRed, .orange, .systemOrange, .yellow, .systemYellow, .green, .systemGreen, .blue, .systemBlue, .purple, .systemPurple]
        collectionView.reloadData()
        refreshControl.endRefreshing()
    }
}

#Preview {
    UIViewControllerPreview {
        CollectionViewExampleViewController()
    }
}
