//
//  UIAlertController+Builder.swift
//  ApusUI
//
//  Created by SwiftDevelop on 2025/12/01.
//

import UIKit

// MARK: - AlertPresenter
/// `UIAlertController`를 큐잉하여 순차적으로 표시하고 관리하는 싱글턴 클래스.
@MainActor
internal final class AlertPresenter: NSObject {
    
    // MARK: - Singleton
    static let shared = AlertPresenter() // Singleton instance
    
    // MARK: - Properties
    private var alertQueue: [(alert: UIAlertController, presentingVC: UIViewController, animated: Bool, completion: (() -> Void)?)] = []
    private var isPresentingAlert: Bool = false
    
    // MARK: - Life Cycle
    private override init() {
        super.init()
        // Activate the swizzling mechanism once.
        UIAlertController.apus_swizzleViewDidDisappear()
    }
    
    // MARK: - Public Methods
    /// 알림을 큐에 추가하고 다음 알림 표시를 시도합니다.
    func add(_ alert: UIAlertController, from presentingVC: UIViewController, animated: Bool, completion: (() -> Void)?) {
        let topMostVC = findTopMostViewController(from: presentingVC)
        alertQueue.append((alert: alert, presentingVC: topMostVC, animated: animated, completion: completion))
        presentNextAlertIfNeeded()
    }
    
    // MARK: - Private Methods
    /// 큐에 대기중인 다음 알림을 표시합니다.
    private func presentNextAlertIfNeeded() {
        guard !isPresentingAlert, !alertQueue.isEmpty else { return }
        
        isPresentingAlert = true
        let (alertController, presentingVC, animated, completion) = alertQueue.removeFirst()
        
        // Attach a dismiss handler that will be called by our swizzled `viewDidDisappear`.
        alertController.apus_dismissHandler = { [weak self] in
            self?.alertDismissed()
        }
        
        presentingVC.present(alertController, animated: animated) {
            completion?()
        }
    }
    
    /// 알림이 해제되었을 때 호출되어 다음 알림을 준비합니다.
    private func alertDismissed() {
        isPresentingAlert = false
        // 다음 알림 표시를 다음 실행 루프에서 수행하여 re-entrancy 이슈를 방지합니다.
        DispatchQueue.main.async { [weak self] in
            self?.presentNextAlertIfNeeded()
        }
    }
    
    /// 현재 화면에 보여지고 있는 가장 상위의 뷰 컨트롤러를 찾습니다. 단, `UIAlertController`는 제외합니다.
    private func findTopMostViewController(from viewController: UIViewController) -> UIViewController {
        var topVC = viewController
        while let presented = topVC.presentedViewController {
            // 이미 다른 Alert이 표시 중인 경우, 그 Alert에서 새로운 Alert을 표시하지 않도록 합니다.
            if presented is UIAlertController {
                break
            }
            topVC = presented
        }
        return topVC
    }
}

// MARK: - UIAlertController Extension
public extension UIAlertController {
    typealias SimpleActionHandler = @Sendable @MainActor () -> Void
    typealias ActionWithTextFieldsHandler = @Sendable @MainActor ([String]) -> Void
    
    // MARK: - Initializer
    /**
     `UIAlertController`를 지정된 스타일로 초기화합니다.
     - Parameter style: Alert 컨트롤러의 스타일 (`.alert` 또는 `.actionSheet`).
     */
    convenience init(style: UIAlertController.Style) {
        self.init(title: nil, message: nil, preferredStyle: style)
    }
    
    // MARK: - Configuration Methods
    /**
     Alert의 제목을 설정합니다.
     - Parameter newTitle: Alert에 표시될 새로운 제목.
     - Returns: 메서드 체이닝을 위해 자신(`Self`)을 반환합니다.
     */
    @discardableResult
    func title(_ newTitle: String?) -> Self {
        self.title = newTitle
        return self
    }
    
