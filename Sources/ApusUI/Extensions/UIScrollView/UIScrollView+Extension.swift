//
//  UIScrollView+Extension.swift
//  ApusUI
//
//  Created by SwiftDevelop on 10/27/25.
//

import UIKit

@MainActor private enum AssociatedKeys {
    static var contentOffsetObservations: UInt8 = 0
}

@MainActor
private final class KVOObserver: NSObject {
    private let action: @Sendable (CGPoint) -> Void
    private var observation: NSKeyValueObservation?
    
    init(scrollView: UIScrollView, action: @escaping @Sendable (CGPoint) -> Void) {
        self.action = action
        super.init()
        self.observation = scrollView.observe(\.contentOffset, options: [.new]) { [weak self] _, change in
            guard let self, let value = change.newValue else { return }
            self.action(value)
        }
    }
    
    deinit {
        observation?.invalidate()
    }
}

public extension UIScrollView {
    @discardableResult
    func contentInset(_ insets: UIEdgeInsets) -> Self {
        self.contentInset = insets
        return self
    }

    @discardableResult
    func showsVerticalScrollIndicator(_ shows: Bool) -> Self {
        self.showsVerticalScrollIndicator = shows
        return self
    }

    @discardableResult
    func showsHorizontalScrollIndicator(_ shows: Bool) -> Self {
        self.showsHorizontalScrollIndicator = shows
        return self
    }

    @discardableResult
    func isPagingEnabled(_ enabled: Bool) -> Self {
        self.isPagingEnabled = enabled
        return self
    }

    @discardableResult
    func isScrollEnabled(_ enabled: Bool) -> Self {
        self.isScrollEnabled = enabled
        return self
    }

    @discardableResult
    func bounces(_ bounces: Bool) -> Self {
        self.bounces = bounces
        return self
    }
    
    @MainActor
    @discardableResult
    func onContentOffsetChange(_ action: @escaping @Sendable (CGPoint) -> Void) -> Self {
        var observers = objc_getAssociatedObject(self, &AssociatedKeys.contentOffsetObservations) as? [KVOObserver] ?? []
        
        let observer = KVOObserver(scrollView: self, action: action)
        observers.append(observer)
        
        objc_setAssociatedObject(self, &AssociatedKeys.contentOffsetObservations, observers, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        return self
    }
}
