//
//  NSCollectionLayoutGroup+Extension.swift
//  ApusUI
//
//  Created by SwiftDevelop on 11/19/25.
//

import UIKit

public extension NSCollectionLayoutGroup {
    /// 지정된 너비와 높이 차원, 그리고 하위 아이템들을 사용하여 수평 그룹을 생성합니다.
    /// - Parameters:
    ///   - width: 그룹의 너비 차원.
    ///   - height: 그룹의 높이 차원.
    ///   - subitems: 그룹에 포함될 `NSCollectionLayoutItem` 배열.
    /// - Returns: 설정된 수평 `NSCollectionLayoutGroup`.
    static func horizontal(
        width: NSCollectionLayoutDimension,
        height: NSCollectionLayoutDimension,
        subitems: [NSCollectionLayoutItem]
    ) -> NSCollectionLayoutGroup {
        let size = NSCollectionLayoutSize(widthDimension: width, heightDimension: height)
        return .horizontal(layoutSize: size, subitems: subitems)
    }

    /// 지정된 너비와 높이 차원, 그리고 하위 아이템들을 사용하여 수직 그룹을 생성합니다.
    /// - Parameters:
    ///   - width: 그룹의 너비 차원.
    ///   - height: 그룹의 높이 차원.
    ///   - subitems: 그룹에 포함될 `NSCollectionLayoutItem` 배열.
    /// - Returns: 설정된 수직 `NSCollectionLayoutGroup`.
    static func vertical(
        width: NSCollectionLayoutDimension,
        height: NSCollectionLayoutDimension,
        subitems: [NSCollectionLayoutItem]
    ) -> NSCollectionLayoutGroup {
        let size = NSCollectionLayoutSize(widthDimension: width, heightDimension: height)
        return .vertical(layoutSize: size, subitems: subitems)
    }

    /// 그룹 내 아이템 간의 간격을 설정합니다.
    ///
    /// - Parameter spacing: 아이템 간의 간격 (`NSCollectionLayoutSpacing`).
    /// - Returns: 간격이 설정된 `NSCollectionLayoutGroup`.
    @discardableResult
    func interItemSpacing(_ spacing: NSCollectionLayoutSpacing) -> Self {
        self.interItemSpacing = spacing
        return self
    }
}
