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
    
    /// 테이블 뷰에 표시될 데이터. 항상 2차원 배열로 관리됩니다.
    var sections: [[Element]]
    
    /// 각 셀을 구성하는 클로저.
    var cellProvider: (UITableView, IndexPath, Element) -> UITableViewCell
    
    /// 단일 섹션 데이터를 위한 `TableViewDataSourceHandler`를 초기화합니다.
    ///
    /// - Parameters:
    ///   - data: 테이블 뷰에 표시될 1차원 데이터 배열.
    ///   - cellProvider: 각 셀을 구성하는 클로저.
    init(data: [Element], cellProvider: @escaping (UITableView,IndexPath, Element) -> UITableViewCell) {
        self.sections = [data] // 단일 섹션 데이터를 2차원 배열로 감쌉니다.
        self.cellProvider = cellProvider
        super.init()
    }
    
    /// 다중 섹션 데이터를 위한 `TableViewDataSourceHandler`를 초기화합니다.
    ///
    /// - Parameters:
    ///   - data: 테이블 뷰에 표시될 2차원 데이터 배열.
    ///   - cellProvider: 각 셀을 구성하는 클로저.
    init(data: [[Element]], cellProvider: @escaping (UITableView,IndexPath, Element) -> UITableViewCell) {
        self.sections = data
        self.cellProvider = cellProvider
        super.init()
    }
    
    // MARK: - UITableViewDataSource
    
    /// 테이블 뷰의 섹션 수를 반환합니다.
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    /// 지정된 섹션의 행 수를 반환합니다.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard sections.indices.contains(section) else { return 0 }
        return sections[section].count
    }
    
    /// 지정된 인덱스 경로에 대한 셀을 반환합니다.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    /// [단일 섹션] 테이블 뷰의 데이터를 선언형 방식으로 설정하고 셀 구성 로직을 정의합니다.
    ///
    /// - Parameters:
    ///   - data: 테이블 뷰에 표시될 1차원 데이터 배열.
    ///   - cellProvider: 각 셀을 구성하는 클로저.
    /// - Returns: 체이닝을 위한 UITableView 인스턴스.
    @discardableResult
    func items<Element>(
        array data: [Element],
        cellProvider: @escaping (UITableView, IndexPath, Element) -> UITableViewCell
    ) -> Self {
        let dataSourceHandler = TableViewDataSourceHandler(data: data, cellProvider: cellProvider)
        self.dataSource = dataSourceHandler
        objc_setAssociatedObject(self, &AssociatedKeys.dataSourceKey, dataSourceHandler, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return self
    }
    
    /// [다중 섹션] 테이블 뷰의 데이터를 선언형 방식으로 설정하고 셀 구성 로직을 정의합니다.
    ///
    /// - Parameters:
    ///   - data: 테이블 뷰에 표시될 2차원 데이터 배열. 각 내부 배열은 하나의 섹션을 나타냅니다.
    ///   - cellProvider: 각 셀을 구성하는 클로저.
    /// - Returns: 체이닝을 위한 UITableView 인스턴스.
    @discardableResult
    func items<Element>(
        arrays data: [[Element]],
        cellProvider: @escaping (UITableView, IndexPath, Element) -> UITableViewCell
    ) -> Self {
        let dataSourceHandler = TableViewDataSourceHandler(data: data, cellProvider: cellProvider)
        self.dataSource = dataSourceHandler
        objc_setAssociatedObject(self, &AssociatedKeys.dataSourceKey, dataSourceHandler, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return self
    }
}
