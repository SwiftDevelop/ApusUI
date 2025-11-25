//
//  TableViewExampleViewController.swift
//  ApusUI
//
//  Created by SwiftDevelop on 11/13/25.
//

import SwiftUI
import ApusUI

final class TableViewExampleViewController: UIViewController {
    
    struct Item {
        let title: String
        let textes: [String]
    }
    
    private var items = [
        Item(title: "가", textes: ["가나", "가다", "가라", "가마", "가사", "가자"]),
        Item(title: "나", textes: ["나가", "나다", "나라", "나비", "나사"]),
        Item(title: "다", textes: ["다리", "다리미"]),
        Item(title: "라", textes: ["라디오"]),
        Item(title: "마", textes: ["마늘", "마차"]),
    ]
    private var textes: [[String]] { items.map { $0.textes } }
    
    private lazy var tableView: UITableView = {
        UITableView(style: .grouped)
            .register(cell: UITableViewCell.self)
            .refreshControl(refreshControl)
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        UIRefreshControl()
            .onChange { [weak self] in
                self?.refreshItems()
            }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.subviews {
            tableView
                .sectionHeader(height: 50) { [weak self] section in
                    UIView {
                        UILabel(self?.items[section].title)
                            .padding(horizontal: 8)
                            .padding(bottom: 8)
                    }
                }
                .items(from: self, keyPath: \.textes) { tableView, indexPath, item in
                    let cell = tableView.dequeue(for: indexPath)
                    cell.textLabel?.text = item
                    return cell
                }
                .onSelect { [weak self] indexPath in
                    self?.updateItems()
                }
                .padding()
                .edgesIgnoringSafeArea(.bottom)
        }
    }
    
    private func updateItems() {
        items.append(Item(title: "바", textes: ["바나나", "바다", "바라"]))
        tableView.reloadData()
    }
    
    private func refreshItems() {
        items = [
            Item(title: "가", textes: ["가나", "가다", "가라", "가마", "가사", "가자"]),
            Item(title: "나", textes: ["나가", "나다", "나라", "나비", "나사"]),
            Item(title: "다", textes: ["다리", "다리미"]),
            Item(title: "라", textes: ["라디오"]),
            Item(title: "마", textes: ["마늘", "마차"]),
        ]
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
}

// MARK: - Preview
#Preview {
    UIViewControllerPreview {
        TableViewExampleViewController()
    }
    .edgesIgnoringSafeArea(.all)
}
