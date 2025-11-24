//
//  UITableView+DataSource.swift
//  ApusUI
//
//  Created by SwiftDevelop on 11/13/25.
//

import UIKit

// MARK: - AssociatedKeys
@MainActor private enum AssociatedKeys {
    static var dataSourceKey: UInt8 = 0
}

/// UITableViewDataSource 프로토콜을 선언형 방식으로 처리하기 위한 핸들러 클래스.
/// 이 클래스는 테이블 뷰의 데이터를 관리하고, 각 셀을 구성하는 로직을 캡슐화합니다.
internal final class TableViewDataSourceHandler<Element>: NSObject, UITableViewDataSource {
    
    /// 테이블 뷰에 표시될 데이터를 제공하는 클로저.
    var dataProvider: () -> [[Element]]
    
    /// 각 셀을 구성하는 클로저.
    var cellProvider: (UITableView,IndexPath, Element) -> UITableViewCell
    
    init(
        dataProvider: @escaping () -> [[Element]],
        cellProvider: @escaping (UITableView,IndexPath, Element) -> UITableViewCell
    ) {
        self.dataProvider = dataProvider
        self.cellProvider = cellProvider
        super.init()
    }
    
    // MARK: - UITableViewDataSource
    
    /// 테이블 뷰의 섹션 수를 반환합니다.
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataProvider().count
    }
    
    /// 지정된 섹션의 행 수를 반환합니다.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sections = dataProvider()
        guard sections.indices.contains(section) else { return 0 }
        return sections[section].count
    }
    
    /// 지정된 인덱스 경로에 대한 셀을 반환합니다.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sections = dataProvider()
        guard sections.indices.contains(indexPath.section),
              sections[indexPath.section].indices.contains(indexPath.row) else {
            // 데이터 소스가 잘못된 경우 비정상 종료하여 개발자가 문제를 인지하도록 합니다.
            fatalError("DataSource index out of bounds: Attempted to access cell at \(indexPath) which is not supported by the data source.")
        }
        let item = sections[indexPath.section][indexPath.row]
        return cellProvider(tableView, indexPath, item)
    }
}

// MARK: - Declarative Data Source
public extension UITableView {
    /// [단일 섹션, KeyPath] 테이블 뷰의 데이터를 선언형 방식으로 설정하고 셀 구성 로직을 정의합니다.
    ///
    /// `root` 객체 내의 `keyPath`가 가리키는 데이터가 변경된 후 `reloadData()`를 호출하면, 테이블 뷰가 자동으로 업데이트됩니다.
    ///
    /// - Parameters:
    ///   - root: 데이터 속성을 포함하는 `AnyObject`. 일반적으로 `UIViewController`의 `self`를 전달합니다.
    ///   - keyPath: `root` 객체 내의 데이터 배열에 대한 KeyPath.
    ///   - cellProvider: 각 셀을 구성하는 클로저.
    /// - Returns: 체이닝을 위한 UITableView 인스턴스.
    @discardableResult
    func items<Root: AnyObject, Element>(
        from root: Root,
        keyPath: KeyPath<Root, [Element]>,
        cellProvider: @escaping (UITableView, IndexPath, Element) -> UITableViewCell
    ) -> Self {
        let handler = TableViewDataSourceHandler<Element>(
            dataProvider: { [weak root] in
                guard let root = root else { return [] }
                return [root[keyPath: keyPath]]
            },
            cellProvider: cellProvider
        )
        
        self.dataSource = handler
        objc_setAssociatedObject(self, &AssociatedKeys.dataSourceKey, handler, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        return self
    }
    
    /// [다중 섹션, KeyPath] 테이블 뷰의 데이터를 선언형 방식으로 설정하고 셀 구성 로직을 정의합니다.
    ///
    /// `root` 객체 내의 `keyPath`가 가리키는 데이터가 변경된 후 `reloadData()`를 호출하면, 테이블 뷰가 자동으로 업데이트됩니다.
    ///
    /// - Parameters:
    ///   - root: 데이터 속성을 포함하는 `AnyObject`. 일반적으로 `UIViewController`의 `self`를 전달합니다.
    ///   - keyPath: `root` 객체 내의 데이터 2차원 배열에 대한 KeyPath.
    ///   - cellProvider: 각 셀을 구성하는 클로저.
    /// - Returns: 체이닝을 위한 UITableView 인스턴스.
    @discardableResult
    func items<Root: AnyObject, Element>(
        from root: Root,
        keyPath: KeyPath<Root, [[Element]]>,
        cellProvider: @escaping (UITableView, IndexPath, Element) -> UITableViewCell
    ) -> Self {
        let handler = TableViewDataSourceHandler<Element>(
            dataProvider: { [weak root] in
                guard let root = root else { return [] }
                return root[keyPath: keyPath]
            },
            cellProvider: cellProvider
        )
        
        self.dataSource = handler
        objc_setAssociatedObject(self, &AssociatedKeys.dataSourceKey, handler, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        return self
    }
}
