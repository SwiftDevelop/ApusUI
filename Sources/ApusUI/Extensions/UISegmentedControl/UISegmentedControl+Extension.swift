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
    /// 세그먼트 아이템과 액션을 사용하여 `UISegmentedControl`을 생성합니다.
    /// - Parameters:
    ///   - items: 세그먼트에 표시될 객체들의 배열입니다. (e.g., String, UIImage)
    ///   - action: 세그먼트 선택이 변경될 때 호출될 클로저입니다.
    convenience init(items: [Any]?, action: @escaping (Int) -> Void) {
        self.init(items: items)
        self.onChange(action)
    }
}

// MARK: - Extension
public extension UISegmentedControl {
    /// 세그먼트 선택이 변경될 때 호출될 액션을 등록합니다.
    /// - Parameter action: 선택된 세그먼트의 인덱스를 파라미터로 받는 클로저입니다.
    @discardableResult
    func onChange(_ action: @escaping (Int) -> Void) -> Self {
        let wrapper = ActionWrapper(action: action, control: self)
        objc_setAssociatedObject(self, &AssociatedKey.segmentAction, wrapper, .OBJC_ASSOCIATION_RETAIN)
        self.addTarget(wrapper, action: #selector(ActionWrapper.invoke), for: .valueChanged)
        return self
    }
    
    /// 세그먼트를 탭했을 때 순간적으로 선택 상태가 되었다가 해제될지 여부를 설정합니다.
    @discardableResult
    func isMomentary(_ isMomentary: Bool) -> Self {
        self.isMomentary = isMomentary
        return self
    }
    
    /// 콘텐츠 너비에 따라 세그먼트 너비를 비례적으로 조절할지 여부를 설정합니다.
    @discardableResult
    func apportionsSegmentWidthsByContent(_ apportions: Bool) -> Self {
        self.apportionsSegmentWidthsByContent = apportions
        return self
    }
    
    /// 선택된 세그먼트의 인덱스를 설정합니다.
    @discardableResult
    func selectedSegmentIndex(_ index: Int) -> Self {
        self.selectedSegmentIndex = index
        
        if let wrapper = objc_getAssociatedObject(self, &AssociatedKey.segmentAction) as? ActionWrapper {
            wrapper.invoke()
        }
        return self
    }
    
    /// 선택된 세그먼트의 틴트 색상을 설정합니다.
    @discardableResult
    func selectedSegmentTintColor(_ color: UIColor?) -> Self {
        self.selectedSegmentTintColor = color
        return self
    }
    
    /// 특정 위치에 제목을 가진 세그먼트를 삽입합니다.
    @discardableResult
    func insert(title: String?, at index: Int, animated: Bool = false) -> Self {
        self.insertSegment(withTitle: title, at: index, animated: animated)
        return self
    }
    
    /// 특정 위치에 이미지를 가진 세그먼트를 삽입합니다.
    @discardableResult
    func insert(image: UIImage?, at index: Int, animated: Bool = false) -> Self {
        self.insertSegment(with: image, at: index, animated: animated)
        return self
    }
    
    /// 특정 위치의 세그먼트를 제거합니다.
    @discardableResult
    func remove(at index: Int, animated: Bool = false) -> Self {
        self.removeSegment(at: index, animated: animated)
        return self
    }
    
    /// 모든 세그먼트를 제거합니다.
    @discardableResult
    func removeAll() -> Self {
        self.removeAllSegments()
        return self
    }
    
    /// 특정 세그먼트의 제목을 설정합니다.
    @discardableResult
    func title(_ title: String?, at index: Int) -> Self {
        self.setTitle(title, forSegmentAt: index)
        return self
    }
    
    /// 특정 상태에 대한 제목의 텍스트 속성을 설정합니다.
    @discardableResult
    func title(_ attributes: [NSAttributedString.Key: Any]?, for state: UIControl.State) -> Self {
        self.setTitleTextAttributes(attributes, for: state)
        return self
    }
    
    /// 특정 세그먼트의 이미지를 설정합니다.
    @discardableResult
    func image(_ image: UIImage?, at index: Int) -> Self {
        self.setImage(image, forSegmentAt: index)
        return self
    }
    
    /// 특정 세그먼트의 너비를 설정합니다.
    @discardableResult
    func width(_ width: CGFloat, at index: Int) -> Self {
        self.setWidth(width, forSegmentAt: index)
        return self
    }
    
    /// 특정 세그먼트의 콘텐츠 오프셋을 설정합니다.
    @discardableResult
    func contentOffset(_ offset: CGSize, at index: Int) -> Self {
        self.setContentOffset(offset, forSegmentAt: index)
        return self
    }
    
    /// 특정 세그먼트의 활성화 상태를 설정합니다.
    @discardableResult
    func isEnabled(_ enabled: Bool, at index: Int) -> Self {
        self.setEnabled(enabled, forSegmentAt: index)
        return self
    }
    
    /// 특정 상태에 대한 배경 이미지를 설정합니다.
    @discardableResult
    func backgroundImage(
        _ image: UIImage?,
        for state: UIControl.State,
        barMetrics: UIBarMetrics = .default
    ) -> Self {
        self.setBackgroundImage(image, for: state, barMetrics: barMetrics)
        return self
    }
    
    /// 세그먼트 사이에 표시될 구분선 이미지를 설정합니다.
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
    
    /// 세그먼트 타입과 바 메트릭스에 따른 콘텐츠 위치 조정을 설정합니다.
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


