//
//  SliderExampleViewController.swift
//  ApusUI
//
//  Created by SwiftDevelop on 11/4/25.
//

import SwiftUI
import ApusUI

final class SliderExampleViewController: UIViewController {
    
    enum ColorSet: String, CaseIterable {
        case red, green, blue
        
        var tintColor: UIColor {
            switch self {
            case .red:
                return .red
            case .green:
                return .green
            case .blue:
                return .blue
            }
        }
    }
    
    private let redColorValueLabel = UILabel()
    private let greenColorValueLabel = UILabel()
    private let blueColorValueLabel = UILabel()
    private let colorView = UIView()
    
    private var red: CGFloat = 0
    private var green: CGFloat = 0
    private var blue: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.subviews {
            UIStackView(.vertical, data: ColorSet.allCases) { colorSet in
                makeColorSliderView(colorSet: colorSet)
            }
            .spacing(24)
            .padding(top: 24)
            .padding(horizontal: 16)
            
            colorView
                .frame(height: 255)
                .padding(bottom: 16)
                .padding(horizontal: 16)
        }
        
        updateUI()
    }
    
    private func makeColorSliderView(colorSet: ColorSet) -> UIStackView {
        UIStackView(.horizontal) {
            UILabel(colorSet.rawValue)
                .frame(width: 48)
            
            UISlider(action: { [weak self] value in
                let colorValue = CGFloat(value * 255)
                switch colorSet {
                case .red:
                    self?.red = colorValue
                case .green:
                    self?.green = colorValue
                case .blue:
                    self?.blue = colorValue
                }
                
                self?.updateUI()
            })
            .thumbTintColor(colorSet.tintColor)
            .minimumTrackTintColor(colorSet.tintColor)
            
            makeValueLabel(colorSet: colorSet)
                .frame(width: 40)
        }
        .spacing(16)
    }
    
    private func makeValueLabel(colorSet: ColorSet) -> UILabel {
        switch colorSet {
        case .red:
            redColorValueLabel
        case .green:
            greenColorValueLabel
        case .blue:
            blueColorValueLabel
        }
    }
    
    private func updateUI() {
        redColorValueLabel.text("\(Int(red))")
        greenColorValueLabel.text("\(Int(green))")
        blueColorValueLabel.text("\(Int(blue))")
        
        colorView.backgroundColor(.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1.0))
    }
}

#Preview {
    UIViewControllerPreview {
        SliderExampleViewController()
    }
}
