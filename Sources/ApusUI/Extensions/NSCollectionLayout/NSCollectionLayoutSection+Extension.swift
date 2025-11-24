//
//  NSCollectionLayoutSection+Extension.swift
//  ApusUI
//
//  Created by SwiftDevelop on 11/19/25.
//

import UIKit

public extension NSCollectionLayoutSection {
    /// 섹션의 콘텐츠 인셋을 설정합니다.
    ///
    /// - Parameter insets: 적용할 `NSDirectionalEdgeInsets`.
    /// - Returns: 콘텐츠 인셋이 적용된 `NSCollectionLayoutSection`.
    @discardableResult
    func contentInsets(_ insets: NSDirectionalEdgeInsets) -> Self {
        self.contentInsets = insets
        return self
    }
    
    /// 섹션의 콘텐츠 인셋을 설정합니다.
    ///
    /// - Parameters:
    ///   - top: 상단 인셋.
    ///   - leading: 시작점 방향 인셋.
    ///   - bottom: 하단 인셋.
    ///   - trailing: 끝점 방향 인셋.
    /// - Returns: 콘텐츠 인셋이 적용된 `NSCollectionLayoutSection`.
    @discardableResult
    func contentInsets(top: CGFloat = 0, leading: CGFloat = 0, bottom: CGFloat = 0, trailing: CGFloat = 0) -> Self {
        self.contentInsets = NSDirectionalEdgeInsets(top: top, leading: leading, bottom: bottom, trailing: trailing)
        return self
    }
    
    /// 섹션의 콘텐츠 인셋을 수평 방향으로 설정합니다.
    ///
    /// - Parameter horizontal: 수평 방향으로 적용할 인셋 값.
    /// - Returns: 콘텐츠 인셋이 적용된 `NSCollectionLayoutSection`.
    @discardableResult
    func contentInsets(horizontal: CGFloat) -> Self {
        self.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: horizontal, bottom: 0, trailing: horizontal)
        return self
    }
    
    /// 섹션의 콘텐츠 인셋을 수직 방향으로 설정합니다.
    ///
    /// - Parameter vertical: 수직 방향으로 적용할 인셋 값.
    /// - Returns: 콘텐츠 인셋이 적용된 `NSCollectionLayoutSection`.
    @discardableResult
    func contentInsets(vertical: CGFloat) -> Self {
        self.contentInsets = NSDirectionalEdgeInsets(top: vertical, leading: 0, bottom: vertical, trailing: 0)
        return self
    }
    
    /// 섹션 내 그룹 간의 간격을 설정합니다.
    ///
    /// - Parameter spacing: 그룹 간의 간격 (`CGFloat`).
    /// - Returns: 그룹 간 간격이 설정된 `NSCollectionLayoutSection`.
    @discardableResult
    func interGroupSpacing(_ spacing: CGFloat) -> Self {
        self.interGroupSpacing = spacing
        return self
    }
    
    /// 섹션의 직교 스크롤 동작을 설정합니다.
    ///
    /// - Parameter behavior: 적용할 `UICollectionLayoutSectionOrthogonalScrollingBehavior`.
    /// - Returns: 직교 스크롤 동작이 설정된 `NSCollectionLayoutSection`.
    @discardableResult
    func orthogonalScrollingBehavior(_ behavior: UICollectionLayoutSectionOrthogonalScrollingBehavior) -> Self {
        self.orthogonalScrollingBehavior = behavior
        return self
    }
    
    /// 섹션에 경계 보충 뷰(예: 헤더, 푸터)를 추가합니다.
    ///
    /// - Parameter boundarySupplementaryItems: 추가할 `NSCollectionLayoutBoundarySupplementaryItem`의 배열.
    /// - Returns: 보충 뷰가 추가된 `NSCollectionLayoutSection`.
    @discardableResult
    func boundarySupplementaryItems(_ boundarySupplementaryItems: [NSCollectionLayoutBoundarySupplementaryItem]) -> Self {
        self.boundarySupplementaryItems = boundarySupplementaryItems
        return self
    }
    
    /// 스크롤 시 섹션 헤더를 고정할지 여부를 설정합니다.
    ///
    /// - Parameter pin: `true`이면 헤더를 고정하고, `false`이면 고정하지 않습니다.
    /// - Returns: 헤더 고정 여부가 설정된 `NSCollectionLayoutSection`.
    @discardableResult
    func pinSupplementaryItems(_ pin: Bool) -> Self {
        self.supplementariesFollowContentInsets = pin
        return self
    }
}
