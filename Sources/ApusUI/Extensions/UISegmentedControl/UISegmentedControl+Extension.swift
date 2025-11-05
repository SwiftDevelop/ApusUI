//
//  UISegmentedControl+Extension.swift
//  ApusUI
//
//  Created by SwiftDevelop on 11/5/25.
//

import UIKit

// MARK: - AssociatedKey
@MainActor private struct AssociatedKey {
    static var segmentAction: UInt8 = 0
}

// MARK: - ActionWrapper
private class ActionWrapper {
    let action: (Int) -> Void
    weak var control: UISegmentedControl?
    
    init(action: @escaping (Int) -> Void, control: UISegmentedControl?) {
        self.action = action
        self.control = control
    }
    
    @MainActor @objc func invoke() {
        guard let control else { return }
        action(control.selectedSegmentIndex)
    }
}

// MARK: - Initialization
public extension UISegmentedControl {
    convenience init(items: [Any]?, action: @escaping (Int) -> Void) {
        self.init(items: items)
        self.onChange(action)
    }
}

// MARK: - Extension
public extension UISegmentedControl {
    @discardableResult
    func onChange(_ action: @escaping (Int) -> Void) -> Self {
        let wrapper = ActionWrapper(action: action, control: self)
        objc_setAssociatedObject(self, &AssociatedKey.segmentAction, wrapper, .OBJC_ASSOCIATION_RETAIN)
        self.addTarget(wrapper, action: #selector(ActionWrapper.invoke), for: .valueChanged)
        return self
    }
    
    @discardableResult
    func isMomentary(_ isMomentary: Bool) -> Self {
        self.isMomentary = isMomentary
        return self
    }
    
    @discardableResult
    func apportionsSegmentWidthsByContent(_ apportions: Bool) -> Self {
        self.apportionsSegmentWidthsByContent = apportions
        return self
    }
    
    @discardableResult
    func selectedSegmentIndex(_ index: Int) -> Self {
        self.selectedSegmentIndex = index
        
        if let wrapper = objc_getAssociatedObject(self, &AssociatedKey.segmentAction) as? ActionWrapper {
            wrapper.invoke()
        }
        return self
    }
    
    @discardableResult
    func selectedSegmentTintColor(_ color: UIColor?) -> Self {
        self.selectedSegmentTintColor = color
        return self
    }
    
    @discardableResult
    func insert(title: String?, at index: Int, animated: Bool = false) -> Self {
        self.insertSegment(withTitle: title, at: index, animated: animated)
        return self
    }
    
    @discardableResult
    func insert(image: UIImage?, at index: Int, animated: Bool = false) -> Self {
        self.insertSegment(with: image, at: index, animated: animated)
        return self
    }
    
    @discardableResult
    func remove(at index: Int, animated: Bool = false) -> Self {
        self.removeSegment(at: index, animated: animated)
        return self
    }
    
    @discardableResult
    func removeAll() -> Self {
        self.removeAllSegments()
        return self
    }
    
    @discardableResult
    func title(_ title: String?, at index: Int) -> Self {
        self.setTitle(title, forSegmentAt: index)
        return self
    }
    
    @discardableResult
    func title(_ attributes: [NSAttributedString.Key: Any]?, for state: UIControl.State) -> Self {
        self.setTitleTextAttributes(attributes, for: state)
        return self
    }
    
    @discardableResult
    func image(_ image: UIImage?, at index: Int) -> Self {
        self.setImage(image, forSegmentAt: index)
        return self
    }
    
    @discardableResult
    func width(_ width: CGFloat, at index: Int) -> Self {
        self.setWidth(width, forSegmentAt: index)
        return self
    }
    
    @discardableResult
    func contentOffset(_ offset: CGSize, at index: Int) -> Self {
        self.setContentOffset(offset, forSegmentAt: index)
        return self
    }
    
    @discardableResult
    func isEnabled(_ enabled: Bool, at index: Int) -> Self {
        self.setEnabled(enabled, forSegmentAt: index)
        return self
    }
    
    @discardableResult
    func backgroundImage(
        _ image: UIImage?,
        for state: UIControl.State,
        barMetrics: UIBarMetrics = .default
    ) -> Self {
        self.setBackgroundImage(image, for: state, barMetrics: barMetrics)
        return self
    }
    
    @discardableResult
    func dividerImage(
        _ image: UIImage?,
        forLeftSegmentState leftState: UIControl.State,
        rightSegmentState rightState: UIControl.State,
        barMetrics: UIBarMetrics = .default
    ) -> Self {
        self.setDividerImage(
            image,
            forLeftSegmentState: leftState,
            rightSegmentState: rightState,
            barMetrics: barMetrics
        )
        return self
    }
    
    @discardableResult
    func contentPositionAdjustment(
        _ adjustment: UIOffset,
        forSegmentType type: UISegmentedControl.Segment,
        barMetrics: UIBarMetrics = .default
    ) -> Self {
        self.setContentPositionAdjustment(adjustment, forSegmentType: type, barMetrics: barMetrics)
        return self
    }
}


