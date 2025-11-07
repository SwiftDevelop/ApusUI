//
//  UIStackView+Extension.swift
//  ApusUI
//
//  Created by SwiftDevelop on 10/24/25.
//

import UIKit

// MARK: - Initialization
public extension UIStackView {
    /// 축, 정렬, 간격 등을 설정하여 `UIStackView`를 생성합니다.
    convenience init(
        _ axis: NSLayoutConstraint.Axis = .horizontal,
        alignment: UIStackView.Alignment = .fill,
        spacing: CGFloat = 0
    ) {
        self.init()
        self.axis = axis
        self.alignment = alignment
        self.spacing = spacing
    }
    
    /// `SubviewBuilder`를 사용하여 `arrangedSubviews`를 포함하는 `UIStackView`를 생성합니다.
    convenience init(_ axis: NSLayoutConstraint.Axis = .horizontal, spacing: CGFloat = 0, @SubviewBuilder _ builder: () -> [UIView]) {
        self.init()
        self.axis = axis
        self.spacing = spacing
        self.arrangedSubviews(builder)
    }
    
    /// `SubviewBuilder`를 사용하여 `arrangedSubviews`를 포함하는 `UIStackView`를 생성합니다.
    convenience init(_ axis: NSLayoutConstraint.Axis = .horizontal, spacing: CGFloat = 0, @SubviewBuilder _ builder: (Self) -> [UIView]) {
        self.init()
        self.axis = axis
        self.spacing = spacing
        self.arrangedSubviews(builder)
    }
    
    /// 데이터 배열을 기반으로 `arrangedSubviews`를 포함하는 `UIStackView`를 생성합니다.
    convenience init<T>(_ axis: NSLayoutConstraint.Axis = .horizontal, data: [T], @SubviewBuilder _ builder: (T) -> [UIView]) {
        self.init()
        self.axis = axis
        self.arrangedSubviews(data, builder)
    }
    
    /// 지정된 횟수만큼 빌더를 호출하여 `arrangedSubviews`를 포함하는 `UIStackView`를 생성합니다.
    convenience init(_ axis: NSLayoutConstraint.Axis = .horizontal, count: Int, @SubviewBuilder _ builder: (Int) -> [UIView]) {
        self.init()
        self.axis = axis
        self.arrangedSubviews(count, builder)
    }
}

// MARK: - ArrangedSubview
public extension UIStackView {
    /// `SubviewBuilder`를 사용하여 `arrangedSubviews`를 추가합니다.
    @discardableResult
    func arrangedSubviews(@SubviewBuilder _ builder: () -> [UIView]) -> Self {
        let views = builder()
        views.forEach { view in
            self.addArrangedSubview(view)
        }
        return self
    }
    
    /// `SubviewBuilder`를 사용하여 `arrangedSubviews`를 추가합니다.
    @discardableResult
    func arrangedSubviews(@SubviewBuilder _ builder: (Self) -> [UIView]) -> Self {
        let views = builder(self)
        views.forEach { view in
            self.addArrangedSubview(view)
        }
        return self
    }
    
    /// 데이터 배열을 기반으로 `arrangedSubviews`를 추가합니다.
    @discardableResult
    func arrangedSubviews<T>(_ data: [T], @SubviewBuilder _ builder: (T) -> [UIView]) -> Self {
        for item in data {
            let views = builder(item)
            views.forEach { view in
                self.addArrangedSubview(view)
            }
        }
        return self
    }
    
    /// 지정된 횟수만큼 빌더를 호출하여 `arrangedSubviews`를 추가합니다.
    @discardableResult
    func arrangedSubviews(_ count: Int, @SubviewBuilder _ builder: (Int) -> [UIView]) -> Self {
        for i in 0..<count {
            let views = builder(i)
            views.forEach { view in
                self.addArrangedSubview(view)
            }
        }
        return self
    }
}

// MARK: - Extensions
public extension UIStackView {
    /// 스택뷰의 축(수직/수평)을 설정합니다.
    @discardableResult
    func axis(_ axis: NSLayoutConstraint.Axis) -> Self {
        self.axis = axis
        return self
    }
    
    /// 스택뷰 내의 뷰들의 정렬 방식을 설정합니다.
    @discardableResult
    func alignment(_ alignment: UIStackView.Alignment) -> Self {
        self.alignment = alignment
        return self
    }
    
    /// 스택뷰의 축을 따라 뷰들의 분포를 설정합니다.
    @discardableResult
    func distribution(_ distribution: UIStackView.Distribution) -> Self {
        self.distribution = distribution
        return self
    }
    
    /// 스택뷰 내의 뷰들 사이의 간격을 설정합니다.
    @discardableResult
    func spacing(_ spacing: CGFloat) -> Self {
        self.spacing = spacing
        return self
    }
}
