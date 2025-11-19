//
//  UICollectionView+DataSource.swift
//  ApusUI
//
//  Created by SwiftDevelop on 11/17/25.
//

import UIKit

// MARK: - AssociatedKeys
@MainActor private enum AssociatedKeys {
    static var dataSourceKey: UInt8 = 0
}

/// UICollectionViewDataSource 프로토콜을 선언형 방식으로 처리하기 위한 핸들러 클래스.
/// 이 클래스는 컬렉션 뷰의 데이터를 관리하고, 각 셀과 보충 뷰를 구성하는 로직을 캡슐화합니다.
internal final class CollectionViewDataSourceHandler<Element>: NSObject, UICollectionViewDataSource {
    
    /// 컬렉션 뷰에 표시될 데이터를 제공하는 클로저.
    var dataProvider: () -> [[Element]]
    
    /// 각 셀을 구성하는 클로저.
    var cellProvider: (UICollectionView,IndexPath, Element) -> UICollectionViewCell
    
    /// 각 헤더 뷰를 구성하는 클로저.
    var headerProvider: ((UICollectionView, IndexPath) -> UICollectionReusableView)?
    
    /// 각 푸터 뷰를 구성하는 클로저.
    var footerProvider: ((UICollectionView,IndexPath) -> UICollectionReusableView)?
    
    init(
        dataProvider: @escaping () -> [[Element]],
        cellProvider: @escaping (UICollectionView,IndexPath, Element) -> UICollectionViewCell
    ) {
        self.dataProvider = dataProvider
        self.cellProvider = cellProvider
        super.init()
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataProvider().count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sections = dataProvider()
        guard sections.indices.contains(section) else { return 0 }
        return sections[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sections = dataProvider()
        guard sections.indices.contains(indexPath.section),
              sections[indexPath.section].indices.contains(indexPath.item) else {
            fatalError("DataSource index out of bounds: Attempted to access cell at \(indexPath) which is not supported by the data source.")
        }
        let item = sections[indexPath.section][indexPath.item]
        return cellProvider(collectionView, indexPath, item)
    }
    
    /// 지정된 종류의 보충 뷰를 반환합니다.
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerProvider = headerProvider else {
                fatalError("Header provider has not been set. Please use the .header() method to configure it.")
            }
            return headerProvider(collectionView, indexPath)
        case UICollectionView.elementKindSectionFooter:
            guard let footerProvider = footerProvider else {
                fatalError("Footer provider has not been set. Please use the .footer() method to configure it.")
            }
            return footerProvider(collectionView, indexPath)
        default:
            fatalError("Unsupported supplementary view kind: \(kind)")
        }
    }
}

// MARK: - Declarative Data Source API
public extension UICollectionView {
    /// [단일 섹션, KeyPath] 컬렉션 뷰의 데이터, 스크롤 방향, 셀 구성을 한 번에 설정합니다.
    ///
    /// - Warning: `cellProvider` 클로저 내에서 `self`를 참조할 경우, 메모리 누수를 방지하기 위해 `[weak self]`를 사용해야 합니다.
    /// - Parameters:
    ///   - root: 데이터 속성을 포함하는 객체.
    ///   - keyPath: `root` 객체 내의 데이터 배열에 대한 KeyPath.
    ///   - cellProvider: 각 셀을 구성하는 클로저.
    /// - Returns: 체이닝을 위한 UICollectionView 인스턴스.
    @discardableResult
    func items<Root: AnyObject, Element>(
        from root: Root,
        keyPath: KeyPath<Root, [Element]>,
        cellProvider: @escaping (UICollectionView, IndexPath, Element) -> UICollectionViewCell
    ) -> Self {
        let handler = CollectionViewDataSourceHandler<Element>(
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
    
    /// [다중 섹션, KeyPath] 컬렉션 뷰의 데이터, 스크롤 방향, 셀 구성을 한 번에 설정합니다.
    ///
    /// - Warning: `cellProvider` 클로저 내에서 `self`를 참조할 경우, 메모리 누수를 방지하기 위해 `[weak self]`를 사용해야 합니다.
    /// - Parameters:
    ///   - root: 데이터 속성을 포함하는 객체.
    ///   - keyPath: `root` 객체 내의 데이터 배열에 대한 KeyPath.
    ///   - cellProvider: 각 셀을 구성하는 클로저.
    /// - Returns: 체이닝을 위한 UICollectionView 인스턴스.
    @discardableResult
    func items<Root: AnyObject, Element>(
        from root: Root,
        keyPath: KeyPath<Root, [[Element]]>,
        cellProvider: @escaping (UICollectionView, IndexPath, Element) -> UICollectionViewCell
    ) -> Self {
        let handler = CollectionViewDataSourceHandler<Element>(
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
    
    /// 컬렉션 뷰의 헤더 뷰 구성 로직을 정의합니다.
    ///
    /// - Warning: 클로저 내에서 `self`를 참조할 경우, 메모리 누수를 방지하기 위해 `[weak self]`를 사용해야 합니다.
    /// - Parameter provider: 각 헤더 뷰를 구성하는 클로저.
    /// - Returns: 체이닝을 위한 UICollectionView 인스턴스.
    @discardableResult
    func header(_ provider: @escaping (UICollectionView, IndexPath) -> UICollectionReusableView) -> Self {
        if let handler = self.dataSource as? CollectionViewDataSourceHandler<Any> {
            handler.headerProvider = provider
        }
        return self
    }
    
    /// 컬렉션 뷰의 푸터 뷰 구성 로직을 정의합니다.
    ///
    /// - Warning: 클로저 내에서 `self`를 참조할 경우, 메모리 누수를 방지하기 위해 `[weak self]`를 사용해야 합니다.
    /// - Parameter provider: 각 푸터 뷰를 구성하는 클로저.
    /// - Returns: 체이닝을 위한 UICollectionView 인스턴스.
    @discardableResult
    func footer(_ provider: @escaping (UICollectionView, IndexPath) -> UICollectionReusableView) -> Self {
        if let handler = self.dataSource as? CollectionViewDataSourceHandler<Any> {
            handler.footerProvider = provider
        }
        return self
    }
    
}
