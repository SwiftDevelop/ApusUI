//
//  UIAlertController+Swizzling.swift
//  ApusUI
//
//  Created by SwiftDevelop on 2025/12/10.
//

import UIKit

// MARK: - AssociatedKeys
/// Associated Object 키 관리를 위한 열거형.
@MainActor private enum AssociatedKeys {
    // MARK: Properties
    /// Alert 해제 핸들러 저장을 위한 고유 키.
    static var alertDismissHandlerKey: UInt8 = 0
}

extension UIAlertController {
    // MARK: - Properties
    /// Alert이 해제될 때 실행될 클로저 핸들러.
    var apus_dismissHandler: (() -> Void)? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.alertDismissHandlerKey) as? () -> Void
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.alertDismissHandlerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // MARK: - Swizzling Setup
    /// 스위즐링이 앱 생명주기 동안 한 번만 실행되도록 보장하는 정적 변수.
    private static let swizzleOnce: () = {
        let originalSelector = #selector(viewDidDisappear(_:))
        let swizzledSelector = #selector(apus_viewDidDisappear(_:))
        
        guard let originalMethod = class_getInstanceMethod(UIAlertController.self, originalSelector),
              let swizzledMethod = class_getInstanceMethod(UIAlertController.self, swizzledSelector) else {
            return
        }
        
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }()
    
    // MARK: - Public Methods
    /**
     `UIAlertController`의 `viewDidDisappear(_:)` 메서드를 스위즐링하여 커스텀 해제 핸들러를 추가합니다.
     
     이 메서드는 스위즐링 설정을 보장하기 위해 앱의 생명주기 동안 한 번만 호출되어야 합니다.
     */
    static func apus_swizzleViewDidDisappear() {
        _ = swizzleOnce
    }
    
    // MARK: - Private Swizzled Methods
    /// 원본 `viewDidDisappear`를 대체하여 Alert 해제 시점을 감지하고 핸들러를 실행합니다.
    @objc private func apus_viewDidDisappear(_ animated: Bool) {
        // 원래의 `viewDidDisappear` 구현을 호출합니다. (현재는 `apus_viewDidDisappear` 셀렉터 위치에 있습니다.)
        self.apus_viewDidDisappear(animated)
        
        // 뷰 컨트롤러가 해제되는 중이라면 (isBeingDismissed는 해제 이벤트의 신뢰할 수 있는 지표), 커스텀 핸들러를 실행합니다.
        if isBeingDismissed {
            self.apus_dismissHandler?()
            // retain cycle 방지 및 중복 호출을 막기 위해 핸들러를 정리합니다.
            self.apus_dismissHandler = nil
        }
    }
}