    /**
     Alert의 메시지를 설정합니다.
     - Parameter newMessage: Alert에 표시될 새로운 메시지.
     - Returns: 메서드 체이닝을 위해 자신(`Self`)을 반환합니다.
     */
    @discardableResult
    func message(_ newMessage: String?) -> Self {
        self.message = newMessage
        return self
    }
    
    /**
     Alert에 액션 버튼을 추가합니다.
     - Parameters:
       - title: 액션 버튼에 표시될 텍스트.
       - style: 액션의 스타일 (`.default`, `.cancel`, `.destructive`). 기본값은 `.default`입니다.
       - handler: 사용자가 액션을 탭했을 때 실행될 클로저. 클로저 내에서 Alert 컨트롤러를 참조할 경우, 순환 참조를 방지하기 위해 `[weak self]` 사용을 권장합니다. 기본값은 `nil`입니다.
     - Returns: 메서드 체이닝을 위해 자신(`Self`)을 반환합니다.
     */
    @discardableResult
    func addAction(title: String?, style: UIAlertAction.Style = .default, handler: SimpleActionHandler? = nil) -> Self {
        let action = UIAlertAction(title: title, style: style) { _ in
            handler?()
        }
        self.addAction(action)
        return self
    }
    
    /**
     Alert에 액션 버튼을 추가하고, 실행 시 Alert 내의 모든 `UITextField` 값을 핸들러로 전달합니다.
     - Parameters:
       - title: 액션 버튼에 표시될 텍스트.
       - style: 액션의 스타일 (`.default`, `.cancel`, `.destructive`). 기본값은 `.default`입니다.
       - handler: 사용자가 액션을 탭했을 때 실행될 클로저. Alert의 텍스트 필드들의 `String` 값을 배열로 받습니다. 클로저 내에서 Alert 컨트롤러를 참조할 경우, 순환 참조를 방지하기 위해 `[weak self]` 사용을 권장합니다. 기본값은 `nil`입니다.
     - Returns: 메서드 체이닝을 위해 자신(`Self`)을 반환합니다.
     */
    @discardableResult
    func addActionWithTextFields(title: String?, style: UIAlertAction.Style = .default, handler: ActionWithTextFieldsHandler? = nil) -> Self {
        let action = UIAlertAction(title: title, style: style) { [weak self] _ in
            let textFieldValues = self?.textFields?.map { $0.text ?? "" } ?? []
            handler?(textFieldValues)
        }
        self.addAction(action)
        return self
    }
    
    /**
     Alert에 `UITextField`를 추가합니다. `.alert` 스타일에서만 사용할 수 있습니다.
     (`.actionSheet` 스타일에서는 경고 메시지와 함께 무시됩니다.)
     - Parameter handler: 추가된 `UITextField`를 커스터마이징하기 위한 클로저. 기본값은 아무 동작도 하지 않는 클로저입니다.
     - Returns: 메서드 체이닝을 위해 자신(`Self`)을 반환합니다.
     */
    @discardableResult
    func addTextField(_ handler: @escaping (UITextField) -> Void = { _ in }) -> Self {
        guard self.preferredStyle == .alert else {
            print("Warning: Text fields can only be added to alerts with the .alert style.")
            return self
        }
        self.addTextField(configurationHandler: handler)
        return self
    }
    
    // MARK: - Presentation Method
    /**
     Alert을 화면에 표시합니다. Alert 큐 시스템을 통해 순차적으로 표시됩니다.
     
     만약 액션이 하나도 추가되지 않은 `.alert` 스타일의 경우, 기본 "OK" 버튼이 자동으로 추가됩니다.
     - Parameters:
       - presentingViewController: Alert을 표시할 뷰 컨트롤러.
       - animated: 화면에 표시할 때 애니메이션 효과를 사용할지 여부. 기본값은 `true`입니다.
       - completion: Alert 표시 애니메이션이 완료된 후 실행될 클로저. 기본값은 `nil`입니다.
     */
    func present(from presentingViewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        if self.actions.isEmpty && self.preferredStyle == .alert {
            self.addAction(title: "OK", style: .default)
        }
        AlertPresenter.shared.add(self, from: presentingViewController, animated: animated, completion: completion)
    }
}
