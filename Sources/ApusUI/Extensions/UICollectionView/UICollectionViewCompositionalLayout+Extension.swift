//
//  UICollectionViewCompositionalLayout+Extension.swift
//  ApusUI
//
//  Created by SwiftDevelop on 11/19/25.
//

import UIKit

public extension UICollectionViewCompositionalLayout {
    /// 단일 `NSCollectionLayoutSection`을 사용하여 `UICollectionViewCompositionalLayout`을 생성합니다.
    ///
    /// 모든 섹션이 동일한 레이아웃을 가질 때 사용하기 편리합니다.
    ///
    /// - Parameter section: 컬렉션 뷰의 모든 섹션에 적용할 레이아웃 섹션.
    convenience init(section: NSCollectionLayoutSection) {
        self.init(section: section)
    }
    
    /// 섹션 제공자(section provider)와 `UICollectionViewCompositionalLayoutConfiguration`을 사용하여 레이아웃을 생성합니다.
    ///
    /// - Parameters:
    ///   - configuration: 레이아웃에 적용할 설정 객체.
    ///   - sectionProvider: 각 섹션의 레이아웃을 동적으로 반환하는 클로저.
    convenience init(
        configuration: UICollectionViewCompositionalLayoutConfiguration,
        sectionProvider: @escaping (Int, NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection?
    ) {
        self.init(sectionProvider: sectionProvider, configuration: configuration)
    }
}

public extension UICollectionViewCompositionalLayoutConfiguration {
    /// 스크롤 방향과 간격을 설정하여 `UICollectionViewCompositionalLayoutConfiguration`을 생성합니다.
    ///
    /// - Parameters:
    ///   - scrollDirection: 레이아웃의 스크롤 방향.
    ///   - interSectionSpacing: 섹션 간의 간격.
    ///   - boundarySupplementaryItems: 레이아웃의 경계에 표시될 보충 뷰(예: 전역 헤더/푸터).
    convenience init(
        scrollDirection: UICollectionView.ScrollDirection,
        interSectionSpacing: CGFloat = 0,
        boundarySupplementaryItems: [NSCollectionLayoutBoundarySupplementaryItem] = []
    ) {
        self.init()
        self.scrollDirection = scrollDirection
        self.interSectionSpacing = interSectionSpacing
        self.boundarySupplementaryItems = boundarySupplementaryItems
    }
}
