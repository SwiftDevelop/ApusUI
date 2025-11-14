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
    
//    private let items = Array(repeating: 0, count: 50)
//    private let items = [
//        ["Apple", "Awsome"], ["Banana", "Bycicle"], ["Car", "Cherry"]
//    ]
    private let items = [
        Item(title: "가", textes: ["가나", "가다", "가라", "가마", "가사", "가자"]),
        Item(title: "나", textes: ["나가", "나다", "나라", "나비", "나사"]),
        Item(title: "다", textes: ["다리", "다리미"]),
        Item(title: "라", textes: ["라디오"]),
        Item(title: "마", textes: ["마늘", "마차"]),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.subviews {
            UITableView(style: .grouped)
//                .dataSource(self)
//                .delegate(self)
                .register(cell: UITableViewCell.self)
                .sectionHeader(height: 50) { [weak self] section in
                    UIView {
                        UILabel(self?.items[section].title)
                            .padding(horizontal: 8)
                            .padding(bottom: 8)
                    }
                }
                .items(arrays: items.map({ $0.textes })) { tableView, indexPath, item in
                    let cell = tableView.dequeue(for: indexPath)
                    cell.textLabel?.text = item
                    return cell
                }
                .onSelect { [weak self] indexPath in
                    print(self?.items[indexPath.section].textes[indexPath.item] ?? "")
                }
                .padding()
                .edgesIgnoringSafeArea(.bottom)
        }
    }
}

// MARK: - UITableViewDelegate
//extension TableViewExampleViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath)
//    }
//}

// MARK: - UITableViewDataSource
//extension TableViewExampleViewController: UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return items.count
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return items[section].count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeue(for: indexPath)
//        return cell
//    }
//}

// MARK: - Preview
#Preview {
    UIViewControllerPreview {
        TableViewExampleViewController()
    }
    .edgesIgnoringSafeArea(.all)
}
