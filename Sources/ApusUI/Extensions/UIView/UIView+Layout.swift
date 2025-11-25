//
//  UIView+Layout.swift
//  ApusUI
//
//  Created by SwiftDevelop on 10/24/25.
//

import UIKit

// MARK: - AssociatedKeys
@MainActor private enum AssociatedKeys {
    static var pendingConstraintsKey: UInt8 = 0
    static var ignoredSafeAreaEdgesKey: UInt8 = 1
}

// MARK: - Internal Extensions
internal extension UIView {
    /// 뷰가 슈퍼뷰에 추가되기 전에 임시로 저장되는 제약 조건 클로저 배열입니다.
    fileprivate var pendingConstraints: [() -> Void] {
        get {
            objc_getAssociatedObject(self, &AssociatedKeys.pendingConstraintsKey) as? [() -> Void] ?? []
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.pendingConstraintsKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /// `padding` 적용 시 무시할 safe area 가장자리입니다.
    fileprivate var ignoredSafeAreaEdges: UIRectEdge {
        get {
            objc_getAssociatedObject(self, &AssociatedKeys.ignoredSafeAreaEdgesKey) as? UIRectEdge ?? []
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.ignoredSafeAreaEdgesKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /// 제약 조건 클로저를 추가합니다. 뷰가 슈퍼뷰에 이미 추가되었다면 즉시 실행하고, 그렇지 않으면 `pendingConstraints`에 추가합니다.
    fileprivate func addPendingConstraint(_ constraint: @escaping () -> Void) {
        if superview != nil {
            constraint()
        } else {
            pendingConstraints.append(constraint)
        }
    }
    
    /// Responder chain을 따라 올라가면서 현재 뷰를 포함하는 뷰 컨트롤러를 찾습니다.
    fileprivate func findViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while let nextResponder = responder?.next {
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            responder = nextResponder
        }
        return nil
    }
    
    /// 보류 중인 모든 제약 조건을 활성화하고 배열을 비웁니다.
    func applyPendingConstraints() {
        pendingConstraints.forEach { $0() }
        pendingConstraints.removeAll()
    }
}

// MARK: - Padding
public extension UIView {
    /// 뷰의 여백(padding)을 설정합니다. Safe Area를 기본적으로 존중합니다.
    @discardableResult
    func padding(top: CGFloat? = nil, left: CGFloat? = nil, bottom: CGFloat? = nil, right: CGFloat? = nil) -> Self {
        addPendingConstraint { [weak self] in
            guard let self, let superview else { return }
            translatesAutoresizingMaskIntoConstraints = false
            
            let ignoredEdges = ignoredSafeAreaEdges
            var constraints: [NSLayoutConstraint] = []
            
            if let viewController = findViewController() {
                let safeArea = viewController.view.safeAreaLayoutGuide
                
                if let top {
                    let anchor = ignoredEdges.contains(.top) ? superview.topAnchor : safeArea.topAnchor
                    constraints.append(topAnchor.constraint(equalTo: anchor, constant: top))
                }
                if let left {
                    let anchor = ignoredEdges.contains(.left) ? superview.leadingAnchor : safeArea.leadingAnchor
                    constraints.append(leadingAnchor.constraint(equalTo: anchor, constant: left))
                }
                if let bottom {
                    let anchor = ignoredEdges.contains(.bottom) ? superview.bottomAnchor : safeArea.bottomAnchor
                    constraints.append(bottomAnchor.constraint(equalTo: anchor, constant: -bottom))
                }
                if let right {
                    let anchor = ignoredEdges.contains(.right) ? superview.trailingAnchor : safeArea.trailingAnchor
                    constraints.append(trailingAnchor.constraint(equalTo: anchor, constant: -right))
                }
            } else {
                // ViewController를 못 찾으면 superview 기준
                if let top {
                    constraints.append(topAnchor.constraint(equalTo: superview.topAnchor, constant: top))
                }
                if let left {
                    constraints.append(leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: left))
                }
                if let bottom {
                    constraints.append(bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -bottom))
                }
                if let right {
                    constraints.append(trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -right))
                }
            }
            
            NSLayoutConstraint.activate(constraints)
        }
        return self
    }
    
    /// 뷰의 모든 방향에 동일한 여백을 설정합니다.
    @discardableResult
    func padding(_ all: CGFloat = 0) -> Self {
        return padding(top: all, left: all, bottom: all, right: all)
    }
    
    /// 뷰의 수평 방향(좌, 우)에 동일한 여백을 설정합니다.
    @discardableResult
    func padding(horizontal: CGFloat) -> Self {
        return padding(left: horizontal, right: horizontal)
    }
    
    /// 뷰의 수직 방향(상, 하)에 동일한 여백을 설정합니다.
    @discardableResult
    func padding(vertical: CGFloat) -> Self {
        return padding(top: vertical, bottom: vertical)
    }
}

// MARK: - Frame
public extension UIView {
    /// 뷰의 너비와 높이를 설정합니다.
    @discardableResult
    func frame(width: CGFloat? = nil, height: CGFloat? = nil) -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let width {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
        return self
    }
}

// MARK: - Center
public extension UIView {
    /// 뷰를 슈퍼뷰의 중앙에 위치시킵니다.
    @discardableResult
    func center() -> Self {
        addPendingConstraint { [weak self] in
            guard let self, let superview else { return }
            translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                centerXAnchor.constraint(equalTo: superview.centerXAnchor),
                centerYAnchor.constraint(equalTo: superview.centerYAnchor)
            ])
        }
        return self
    }
    
    /// 뷰를 슈퍼뷰의 수평 중앙에 위치시킵니다.
    /// - Parameter offset: 중앙에서의 수평 오프셋입니다.
    @discardableResult
    func centerX(offset: CGFloat = 0) -> Self {
        addPendingConstraint { [weak self] in
            guard let self, let superview else { return }
            translatesAutoresizingMaskIntoConstraints = false
            centerXAnchor.constraint(equalTo: superview.centerXAnchor, constant: offset).isActive = true
        }
        return self
    }
    
    /// 뷰를 슈퍼뷰의 수직 중앙에 위치시킵니다.
    /// - Parameter offset: 중앙에서의 수직 오프셋입니다.
    @discardableResult
    func centerY(offset: CGFloat = 0) -> Self {
        addPendingConstraint { [weak self] in
            guard let self, let superview else { return }
            translatesAutoresizingMaskIntoConstraints = false
            centerYAnchor.constraint(equalTo: superview.centerYAnchor, constant: offset).isActive = true
        }
        return self
    }
}

// MARK: - Safe Area
public extension UIView {
    /// `padding` 적용 시 무시할 Safe Area의 가장자리를 지정합니다.
    /// - Parameter edges: 무시할 가장자리입니다. `.all`은 모든 방향을 무시합니다.
    @discardableResult
    func edgesIgnoringSafeArea(_ edges: UIRectEdge = .all) -> Self {
        self.ignoredSafeAreaEdges = edges
        return self
    }
}
