//
//  UIProgressView+Extension.swift
//  ApusUI
//
//  Created by SwiftDevelop on 11/4/25.
//

import UIKit

// MARK: - AssociatedKeys
@MainActor private enum AssociatedKeys {
    static var progressObserverKey: UInt8 = 0
}

// MARK: - KVOObserver for Progress
@MainActor private final class ProgressObserver: NSObject {
    private weak var progressView: UIProgressView?
    private var observation: NSKeyValueObservation?

    init(progressView: UIProgressView) {
        self.progressView = progressView
        super.init()
        self.observation = progressView.observe(\.progress, options: [.new, .initial]) { [weak self] view, _ in
            self?.updateVisibility(for: view)
        }
    }

    private func updateVisibility(for view: UIProgressView) {
        DispatchQueue.main.async {
            view.isHidden = (view.progress == 0.0 || view.progress == 1.0)
        }
    }

    deinit {
        observation?.invalidate()
    }
}

public extension UIProgressView {
    /// 프로그레스 뷰의 진행 상태를 설정합니다.
    /// - Parameters:
    ///   - progress: 설정할 진행 값입니다. (0.0 ~ 1.0)
    ///   - animated: 변경 사항을 애니메이션으로 보여줄지 여부입니다.
    @discardableResult
    func progress(_ progress: Float, animated: Bool = false) -> Self {
        self.setProgress(progress, animated: animated)
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
    
    /// 진행률이 0 또는 1일 때 프로그레스 뷰를 자동으로 숨기는 동작을 활성화/비활성화합니다.
    /// - Parameter enabled: 자동 숨김 기능을 활성화할지 여부. 기본값은 `true`입니다.
    /// - Returns: 체이닝을 위한 `UIProgressView` 인스턴스.
    @discardableResult
    func autoHidden(_ enabled: Bool = true) -> Self {
        if enabled {
            // 이미 옵저버가 설정된 경우 중복 생성을 방지합니다.
            if objc_getAssociatedObject(self, &AssociatedKeys.progressObserverKey) == nil {
                let observer = ProgressObserver(progressView: self)
                objc_setAssociatedObject(self, &AssociatedKeys.progressObserverKey, observer, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        } else {
            // 옵저버를 제거합니다.
            objc_setAssociatedObject(self, &AssociatedKeys.progressObserverKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            // 자동 숨김이 비활성화되면, isHidden 상태를 기본값인 false로 되돌립니다.
            self.isHidden = false
        }
        return self
    }
}
