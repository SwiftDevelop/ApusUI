//
//  UITableView+Delegate.swift
//  ApusUI
//
//  Created by SwiftDevelop on 11/13/25.
//

import UIKit

// MARK: - AssociatedKeys
@MainActor private enum AssociatedKeys {
    static var delegateKey: UInt8 = 0
}

/// UITableViewDelegate 프로토콜을 선언형 방식으로 처리하기 위한 핸들러 클래스.
/// 이 클래스는 델리게이트의 다양한 이벤트를 클로저 기반으로 처리합니다.
internal final class TableViewDelegateHandler: NSObject, UITableViewDelegate {
    
    // MARK: - Properties
    
    /// 행이 선택되었을 때 실행될 클로저.
    var onSelect: ((IndexPath) -> Void)?
    /// 행의 선택이 해제되었을 때 실행될 클로저.
    var onDeselect: ((IndexPath) -> Void)?
    /// 각 행의 높이를 반환하는 클로저.
    var onRowHeight: ((IndexPath) -> CGFloat)?
    /// 각 섹션의 헤더 뷰를 반환하는 클로저.
    var onSectionHeader: ((Int) -> UIView?)?
    /// 각 섹션의 푸터 뷰를 반환하는 클로저.
    var onSectionFooter: ((Int) -> UIView?)?
    /// 모든 섹션 헤더에 적용될 고정 높이. `nil`이면 `tableView.sectionHeaderHeight`를 따릅니다.
    var sectionHeaderHeight: CGFloat?
    /// 모든 섹션 푸터에 적용될 고정 높이. `nil`이면 `tableView.sectionFooterHeight`를 따릅니다.
    var sectionFooterHeight: CGFloat?
    /// 각 행의 선행 스와이프 액션 구성을 반환하는 클로저.
    var onLeadingSwipeActions: ((IndexPath) -> UISwipeActionsConfiguration?)?
    /// 각 행의 후행 스와이프 액션 구성을 반환하는 클로저.
    var onTrailingSwipeActions: ((IndexPath) -> UISwipeActionsConfiguration?)?
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onSelect?(indexPath)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        onDeselect?(indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return onRowHeight?(indexPath) ?? tableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return onSectionHeader?(section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // onSectionHeader가 설정되지 않았다면 헤더를 표시하지 않으므로 높이 0 반환
        guard onSectionHeader != nil else { return 0 }
        return sectionHeaderHeight ?? tableView.sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return onSectionFooter?(section)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        // onSectionFooter가 설정되지 않았다면 푸터를 표시하지 않으므로 높이 0 반환
        guard onSectionFooter != nil else { return 0 }
        return sectionFooterHeight ?? tableView.sectionFooterHeight
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return onLeadingSwipeActions?(indexPath)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return onTrailingSwipeActions?(indexPath)
    }
}

// MARK: - Internal Extension
internal extension UITableView {
    /// `UITableView`에 대한 `TableViewDelegateHandler`를 가져오거나 생성합니다.
    /// 이 핸들러는 `delegate`로 자동 설정됩니다.
    var delegateHandler: TableViewDelegateHandler {
        if let handler = objc_getAssociatedObject(self, &AssociatedKeys.delegateKey) as? TableViewDelegateHandler {
            return handler
        }
        
        let handler = TableViewDelegateHandler()
        objc_setAssociatedObject(self, &AssociatedKeys.delegateKey, handler, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        self.delegate = handler
        return handler
    }
}

// MARK: - Public Declarative API
public extension UITableView {
    /// 행을 탭했을 때 실행될 액션을 설정합니다. (`didSelectRowAt`)
    ///
    /// - Parameter action: 행의 `IndexPath`를 파라미터로 받는 클로저.
    /// - Returns: 체이닝을 위한 UITableView 인스턴스.
    @discardableResult
    func onSelect(_ action: @escaping (IndexPath) -> Void) -> Self {
        delegateHandler.onSelect = action
        return self
    }
    
    /// 행의 선택이 해제되었을 때 실행될 액션을 설정합니다. (`didDeselectRowAt`)
    ///
    /// - Parameter action: 행의 `IndexPath`를 파라미터로 받는 클로저.
    /// - Returns: 체이닝을 위한 UITableView 인스턴스.
    @discardableResult
    func onDeselect(_ action: @escaping (IndexPath) -> Void) -> Self {
        delegateHandler.onDeselect = action
        return self
    }
    
    /// 각 행의 높이를 동적으로 설정합니다. (`heightForRowAt`)
    ///
    /// - Parameter action: `IndexPath`를 받아 `CGFloat` 높이를 반환하는 클로저.
    /// - Returns: 체이닝을 위한 UITableView 인스턴스.
    @discardableResult
    func rowHeight(_ action: @escaping (IndexPath) -> CGFloat) -> Self {
        delegateHandler.onRowHeight = action
        return self
    }
    
    /// 각 섹션의 헤더 뷰를 설정합니다.
    ///
    /// - Parameters:
    ///   - height: 모든 섹션 헤더에 적용할 고정 높이. `nil`이면 `tableView.sectionHeaderHeight`를 따릅니다.
    ///   - builder: 섹션 인덱스를 받아 `UIView`를 반환하는 클로저.
    /// - Returns: 체이닝을 위한 UITableView 인스턴스.
    @discardableResult
    func sectionHeader(height: CGFloat? = nil, builder: @escaping (Int) -> UIView?) -> Self {
        delegateHandler.sectionHeaderHeight = height
        delegateHandler.onSectionHeader = builder
        return self
    }
    
    /// 각 섹션의 푸터 뷰를 설정합니다.
    ///
    /// - Parameters:
    ///   - height: 모든 섹션 푸터에 적용할 고정 높이. `nil`이면 `tableView.sectionFooterHeight`를 따릅니다.
    ///   - builder: 섹션 인덱스를 받아 `UIView`를 반환하는 클로저.
    /// - Returns: 체이닝을 위한 UITableView 인스턴스.
    @discardableResult
    func sectionFooter(height: CGFloat? = nil, builder: @escaping (Int) -> UIView?) -> Self {
        delegateHandler.sectionFooterHeight = height
        delegateHandler.onSectionFooter = builder
        return self
    }
    
    /// 각 행의 선행 스와이프 액션을 설정합니다. (`leadingSwipeActionsConfigurationForRowAt`)
    ///
    /// - Parameter action: `IndexPath`를 받아 `UISwipeActionsConfiguration`을 반환하는 클로저.
    /// - Returns: 체이닝을 위한 UITableView 인스턴스.
    @discardableResult
    func leadingSwipeActions(_ action: @escaping (IndexPath) -> UISwipeActionsConfiguration?) -> Self {
        delegateHandler.onLeadingSwipeActions = action
        return self
    }
    
    /// 각 행의 후행 스와이프 액션을 설정합니다. (`trailingSwipeActionsConfigurationForRowAt`)
    ///
    /// - Parameter action: `IndexPath`를 받아 `UISwipeactionsConfiguration`을 반환하는 클로저.
    /// - Returns: 체이닝을 위한 UITableView 인스턴스.
    @discardableResult
    func trailingSwipeActions(_ action: @escaping (IndexPath) -> UISwipeActionsConfiguration?) -> Self {
        delegateHandler.onTrailingSwipeActions = action
        return self
    }
}