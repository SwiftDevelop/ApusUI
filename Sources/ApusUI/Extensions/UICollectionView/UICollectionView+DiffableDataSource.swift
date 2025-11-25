//
//  UICollectionView+DiffableDataSource.swift
//  ApusUI
//
//  Created by SwiftDevelop on 11/20/25.
//

import UIKit

// MARK: - AssociatedKeys
@MainActor private enum AssociatedKeys {
    static var dataSourceKey: UInt8 = 0
}

public extension UICollectionView {
    /// `UICollectionViewDiffableDataSource`를 설정하고 초기 스냅샷을 적용합니다.
    ///
    /// 이 메서드는 체이닝을 통해 컬렉션 뷰의 데이터 소스를 설정할 수 있도록 하며,
    /// 생성된 `UICollectionViewDiffableDataSource`를 컬렉션 뷰에 연결하여
    /// 메모리에서 해제되지 않도록 유지합니다.
    ///
    /// - Parameters:
    ///   - snapshot: 적용할 초기 `NSDiffableDataSourceSnapshot`.
    ///   - cellProvider: 각 셀을 구성하는 클로저. `UICollectionViewDiffableDataSource`의 `cellProvider`와 동일합니다.
    /// - Returns: 체이닝을 위한 UICollectionView 인스턴스.
    @discardableResult
    func dataSource<SectionIdentifierType: Hashable & Sendable, ItemIdentifierType: Hashable & Sendable>(
        snapshot: NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>,
        cellProvider: @escaping UICollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>.CellProvider
    ) -> Self {
        let diffableDataSource = UICollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>(
            collectionView: self,
            cellProvider: cellProvider
        )
        
        diffableDataSource.apply(snapshot, animatingDifferences: false)
        
        objc_setAssociatedObject(
            self,
            &AssociatedKeys.dataSourceKey,
            diffableDataSource,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
        
        return self
    }
    
    /// `UICollectionViewDiffableDataSource`를 설정하고 초기 스냅샷을 적용합니다. (보충 뷰 포함)
    ///
    /// 이 메서드는 체이닝을 통해 컬렉션 뷰의 데이터 소스를 설정할 수 있도록 하며,
    /// 생성된 `UICollectionViewDiffableDataSource`를 컬렉션 뷰에 연결하여
    /// 메모리에서 해제되지 않도록 유지합니다.
    ///
    /// - Parameters:
    ///   - snapshot: 적용할 초기 `NSDiffableDataSourceSnapshot`.
    ///   - cellProvider: 각 셀을 구성하는 클로저. `UICollectionViewDiffableDataSource`의 `cellProvider`와 동일합니다.
    ///   - supplementaryViewProvider: 헤더, 푸터 등 보충 뷰를 구성하는 클로저. `UICollectionViewDiffableDataSource`의 `supplementaryViewProvider`와 동일합니다. 기본값은 `nil`입니다.
    /// - Returns: 체이닝을 위한 UICollectionView 인스턴스.
    @discardableResult
    func dataSource<SectionIdentifierType: Hashable & Sendable, ItemIdentifierType: Hashable & Sendable>(
        snapshot: NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>,
        cellProvider: @escaping UICollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>.CellProvider,
        supplementaryViewProvider: UICollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>.SupplementaryViewProvider? = nil
    ) -> Self {
        let diffableDataSource = UICollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>(
            collectionView: self,
            cellProvider: cellProvider
        )
        
        diffableDataSource.supplementaryViewProvider = supplementaryViewProvider
        
        diffableDataSource.apply(snapshot, animatingDifferences: false)
        
        objc_setAssociatedObject(
            self,
            &AssociatedKeys.dataSourceKey,
            diffableDataSource,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
        
        return self
    }
    
    /// 저장된 DiffableDataSource에 새로운 스냅샷을 적용합니다.
    ///
    /// 이 메서드를 사용하기 전에 `.dataSource(snapshot:)` 메서드로 DiffableDataSource가 먼저 설정되어 있어야 합니다.
    ///
    /// - Parameters:
    ///   - snapshot: 적용할 새로운 `NSDiffableDataSourceSnapshot`.
    ///   - animatingDifferences: 변경 사항에 애니메이션을 적용할지 여부. 기본값은 `true`입니다.
    func apply<SectionIdentifierType: Hashable & Sendable, ItemIdentifierType: Hashable & Sendable>(
        snapshot: NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>,
        animatingDifferences: Bool = true
    ) {
        guard let dataSource = objc_getAssociatedObject(self, &AssociatedKeys.dataSourceKey)
                as? UICollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType> else {
            print("Warning: DiffableDataSource was not configured using .dataSource() method before calling .apply().")
            return
        }
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}
