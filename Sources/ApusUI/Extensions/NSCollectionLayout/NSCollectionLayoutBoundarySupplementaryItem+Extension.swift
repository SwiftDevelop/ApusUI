//
//  NSCollectionLayoutBoundarySupplementaryItem+Extension.swift
//  ApusUI
//
//  Created by SwiftDevelop on 11/19/25.
//

import UIKit

public extension NSCollectionLayoutBoundarySupplementaryItem {
    /// 섹션 헤더를 나타내는 보충 아이템을 생성합니다.
    /// - Parameters:
    ///   - width: 헤더의 너비 차원.
    ///   - height: 헤더의 높이 차원.
    ///   - alignment: 헤더의 정렬 위치. 기본값은 `.top` 입니다.
    /// - Returns: 설정된 헤더 `NSCollectionLayoutBoundarySupplementaryItem`.
    static func header(
        width: NSCollectionLayoutDimension,
        height: NSCollectionLayoutDimension,
        alignment: NSRectAlignment = .top
    ) -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSize = NSCollectionLayoutSize(widthDimension: width, heightDimension: height)
        return .init(layoutSize: layoutSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: alignment)
    }

    /// 섹션 푸터를 나타내는 보충 아이템을 생성합니다.
    /// - Parameters:
    ///   - width: 푸터의 너비 차원.
    ///   - height: 푸터의 높이 차원.
    ///   - alignment: 푸터의 정렬 위치. 기본값은 `.bottom` 입니다.
    /// - Returns: 설정된 푸터 `NSCollectionLayoutBoundarySupplementaryItem`.
    static func footer(
        width: NSCollectionLayoutDimension,
        height: NSCollectionLayoutDimension,
        alignment: NSRectAlignment = .bottom
    ) -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSize = NSCollectionLayoutSize(widthDimension: width, heightDimension: height)
        return .init(layoutSize: layoutSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: alignment)
    }
    
    /// 보충 아이템을 상단에 고정(pin)할지 여부를 설정합니다.
    /// - Parameter pin: `true`이면 상단에 고정합니다.
    /// - Returns: 고정 설정이 적용된 `NSCollectionLayoutBoundarySupplementaryItem`.
    @discardableResult
    func pinToVisibleBounds(_ pin: Bool) -> Self {
        self.pinToVisibleBounds = pin
        return self
    }
}
