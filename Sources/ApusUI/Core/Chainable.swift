//
//  Chainable.swift
//  ApusUI
//
//  Created by SwiftDevelop on 10/24/25.
//

import UIKit

/// 객체 생성과 설정을 연속적인 체인 형태로 가능하게 하는 프로토콜입니다.
public protocol Chainable: AnyObject { }

public extension Chainable {
    /// 객체에 클로저를 적용하여 여러 설정을 한 번에 수행합니다.
    /// - Parameter configure: 객체를 받아 설정을 수행하는 클로저입니다.
    /// - Returns: 설정이 적용된 자기 자신을 반환하여 메서드 체이닝을 계속할 수 있게 합니다.
    @discardableResult
    func apply(_ configure: (Self) -> Void) -> Self {
        configure(self)
        return self
    }
}

extension UIView: Chainable { }
