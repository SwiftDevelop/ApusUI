//
//  CompositionalLayoutExampleViewController.swift
//  ApusUIDemo
//
//  Created by SwiftDevelop on 11/19/25.
//

import ApusUI
import SwiftUI

final class CompositionalLayoutExampleViewController: UIViewController {
    
    // MARK: - Section & Item Definition
    enum Section {
        case main
    }
    
    struct Item: Hashable {
        let id = UUID()
        let color: UIColor
    }
    
    // MARK: - Properties
    
    private lazy var collectionView: UICollectionView = {
        UICollectionView { _, _ in
            let item = NSCollectionLayoutItem(
                width: .fractionalWidth(0.5),
                height: .fractionalHeight(1.0)
            )
            let group = NSCollectionLayoutGroup.horizontal(
                width: .fractionalWidth(1.0),
                height: .fractionalHeight(0.33),
                subitems: [item]
            ).interItemSpacing(.fixed(8))
            
            let section = NSCollectionLayoutSection(group: group)
                .interGroupSpacing(8)
                .boundarySupplementaryItems([
                    .header(width: .fractionalWidth(1.0), height: .estimated(100)),
                    .footer(width: .fractionalWidth(1.0), height: .estimated(100))
                ])
                .contentInsets(vertical: 8)
            return section
        }
        .register(UICollectionViewCell.self)
        .registerHeader(UICollectionReusableView.self)
        .registerFooter(UICollectionReusableView.self)
    }()
    
    private var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.subviews {
            collectionView
                .dataSource(
                    snapshot: snapshot,
                    cellProvider: { collectionView, indexPath, item in
                        let cell = collectionView.dequeue(for: indexPath)
                        cell.backgroundColor(item.color)
                        return cell
                    },
                    supplementaryViewProvider: { collectionView, elementKind, indexPath in
                        switch elementKind {
                        case UICollectionView.elementKindSectionHeader:
                            let header = collectionView.dequeueHeader(for: indexPath)
                            header.backgroundColor(.red)
                            return header
                        case UICollectionView.elementKindSectionFooter:
                            let footer = collectionView.dequeueFooter(for: indexPath)
                            footer.backgroundColor(.blue)
                            return footer
                        default:
                            return nil
                        }
                    }
                )
                .onSelect { [weak self] indexPath in
                    self?.updateData(at: indexPath)
                }
                .padding()
        }
        
        applyData()
    }
    
    private func applyData() {
        snapshot.appendSections([.main])
        Array(1...20).forEach { _ in
            snapshot.appendItems([Item(color: .lightGray)], toSection: .main)
        }
        collectionView.apply(snapshot: snapshot, animatingDifferences: false)
    }
    
    private func updateData(at indexPath: IndexPath) {
        var items = snapshot.itemIdentifiers(inSection: .main)
        let selectedItem = items.remove(at: indexPath.item)
        items.insert(selectedItem, at: 0)
        snapshot.appendItems(items, toSection: .main)
        collectionView.apply(snapshot: snapshot, animatingDifferences: true)
    }
}

#Preview {
    UIViewControllerPreview {
        CompositionalLayoutExampleViewController()
    }
}
