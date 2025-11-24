//
//  UICollectionView+CompositionalLayout.swift
//  ApusUI
//
//  Created by SwiftDevelop on 11/20/25.
//

import UIKit

public extension UICollectionView {
    /// `sectionProvider`를 사용하여 `UICollectionViewCompositionalLayout`을 생성하고,
    /// 해당 레이아웃으로 초기화된 `UICollectionView` 인스턴스를 반환합니다.
    ///
    /// 이를 통해 `UICollectionView { sectionIndex, environment in ... }` 형태로 바로 레이아웃을 구성할 수 있습니다.
    ///
    /// - Parameter sectionProvider: 각 섹션의 레이아웃을 반환하는 클로저.
    convenience init(sectionProvider: @escaping UICollectionViewCompositionalLayoutSectionProvider) {
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
        self.init(frame: .zero, collectionViewLayout: layout)
    }
    
    /// `sectionProvider`와 `configuration`을 사용하여 `UICollectionViewCompositionalLayout`을 생성하고,
    /// 해당 레이아웃으로 초기화된 `UICollectionView` 인스턴스를 반환합니다.
    ///
    /// - Parameters:
    ///   - configuration: 레이아웃에 적용할 설정 객체.
    ///   - sectionProvider: 각 섹션의 레이아웃을 반환하는 클로저.
    convenience init(
        configuration: UICollectionViewCompositionalLayoutConfiguration,
        sectionProvider: @escaping UICollectionViewCompositionalLayoutSectionProvider
    ) {
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: configuration)
        self.init(frame: .zero, collectionViewLayout: layout)
    }
}
