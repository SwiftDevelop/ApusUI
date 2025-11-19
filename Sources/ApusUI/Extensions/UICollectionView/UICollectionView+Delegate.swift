//
//  UICollectionView+Delegate.swift
//  ApusUI
//
//  Created by SwiftDevelop on 11/17/25.
//

import UIKit

// MARK: - AssociatedKeys
@MainActor private enum AssociatedKeys {
    static var delegateKey: UInt8 = 0
}

/// UICollectionViewDelegate 및 UICollectionViewDelegateFlowLayout 프로토콜을 선언형 방식으로 처리하기 위한 핸들러 클래스.
internal final class CollectionViewDelegateHandler: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    
    // UICollectionViewDelegate
    var onSelectItem: ((IndexPath) -> Void)?
    var onDeselectItem: ((IndexPath) -> Void)?
    var onHighlightItem: ((IndexPath) -> Void)?
    var onUnhighlightItem: ((IndexPath) -> Void)?
    var onDisplayCell: ((UICollectionViewCell, IndexPath) -> Void)?
    var onEndDisplayingCell: ((UICollectionViewCell, IndexPath) -> Void)?
    
    // UICollectionViewDelegateFlowLayout
    var onSizeForItem: ((UICollectionViewLayout, IndexPath) -> CGSize)?
    var onInsetForSection: ((UICollectionViewLayout, Int) -> UIEdgeInsets)?
    var onMinimumLineSpacingForSection: ((UICollectionViewLayout, Int) -> CGFloat)?
    var onMinimumInteritemSpacingForSection: ((UICollectionViewLayout, Int) -> CGFloat)?
    var onReferenceSizeForHeader: ((UICollectionViewLayout, Int) -> CGSize)?
    var onReferenceSizeForFooter: ((UICollectionViewLayout, Int) -> CGSize)?
    
    // MARK: - UICollectionViewDelegate Methods
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onSelectItem?(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        onDeselectItem?(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        onHighlightItem?(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        onUnhighlightItem?(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        onDisplayCell?(cell, indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        onEndDisplayingCell?(cell, indexPath)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout Methods
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return onSizeForItem?(collectionViewLayout, indexPath) ?? (collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return onInsetForSection?(collectionViewLayout, section) ?? (collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return onMinimumLineSpacingForSection?(collectionViewLayout, section) ?? (collectionViewLayout as? UICollectionViewFlowLayout)?.minimumLineSpacing ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return onMinimumInteritemSpacingForSection?(collectionViewLayout, section) ?? (collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return onReferenceSizeForHeader?(collectionViewLayout, section) ?? (collectionViewLayout as? UICollectionViewFlowLayout)?.headerReferenceSize ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return onReferenceSizeForFooter?(collectionViewLayout, section) ?? (collectionViewLayout as? UICollectionViewFlowLayout)?.footerReferenceSize ?? .zero
    }
}

// MARK: - Internal Extension
internal extension UICollectionView {
    /// `UICollectionView`에 대한 `CollectionViewDelegateHandler`를 가져오거나 생성합니다.
    /// 이 핸들러는 `delegate`로 자동 설정됩니다.
    var delegateHandler: CollectionViewDelegateHandler {
        if let handler = objc_getAssociatedObject(self, &AssociatedKeys.delegateKey) as? CollectionViewDelegateHandler {
            return handler
        }
        
        let handler = CollectionViewDelegateHandler()
        objc_setAssociatedObject(self, &AssociatedKeys.delegateKey, handler, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        self.delegate = handler
        return handler
    }
}

// MARK: - Public Declarative API
public extension UICollectionView {
    /// 아이템을 탭했을 때 실행될 액션을 설정합니다. (`didSelectItemAt`)
    /// - Warning: 클로저 내에서 `self`를 참조할 경우, 메모리 누수를 방지하기 위해 `[weak self]`를 사용해야 합니다.
    @discardableResult
    func onSelect(_ action: @escaping (IndexPath) -> Void) -> Self {
        delegateHandler.onSelectItem = action
        return self
    }
    
    /// 아이템 선택이 해제되었을 때 실행될 액션을 설정합니다. (`didDeselectItemAt`)
    /// - Warning: 클로저 내에서 `self`를 참조할 경우, 메모리 누수를 방지하기 위해 `[weak self]`를 사용해야 합니다.
    @discardableResult
    func onDeselect(_ action: @escaping (IndexPath) -> Void) -> Self {
        delegateHandler.onDeselectItem = action
        return self
    }
    
    /// 아이템이 하이라이트될 때 실행될 액션을 설정합니다. (`didHighlightItemAt`)
    /// - Warning: 클로저 내에서 `self`를 참조할 경우, 메모리 누수를 방지하기 위해 `[weak self]`를 사용해야 합니다.
    @discardableResult
    func onHighlight(_ action: @escaping (IndexPath) -> Void) -> Self {
        delegateHandler.onHighlightItem = action
        return self
    }
    
    /// 아이템 하이라이트가 해제될 때 실행될 액션을 설정합니다. (`didUnhighlightItemAt`)
    /// - Warning: 클로저 내에서 `self`를 참조할 경우, 메모리 누수를 방지하기 위해 `[weak self]`를 사용해야 합니다.
    @discardableResult
    func onUnhighlight(_ action: @escaping (IndexPath) -> Void) -> Self {
        delegateHandler.onUnhighlightItem = action
        return self
    }
    
    /// 셀이 화면에 표시되기 직전에 실행될 액션을 설정합니다. (`willDisplay`)
    /// - Warning: 클로저 내에서 `self`를 참조할 경우, 메모리 누수를 방지하기 위해 `[weak self]`를 사용해야 합니다.
    @discardableResult
    func onDisplay(_ action: @escaping (UICollectionViewCell, IndexPath) -> Void) -> Self {
        delegateHandler.onDisplayCell = action
        return self
    }
    
    /// 셀이 화면에서 사라진 후에 실행될 액션을 설정합니다. (`didEndDisplaying`)
    /// - Warning: 클로저 내에서 `self`를 참조할 경우, 메모리 누수를 방지하기 위해 `[weak self]`를 사용해야 합니다.
    @discardableResult
    func onEndDisplaying(_ action: @escaping (UICollectionViewCell, IndexPath) -> Void) -> Self {
        delegateHandler.onEndDisplayingCell = action
        return self
    }
}

// MARK: - FlowLayout Specific API
public extension UICollectionView {
    /// 각 아이템의 크기를 동적으로 설정합니다. (`sizeForItemAt`)
    /// - Warning: 클로저 내에서 `self`를 참조할 경우, 메모리 누수를 방지하기 위해 `[weak self]`를 사용해야 합니다.
    @discardableResult
    func itemSize(_ action: @escaping (UICollectionViewLayout, IndexPath) -> CGSize) -> Self {
        delegateHandler.onSizeForItem = action
        return self
    }
    
    /// 모든 아이템의 고정 크기를 설정합니다.
    ///
    /// - Parameter size: 모든 아이템에 적용할 고정 `CGSize` 값.
    /// - Returns: 체이닝을 위한 UICollectionView 인스턴스.
    @discardableResult
    func itemSize(width: CGFloat, height: CGFloat) -> Self {
        delegateHandler.onSizeForItem = { _, _ in CGSize(width: width, height: height) }
        return self
    }
    
    /// 각 섹션의 콘텐츠 인셋을 동적으로 설정합니다. (`insetForSectionAt`)
    /// - Warning: 클로저 내에서 `self`를 참조할 경우, 메모리 누수를 방지하기 위해 `[weak self]`를 사용해야 합니다.
    @discardableResult
    func sectionInset(_ action: @escaping (UICollectionViewLayout, Int) -> UIEdgeInsets) -> Self {
        delegateHandler.onInsetForSection = action
        return self
    }
    
    /// 모든 섹션의 고정 콘텐츠 인셋을 설정합니다.
    ///
    /// - Parameter insets: 모든 섹션에 적용할 고정 `UIEdgeInsets` 값.
    /// - Returns: 체이닝을 위한 UICollectionView 인스턴스.
    @discardableResult
    func sectionInset(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> Self {
        delegateHandler.onInsetForSection = { _, _ in UIEdgeInsets(top: top, left: left, bottom: bottom, right: right) }
        return self
    }
    
    /// 각 섹션의 최소 줄 간격을 동적으로 설정합니다. (`minimumLineSpacingForSectionAt`)
    /// - Warning: 클로저 내에서 `self`를 참조할 경우, 메모리 누수를 방지하기 위해 `[weak self]`를 사용해야 합니다.
    @discardableResult
    func minimumLineSpacing(_ action: @escaping (UICollectionViewLayout, Int) -> CGFloat) -> Self {
        delegateHandler.onMinimumLineSpacingForSection = action
        return self
    }
    
    /// 모든 섹션의 고정 최소 줄 간격을 설정합니다.
    ///
    /// - Parameter spacing: 모든 섹션에 적용할 고정 최소 줄 간격 `CGFloat` 값.
    /// - Returns: 체이닝을 위한 UICollectionView 인스턴스.
    @discardableResult
    func minimumLineSpacing(_ spacing: CGFloat) -> Self {
        delegateHandler.onMinimumLineSpacingForSection = { _, _ in spacing }
        return self
    }
    
    /// 각 섹션의 최소 아이템 간격을 동적으로 설정합니다. (`minimumInteritemSpacingForSectionAt`)
    /// - Warning: 클로저 내에서 `self`를 참조할 경우, 메모리 누수를 방지하기 위해 `[weak self]`를 사용해야 합니다.
    @discardableResult
    func minimumInteritemSpacing(_ action: @escaping (UICollectionViewLayout, Int) -> CGFloat) -> Self {
        delegateHandler.onMinimumInteritemSpacingForSection = action
        return self
    }
    
    /// 모든 섹션의 고정 최소 아이템 간격을 설정합니다.
    ///
    /// - Parameter spacing: 모든 섹션에 적용할 고정 최소 아이템 간격 `CGFloat` 값.
    /// - Returns: 체이닝을 위한 UICollectionView 인스턴스.
    @discardableResult
    func minimumInteritemSpacing(_ spacing: CGFloat) -> Self {
        delegateHandler.onMinimumInteritemSpacingForSection = { _, _ in spacing }
        return self
    }
    
    /// 모든 섹션의 고정 최소 줄 간격과 아이템 간격을 한 번에 설정합니다.
    ///
    /// - Parameters:
    ///   - line: 모든 섹션에 적용할 고정 최소 줄 간격 `CGFloat` 값.
    ///   - interItem: 모든 섹션에 적용할 고정 최소 아이템 간격 `CGFloat` 값.
    /// - Returns: 체이닝을 위한 UICollectionView 인스턴스.
    @discardableResult
    func minimumSpacing(line: CGFloat, interItem: CGFloat) -> Self {
        delegateHandler.onMinimumLineSpacingForSection = { _, _ in line }
        delegateHandler.onMinimumInteritemSpacingForSection = { _, _ in interItem }
        return self
    }
    
    /// 각 섹션의 헤더 크기를 동적으로 설정합니다. (`referenceSizeForHeaderInSection`)
    /// - Warning: 클로저 내에서 `self`를 참조할 경우, 메모리 누수를 방지하기 위해 `[weak self]`를 사용해야 합니다.
    @discardableResult
    func headerSize(_ action: @escaping (UICollectionViewLayout, Int) -> CGSize) -> Self {
        delegateHandler.onReferenceSizeForHeader = action
        return self
    }
    
    /// 모든 섹션의 고정 헤더 크기를 설정합니다.
    ///
    /// - Parameter size: 모든 섹션에 적용할 고정 헤더 `CGSize` 값.
    /// - Returns: 체이닝을 위한 UICollectionView 인스턴스.
    @discardableResult
    func headerSize(width: CGFloat, height: CGFloat) -> Self {
        delegateHandler.onReferenceSizeForHeader = { _, _ in CGSize(width: width, height: height) }
        return self
    }
    
    /// 각 섹션의 푸터 크기를 동적으로 설정합니다. (`referenceSizeForFooterInSection`)
    /// - Warning: 클로저 내에서 `self`를 참조할 경우, 메모리 누수를 방지하기 위해 `[weak self]`를 사용해야 합니다.
    @discardableResult
    func footerSize(_ action: @escaping (UICollectionViewLayout, Int) -> CGSize) -> Self {
        delegateHandler.onReferenceSizeForFooter = action
        return self
    }
    
    /// 모든 섹션의 고정 푸터 크기를 설정합니다.
    ///
    /// - Parameter size: 모든 섹션에 적용할 고정 푸터 `CGSize` 값.
    /// - Returns: 체이닝을 위한 UICollectionView 인스턴스.
    @discardableResult
    func footerSize(width: CGFloat, height: CGFloat) -> Self {
        delegateHandler.onReferenceSizeForFooter = { _, _ in CGSize(width: width, height: height) }
        return self
    }
}
