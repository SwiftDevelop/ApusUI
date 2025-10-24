//
//  UIView+Layout.swift
//  ApusUI
//
//  Created by SwiftDevelop on 10/24/25.
//

import UIKit

internal extension UIView {
    @MainActor private enum AssociatedKeys {
        static var pendingConstraints: UInt8 = 0
        static var ignoredSafeAreaEdges: UInt8 = 1
    }
    
    fileprivate var pendingConstraints: [() -> Void] {
        get {
            objc_getAssociatedObject(self, &AssociatedKeys.pendingConstraints) as? [() -> Void] ?? []
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.pendingConstraints, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    fileprivate var ignoredSafeAreaEdges: UIRectEdge {
        get {
            objc_getAssociatedObject(self, &AssociatedKeys.ignoredSafeAreaEdges) as? UIRectEdge ?? []
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.ignoredSafeAreaEdges, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    fileprivate func addPendingConstraint(_ constraint: @escaping () -> Void) {
        if superview != nil {
            constraint()
        } else {
            pendingConstraints.append(constraint)
        }
    }
    
    func applyPendingConstraints() {
        pendingConstraints.forEach { $0() }
        pendingConstraints.removeAll()
    }
}

// MARK: - Padding
public extension UIView {
    @discardableResult
    func padding(_ insets: UIEdgeInsets) -> Self {
        addPendingConstraint { [weak self] in
            guard let self = self, let superview = self.superview else { return }
            self.translatesAutoresizingMaskIntoConstraints = false
            
            let ignoredEdges = self.ignoredSafeAreaEdges
            
            // Safe Area 기준으로 할지 superview 기준으로 할지 결정
            let topAnchor: NSLayoutYAxisAnchor
            let leadingAnchor: NSLayoutXAxisAnchor
            let trailingAnchor: NSLayoutXAxisAnchor
            let bottomAnchor: NSLayoutYAxisAnchor
            
            if let viewController = self.findViewController() {
                let safeArea = viewController.view.safeAreaLayoutGuide
                topAnchor = ignoredEdges.contains(.top) ? superview.topAnchor : safeArea.topAnchor
                leadingAnchor = ignoredEdges.contains(.left) ? superview.leadingAnchor : safeArea.leadingAnchor
                trailingAnchor = ignoredEdges.contains(.right) ? superview.trailingAnchor : safeArea.trailingAnchor
                bottomAnchor = ignoredEdges.contains(.bottom) ? superview.bottomAnchor : safeArea.bottomAnchor
            } else {
                // ViewController를 못 찾으면 superview 기준
                topAnchor = superview.topAnchor
                leadingAnchor = superview.leadingAnchor
                trailingAnchor = superview.trailingAnchor
                bottomAnchor = superview.bottomAnchor
            }
            
            NSLayoutConstraint.activate([
                self.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
                self.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left),
                self.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right),
                self.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom)
            ])
        }
        return self
    }
    
    @discardableResult
    func padding(_ all: CGFloat = 0) -> Self {
        return padding(UIEdgeInsets(top: all, left: all, bottom: all, right: all))
    }
    
    @discardableResult
    func padding(top: CGFloat? = nil, left: CGFloat? = nil, bottom: CGFloat? = nil, right: CGFloat? = nil) -> Self {
        addPendingConstraint { [weak self] in
            guard let self = self, let superview = self.superview else { return }
            self.translatesAutoresizingMaskIntoConstraints = false
            
            let ignoredEdges = self.ignoredSafeAreaEdges
            var constraints: [NSLayoutConstraint] = []
            
            if let viewController = self.findViewController() {
                let safeArea = viewController.view.safeAreaLayoutGuide
                
                if let top = top {
                    let anchor = ignoredEdges.contains(.top) ? superview.topAnchor : safeArea.topAnchor
                    constraints.append(self.topAnchor.constraint(equalTo: anchor, constant: top))
                }
                if let left = left {
                    let anchor = ignoredEdges.contains(.left) ? superview.leadingAnchor : safeArea.leadingAnchor
                    constraints.append(self.leadingAnchor.constraint(equalTo: anchor, constant: left))
                }
                if let bottom = bottom {
                    let anchor = ignoredEdges.contains(.bottom) ? superview.bottomAnchor : safeArea.bottomAnchor
                    constraints.append(self.bottomAnchor.constraint(equalTo: anchor, constant: -bottom))
                }
                if let right = right {
                    let anchor = ignoredEdges.contains(.right) ? superview.trailingAnchor : safeArea.trailingAnchor
                    constraints.append(self.trailingAnchor.constraint(equalTo: anchor, constant: -right))
                }
            } else {
                // ViewController를 못 찾으면 superview 기준
                if let top = top {
                    constraints.append(self.topAnchor.constraint(equalTo: superview.topAnchor, constant: top))
                }
                if let left = left {
                    constraints.append(self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: left))
                }
                if let bottom = bottom {
                    constraints.append(self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -bottom))
                }
                if let right = right {
                    constraints.append(self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -right))
                }
            }
            
            NSLayoutConstraint.activate(constraints)
        }
        return self
    }
    
    @discardableResult
    func padding(horizontal: CGFloat) -> Self {
        return padding(UIEdgeInsets(top: 0, left: horizontal, bottom: 0, right: horizontal))
    }
    
    @discardableResult
    func padding(vertical: CGFloat) -> Self {
        return padding(UIEdgeInsets(top: vertical, left: 0, bottom: vertical, right: 0))
    }
}

// MARK: - Frame
public extension UIView {
    @discardableResult
    func frame(width: CGFloat? = nil, height: CGFloat? = nil) -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let width = width {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
        return self
    }
}

// MARK: - Center
public extension UIView {
    @discardableResult
    func center() -> Self {
        addPendingConstraint { [weak self] in
            guard let self = self, let superview = self.superview else { return }
            self.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                self.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
                self.centerYAnchor.constraint(equalTo: superview.centerYAnchor)
            ])
        }
        return self
    }
    
    @discardableResult
    func centerX(offset: CGFloat = 0) -> Self {
        addPendingConstraint { [weak self] in
            guard let self = self, let superview = self.superview else { return }
            self.translatesAutoresizingMaskIntoConstraints = false
            self.centerXAnchor.constraint(equalTo: superview.centerXAnchor, constant: offset).isActive = true
        }
        return self
    }
    
    @discardableResult
    func centerY(offset: CGFloat = 0) -> Self {
        addPendingConstraint { [weak self] in
            guard let self = self, let superview = self.superview else { return }
            self.translatesAutoresizingMaskIntoConstraints = false
            self.centerYAnchor.constraint(equalTo: superview.centerYAnchor, constant: offset).isActive = true
        }
        return self
    }
}

// MARK: - Safe Area
public extension UIView {
    @discardableResult
    func edgesIgnoringSafeArea(_ edges: UIRectEdge = .all) -> Self {
        self.ignoredSafeAreaEdges = edges
        return self
    }
}

// MARK: - Helper to find ViewController
public extension UIView {
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
}

