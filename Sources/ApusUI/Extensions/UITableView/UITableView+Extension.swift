//
//  UITableView+Extension.swift
//  ApusUI
//
//  Created by SwiftDevelop on 11/13/25.
//

import UIKit

// MARK: - Initialization
public extension UITableView {
    convenience init(style: UITableView.Style = .plain) {
        self.init(frame: .zero, style: style)
    }
}

// MARK: - Registration & Dequeue
public extension UITableView {
    /// 제네릭 타입을 사용하여 UITableViewCell을 등록합니다.
    /// 셀의 클래스 이름이 재사용 식별자(reuse identifier)로 사용됩니다.
    ///
    /// - Parameter cell: 등록할 UITableViewCell의 서브클래스 타입.
    @discardableResult
    func register<T: UITableViewCell>(cell: T.Type) -> Self {
        register(cell, forCellReuseIdentifier: String(describing: cell))
        return self
    }

    /// 제네릭 타입을 사용하여 등록된 UITableViewCell을 재사용 큐에서 가져옵니다.
    /// 이 메서드는 항상 유효한 셀을 반환하므로 옵셔널이 아닌 타입으로 캐스팅할 수 있습니다.
    ///
    /// - Parameter indexPath: 셀의 위치를 나타내는 IndexPath.
    func dequeue<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(String(describing: T.self))")
        }
        return cell
    }

    /// 제네릭 타입을 사용하여 UITableViewHeaderFooterView를 등록합니다.
    /// 뷰의 클래스 이름이 재사용 식별자(reuse identifier)로 사용됩니다.
    ///
    /// - Parameter headerFooter: 등록할 UITableViewHeaderFooterView의 서브클래스 타입.
    @discardableResult
    func register<T: UITableViewHeaderFooterView>(headerFooter: T.Type) -> Self {
        register(headerFooter, forHeaderFooterViewReuseIdentifier: String(describing: headerFooter))
        return self
    }

    /// 제네릭 타입을 사용하여 등록된 UITableViewHeaderFooterView를 재사용 큐에서 가져옵니다.
    ///
    /// - Returns: 지정된 타입의 UITableViewHeaderFooterView 인스턴스.
    func dequeueHeaderFooter<T: UITableViewHeaderFooterView>() -> T {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: String(describing: T.self)) as? T else {
            fatalError("Could not dequeue header/footer view with identifier: \(String(describing: T.self))")
        }
        return view
    }
}

// MARK: - Configuration
public extension UITableView {
    /// 테이블 뷰의 셀 구분선 스타일을 설정합니다.
    ///
    /// - Parameter style: 설정할 구분선 스타일.
    @discardableResult
    func separatorStyle(_ style: UITableViewCell.SeparatorStyle) -> Self {
        self.separatorStyle = style
        return self
    }
    
    /// 테이블 뷰의 셀 구분선 색상을 설정합니다.
    ///
    /// - Parameter color: 설정할 구분선 색상. `nil`을 전달하면 기본 색상이 사용됩니다.
    @discardableResult
    func separatorColor(_ color: UIColor?) -> Self {
        self.separatorColor = color
        return self
    }
    
    /// 테이블 뷰의 셀 선택 가능 여부를 설정합니다.
    ///
    /// - Parameter allows: 셀 선택을 허용할지 여부. `true`이면 선택 가능, `false`이면 선택 불가능.
    @discardableResult
    func allowsSelection(_ allows: Bool) -> Self {
        self.allowsSelection = allows
        return self
    }
    
    /// 테이블 뷰의 데이터 소스를 설정합니다.
    ///
    /// - Parameter dataSource: 테이블 뷰의 데이터 소스 객체.
    @discardableResult
    func dataSource(_ dataSource: UITableViewDataSource?) -> Self {
        self.dataSource = dataSource
        return self
    }
    
    /// 테이블 뷰의 델리게이트를 설정합니다.
    ///
    /// - Parameter delegate: 테이블 뷰의 델리게이트 객체
    @discardableResult
    func delegate(_ delegate: UITableViewDelegate?) -> Self {
        self.delegate = delegate
        return self
    }
}

// MARK: - Layout & View
public extension UITableView {
    /// 테이블 뷰의 기본 행 높이를 설정합니다.
    ///
    /// - Parameter height: 설정할 행 높이.
    @discardableResult
    func rowHeight(_ height: CGFloat) -> Self {
        self.rowHeight = height
        return self
    }
    
    /// 테이블 뷰의 예상 행 높이를 설정합니다. `rowHeight`가 `automaticDimension`일 때 유용합니다.
    ///
    /// - Parameter height: 설정할 예상 행 높이.
    @discardableResult
    func estimatedRowHeight(_ height: CGFloat) -> Self {
        self.estimatedRowHeight = height
        return self
    }
    
    /// 테이블 뷰 섹션 헤더의 기본 높이를 설정합니다.
    ///
    /// - Parameter height: 설정할 섹션 헤더 높이.
    @discardableResult
    func sectionHeaderHeight(_ height: CGFloat) -> Self {
        self.sectionHeaderHeight = height
        return self
    }
    
    /// 테이블 뷰 섹션 헤더의 예상 높이를 설정합니다. `sectionHeaderHeight`가 `automaticDimension`일 때 유용합니다.
    ///
    /// - Parameter height: 설정할 예상 섹션 헤더 높이.
    @discardableResult
    func estimatedSectionHeaderHeight(_ height: CGFloat) -> Self {
        self.estimatedSectionHeaderHeight = height
        return self
    }
    
    /// 테이블 뷰 섹션 푸터의 기본 높이를 설정합니다.
    ///
    /// - Parameter height: 설정할 섹션 푸터 높이.
    @discardableResult
    func sectionFooterHeight(_ height: CGFloat) -> Self {
        self.sectionFooterHeight = height
        return self
    }
    
    /// 테이블 뷰 섹션 푸터의 예상 높이를 설정합니다. `sectionFooterHeight`가 `automaticDimension`일 때 유용합니다.
    ///
    /// - Parameter height: 설정할 예상 섹션 푸터 높이.
    @discardableResult
    func estimatedSectionFooterHeight(_ height: CGFloat) -> Self {
        self.estimatedSectionFooterHeight = height
        return self
    }
    
    /// 테이블 뷰의 헤더 뷰를 설정합니다.
    ///
    /// - Parameter view: 테이블 뷰의 헤더로 사용할 UIView 인스턴스.
    @discardableResult
    func tableHeaderView(_ view: UIView?) -> Self {
        self.tableHeaderView = view
        return self
    }
    
    /// 테이블 뷰의 푸터 뷰를 설정합니다.
    ///
    /// - Parameter view: 테이블 뷰의 푸터로 사용할 UIView 인스턴스.
    @discardableResult
    func tableFooterView(_ view: UIView?) -> Self {
        self.tableFooterView = view
        return self
    }
}
