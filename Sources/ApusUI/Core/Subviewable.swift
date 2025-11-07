//
//  Subviewable.swift
//  ApusUI
//
//  Created by SwiftDevelop on 10/29/25.
//

import UIKit

/// `SubviewBuilder`를 사용하여 뷰에 서브뷰를 선언적으로 추가할 수 있게 하는 프로토콜입니다.
public protocol Subviewable: AnyObject { }

@MainActor
public extension Subviewable {
    /// Result Builder를 사용하여 여러 서브뷰를 추가합니다.
    /// - Parameter builder: 추가할 서브뷰들을 반환하는 클로저입니다.
    /// - Returns: 서브뷰가 추가된 자기 자신을 반환합니다.
    @discardableResult
    func subviews(@SubviewBuilder _ builder: () -> [UIView]) -> Self {
        let views = builder()
        views.forEach { subview in
            (self as? UIView)?.addSubview(subview)
            subview.applyPendingConstraints()
        }
        return self
    }
    
    /// 자기 자신을 파라미터로 받아 서브뷰를 추가하는 Result Builder입니다.
    /// - Parameter builder: 자기 자신을 파라미터로 받아 추가할 서브뷰들을 반환하는 클로저입니다.
    /// - Returns: 서브뷰가 추가된 자기 자신을 반환합니다.
    @discardableResult
    func subviews(@SubviewBuilder _ builder: (Self) -> [UIView]) -> Self {
        let views = builder(self)
        views.forEach { subview in
            (self as? UIView)?.addSubview(subview)
            subview.applyPendingConstraints()
        }
        return self
    }
}

extension UIView: Subviewable { }
