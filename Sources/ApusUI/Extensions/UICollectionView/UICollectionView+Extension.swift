//
//  UICollectionView+Extension.swift
//  ApusUI
//
//  Created by SwiftDevelop on 11/17/25.
//

import UIKit

// MARK: - Initialization
public extension UICollectionView {
    /// 지정된 레이아웃으로 새로운 UICollectionView를 초기화합니다.
    ///
    /// - Parameter layout: 컬렉션 뷰에 적용할 UICollectionViewLayout 인스턴스.
    convenience init(layout: UICollectionViewLayout) {
        self.init(frame: .zero, collectionViewLayout: layout)
    }
    
    /// `UICollectionViewFlowLayout`의 스크롤 방향을 지정하여 새로운 UICollectionView를 초기화합니다.
    ///
    /// - Parameters:
    ///   - layout: 컬렉션 뷰에 적용할 `UICollectionViewFlowLayout` 인스턴스. 기본값은 새로운 `UICollectionViewFlowLayout()` 입니다.
    ///   - scrollDirection: 레이아웃의 스크롤 방향.
    public convenience init(
        layout: UICollectionViewFlowLayout = .init(),
        scrollDirection: UICollectionView.ScrollDirection
    ) {
        layout.scrollDirection = scrollDirection
        self.init(frame: .zero, collectionViewLayout: layout)
    }
}

// MARK: - Registration & Dequeue
public extension UICollectionView {
    /// 제네릭 타입을 사용하여 UICollectionViewCell을 등록합니다.
    ///
    /// - Parameters:
    ///   - cellClass: 등록할 UICollectionViewCell의 서브클래스 타입.
    ///   - identifier: 셀 재사용을 위한 고유 식별자.
    @discardableResult
    func register<T: UICollectionViewCell>(_ cellClass: T.Type, identifier: String) -> Self {
        self.register(cellClass.self, forCellWithReuseIdentifier: identifier)
        return self
    }
    
    /// 제네릭 타입을 사용하여 UICollectionViewCell을 등록합니다.
    /// 셀의 클래스 이름이 재사용 식별자(reuse identifier)로 사용됩니다.
    ///
    /// - Parameter cellClass: 등록할 UICollectionViewCell의 서브클래스 타입.
    @discardableResult
    func register<T: UICollectionViewCell>(_ cellClass: T.Type) -> Self {
        let identifier = String(describing: cellClass.self)
        self.register(cellClass.self, forCellWithReuseIdentifier: identifier)
        return self
    }
    
    /// 제네릭 타입을 사용하여 UICollectionReusableView를 헤더로 등록합니다.
    /// 뷰의 클래스 이름이 재사용 식별자(reuse identifier)로 사용됩니다.
    ///
    /// - Parameter viewType: 등록할 UICollectionReusableView의 서브클래스 타입.
    @discardableResult
    func registerHeader<T: UICollectionReusableView>(_ viewType: T.Type) -> Self {
        let identifier = String(describing: viewType.self)
        self.register(
            viewType.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: identifier
        )
        return self
    }
    
    /// 제네릭 타입을 사용하여 UICollectionReusableView를 푸터로 등록합니다.
    /// 뷰의 클래스 이름이 재사용 식별자(reuse identifier)로 사용됩니다.
    ///
    /// - Parameter viewType: 등록할 UICollectionReusableView의 서브클래스 타입.
    @discardableResult
    func registerFooter<T: UICollectionReusableView>(_ viewType: T.Type) -> Self {
        let identifier = String(describing: viewType.self)
        self.register(
            viewType.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: identifier
        )
        return self
    }
    
    /// 제네릭 타입을 사용하여 등록된 UICollectionViewCell을 재사용 큐에서 가져옵니다.
    /// 이 메서드는 항상 유효한 셀을 반환하므로 옵셔널이 아닌 타입으로 캐스팅할 수 있습니다.
    ///
    /// - Parameter indexPath: 셀의 위치를 나타내는 IndexPath.
    /// - Returns: 지정된 타입의 UICollectionViewCell 인스턴스.
    func dequeue<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        let identifier = String(describing: T.self)
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Unable to dequeue cell with identifier \(identifier)")
        }
        return cell
    }
    
    /// 제네릭 타입을 사용하여 등록된 헤더 뷰를 재사용 큐에서 가져옵니다.
    ///
    /// - Parameter indexPath: 헤더 뷰의 위치를 나타내는 IndexPath.
    /// - Returns: 지정된 타입의 UICollectionReusableView 인스턴스.
    func dequeueHeader<T: UICollectionReusableView>(for indexPath: IndexPath) -> T {
        let identifier = String(describing: T.self)
        guard let view = dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: identifier,
            for: indexPath
        ) as? T else {
            fatalError("Unable to dequeue supplementary view of kind Header with identifier \(identifier)")
        }
        return view
    }
    
    /// 제네릭 타입을 사용하여 등록된 푸터 뷰를 재사용 큐에서 가져옵니다.
    ///
    /// - Parameter indexPath: 푸터 뷰의 위치를 나타내는 IndexPath.
    /// - Returns: 지정된 타입의 UICollectionReusableView 인스턴스.
    func dequeueFooter<T: UICollectionReusableView>(for indexPath: IndexPath) -> T {
        let identifier = String(describing: T.self)
        guard let view = dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: identifier,
            for: indexPath
        ) as? T else {
            fatalError("Unable to dequeue supplementary view of kind Footer with identifier \(identifier)")
        }
        return view
    }
}

