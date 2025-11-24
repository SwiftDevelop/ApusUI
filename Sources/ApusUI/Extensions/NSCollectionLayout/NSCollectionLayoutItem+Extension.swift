//
//  NSCollectionLayoutItem+Extension.swift
//  ApusUI
//
//  Created by SwiftDevelop on 11/19/25.
//

import UIKit

public extension NSCollectionLayoutItem {
    /// 너비와 높이 차원을 지정하여 `NSCollectionLayoutItem`을 생성합니다.
    ///
    /// 이 이니셜라이저는 `NSCollectionLayoutSize`를 내부적으로 생성하여 `layoutSize` 파라미터로 사용합니다.
    ///
    /// - Parameters:
    ///   - width: 아이템의 너비 차원을 정의하는 `NSCollectionLayoutDimension`.
    ///   - height: 아이템의 높이 차원을 정의하는 `NSCollectionLayoutDimension`.
    ///   - supplementaryItems: 아이템과 관련된 보충 뷰 아이템 배열. 기본값은 빈 배열입니다.
    convenience init(
        width: NSCollectionLayoutDimension,
        height: NSCollectionLayoutDimension,
        supplementaryItems: [NSCollectionLayoutSupplementaryItem] = []
    ) {
        self.init(
            layoutSize: NSCollectionLayoutSize(widthDimension: width, heightDimension: height),
            supplementaryItems: supplementaryItems
        )
    }

    /// 레이아웃 아이템의 콘텐츠 인셋을 설정합니다.
    ///
    /// - Parameter insets: 적용할 `NSDirectionalEdgeInsets`.
    /// - Returns: 콘텐츠 인셋이 적용된 `NSCollectionLayoutItem` 인스턴스.
    @discardableResult
    func contentInsets(_ insets: NSDirectionalEdgeInsets) -> NSCollectionLayoutItem {
        self.contentInsets = insets
        return self
    }
    
    /// 레이아웃 아이템의 콘텐츠 인셋을 설정합니다.
    ///
    /// - Parameters:
    ///   - top: 상단 인셋.
    ///   - leading: 시작점 방향 인셋.
    ///   - bottom: 하단 인셋.
    ///   - trailing: 끝점 방향 인셋.
    /// - Returns: 콘텐츠 인셋이 적용된 `NSCollectionLayoutItem` 인스턴스.
    @discardableResult
    func contentInsets(top: CGFloat, leading: CGFloat, bottom: CGFloat, trailing: CGFloat) -> NSCollectionLayoutItem {
        self.contentInsets = .init(top: top, leading: leading, bottom: bottom, trailing: trailing)
        return self
    }
}
