//
//  UIProgressView+Extension.swift
//  ApusUI
//
//  Created by SwiftDevelop on 11/4/25.
//

import UIKit

public extension UIProgressView {
    /// 프로그레스 뷰의 진행 상태를 설정합니다.
    ///
    /// - Parameters:
    ///   - progress: 설정할 진행 값입니다. (0.0 ~ 1.0)
    ///   - animated: 변경 사항을 애니메이션으로 보여줄지 여부입니다.
    ///   - autoHide: 진행률이 0 또는 1일 때 프로그레스 뷰를 자동으로 숨길지 여부를 결정합니다. 기본값은 `false`입니다.
    /// - Returns: 체이닝을 위한 `UIProgressView` 인스턴스.
    @discardableResult
    func progress(_ progress: Float, animated: Bool = false, autoHide: Bool = true) -> Self {
        self.setProgress(progress, animated: animated)
        if autoHide {
            // isHidden 로직을 여기에 통합합니다.
            // 0일 때는 숨기고, 0보다 크고 1보다 작을 때는 보이고, 1일 때는 다시 숨깁니다.
            if progress == 0.0 || progress == 1.0 {
                self.isHidden = true
            } else {
                self.isHidden = false
            }
        }
        return self
    }
    
    /// 진행된 부분의 틴트 색상을 설정합니다.
    /// - Parameter color: 적용할 색상입니다.
    @discardableResult
    func progressTintColor(_ color: UIColor?) -> Self {
        self.progressTintColor = color
        return self
    }
    
    /// 아직 진행되지 않은 트랙 부분의 틴트 색상을 설정합니다.
    /// - Parameter color: 적용할 색상입니다.
    @discardableResult
    func trackTintColor(_ color: UIColor?) -> Self {
        self.trackTintColor = color
        return self
    }
    
    /// 트랙에 이미지를 설정합니다.
    /// - Parameter image: 적용할 이미지입니다.
    @discardableResult
    func trackImage(_ image: UIImage?) -> Self {
        self.trackImage = image
        return self
    }
}