// MARK: - Configuration
public extension UICollectionView {
    /// 컬렉션 뷰의 아이템 선택 가능 여부를 설정합니다.
    ///
    /// - Parameter allows: 아이템 선택을 허용할지 여부. `true`이면 선택 가능, `false`이면 선택 불가능.
    /// - Returns: 체이닝을 위한 UICollectionView 인스턴스.
    @discardableResult
    func allowsSelection(_ allows: Bool) -> Self {
        self.allowsSelection = allows
        return self
    }
    
    /// 컬렉션 뷰의 다중 아이템 선택 가능 여부를 설정합니다.
    ///
    /// - Parameter allows: 다중 아이템 선택을 허용할지 여부. `true`이면 다중 선택 가능, `false`이면 다중 선택 불가능.
    /// - Returns: 체이닝을 위한 UICollectionView 인스턴스.
    @discardableResult
    func allowsMultipleSelection(_ allows: Bool) -> Self {
        self.allowsMultipleSelection = allows
        return self
    }
    
    /// 컬렉션 뷰의 데이터 소스를 설정합니다.
    ///
    /// - Parameter dataSource: 컬렉션 뷰의 데이터 소스 객체.
    /// - Returns: 체이닝을 위한 UICollectionView 인스턴스.
    @discardableResult
    func dataSource(_ dataSource: UICollectionViewDataSource?) -> Self {
        self.dataSource = dataSource
        return self
    }
    
    /// 컬렉션 뷰의 델리게이트를 설정합니다.
    ///
    /// - Parameter delegate: 컬렉션 뷰의 델리게이트 객체.
    /// - Returns: 체이닝을 위한 UICollectionView 인스턴스.
    @discardableResult
    func delegate(_ delegate: UICollectionViewDelegate?) -> Self {
        self.delegate = delegate
        return self
    }
    
    /// 컬렉션 뷰의 프리페칭 데이터 소스를 설정합니다.
    ///
    /// - Parameter prefetchDataSource: 컬렉션 뷰의 프리페칭 데이터 소스 객체.
    /// - Returns: 체이닝을 위한 UICollectionView 인스턴스.
    @discardableResult
    func prefetchDataSource(_ prefetchDataSource: UICollectionViewDataSourcePrefetching?) -> Self {
        self.prefetchDataSource = prefetchDataSource
        return self
    }
    
    /// 컬렉션 뷰의 드래그 델리게이트를 설정합니다.
    ///
    /// - Parameter dragDelegate: 컬렉션 뷰의 드래그 델리게이트 객체.
    /// - Returns: 체이닝을 위한 UICollectionView 인스턴스.
    @available(iOS 11.0, *)
    @discardableResult
    func dragDelegate(_ dragDelegate: UICollectionViewDragDelegate?) -> Self {
        self.dragDelegate = dragDelegate
        return self
    }
    
    /// 컬렉션 뷰의 드롭 델리게이트를 설정합니다.
    ///
    /// - Parameter dropDelegate: 컬렉션 뷰의 드롭 델리게이트 객체.
    /// - Returns: 체이닝을 위한 UICollectionView 인스턴스.
    @available(iOS 11.0, *)
    @discardableResult
    func dropDelegate(_ dropDelegate: UICollectionViewDropDelegate?) -> Self {
        self.dropDelegate = dropDelegate
        return self
    }
}

// MARK: - Layout & View
public extension UICollectionView {
    /// 컬렉션 뷰의 배경 뷰를 설정합니다.
    ///
    /// - Parameter view: 컬렉션 뷰의 배경으로 사용할 UIView 인스턴스.
    /// - Returns: 체이닝을 위한 UICollectionView 인스턴스.
    @discardableResult
    func backgroundView(_ view: UIView?) -> Self {
        self.backgroundView = view
        return self
    }
    
    /// 콘텐츠 인셋 조정 동작을 설정합니다.
    ///
    /// - Parameter behavior: 적용할 UIScrollView.ContentInsetAdjustmentBehavior 값.
    /// - Returns: 체이닝을 위한 UICollectionView 인스턴스.
    @discardableResult
    func contentInsetAdjustmentBehavior(_ behavior: UIScrollView.ContentInsetAdjustmentBehavior) -> Self {
        self.contentInsetAdjustmentBehavior = behavior
        return self
    }
}
