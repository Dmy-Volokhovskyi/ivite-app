//
//  SpacingPickerView.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 07/10/2024.
//

import UIKit
import PureLayout

protocol SpacingPickerDelegate: AnyObject {
    func spacingPickerDidUpdateLetterSpacing(_ pickerView: SpacingPickerView, letterSpacing: CGFloat)
    func spacingPickerDidUpdateLineHeight(_ pickerView: SpacingPickerView, lineHeight: CGFloat)
    func spacingPickerDidReset(_ pickerView: SpacingPickerView)
}

class SpacingPickerView: BaseView {
    weak var delegate: SpacingPickerDelegate?
    
    private let resetButton = UIButton(configuration: .secondary(title: "Reset"))
    private let closeButton = UIButton(configuration: .secondary(title: "Close"))
    private let titleLabel = UILabel()
    
    private let segmentControl = UISegmentedControl(items: ["Letter Spacing", "Line Height"])
    private let slider = UISlider()
    private let valueLabel = UILabel()
    
    // Variables to hold current values for letter spacing and line height
    private var letterSpacing: CGFloat = 0.0
    private var lineHeight: CGFloat = 1.25
    
    // We’ll use a base font size to calculate default line height
    // (You may change font size or even expose this via init if desired)
    private lazy var defaultLineHeight: CGFloat = {
        return UIFont.systemFont(ofSize: 16).lineHeight
    }()
    
    override func setupView() {
        super.setupView()
        
        backgroundColor = .white
        layer.cornerRadius = 10
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        setupTitleLabel()
        setupResetAndCloseButtons()
        setupSegmentControl()
        setupSlider()
        setupValueLabel()
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        addSubview(resetButton)
        addSubview(closeButton)
        addSubview(titleLabel)
        addSubview(segmentControl)
        addSubview(slider)
        addSubview(valueLabel)
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        resetButton.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        // Pin to safe area at the top so it doesn’t overlap with any status bar or notch
        resetButton.autoPinEdge(toSuperviewSafeArea: .top, withInset: 16)
        
        closeButton.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        closeButton.autoAlignAxis(.horizontal, toSameAxisOf: resetButton)
        closeButton.autoMatch(.height, to: .height, of: resetButton)
        
        titleLabel.autoPinEdge(.top, to: .bottom, of: resetButton, withOffset: 16)
        titleLabel.autoPinEdge(toSuperviewEdge: .leading)
        titleLabel.autoPinEdge(toSuperviewEdge: .trailing)
        
        segmentControl.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 16)
        segmentControl.autoAlignAxis(toSuperviewAxis: .vertical)
        
        slider.autoPinEdge(.top, to: .bottom, of: segmentControl, withOffset: 24)
        slider.autoAlignAxis(toSuperviewAxis: .vertical)
        slider.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        slider.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        
        valueLabel.autoPinEdge(.top, to: .bottom, of: slider, withOffset: 12)
        // IMPORTANT: Pin the bottom label to the *safe area* instead of the superview bottom
        valueLabel.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 16)
        valueLabel.autoAlignAxis(toSuperviewAxis: .vertical)
    }
    
    // MARK: - Setup Methods
    
    private func setupTitleLabel() {
        titleLabel.text = "SPACING"
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textAlignment = .center
    }
    
    private func setupResetAndCloseButtons() {
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    private func setupSegmentControl() {
        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
    }
    
    private func setupSlider() {
        // Initially, it’s showing letter spacing
        slider.minimumValue = 0
        slider.maximumValue = 2.0
        slider.value = Float(letterSpacing)
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
    }
    
    private func setupValueLabel() {
        valueLabel.font = .systemFont(ofSize: 16)
        valueLabel.textAlignment = .center
        valueLabel.text = String(format: "%.2f", letterSpacing)
    }
    
    // MARK: - Actions
    
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            // Letter Spacing
            slider.minimumValue = 0
            slider.maximumValue = 2.0
            slider.value = Float(letterSpacing)
            valueLabel.text = String(format: "%.2f", letterSpacing)
        } else {
            // Line Height
            // Use the font's default line height minus/plus an offset
            slider.minimumValue = Float(defaultLineHeight - 10)
            slider.maximumValue = Float(defaultLineHeight + 30)
            // Convert your current lineHeight ratio to an absolute value, if desired
            // OR if your lineHeight is already an absolute value, just use it
            slider.value = Float(lineHeight)
            valueLabel.text = String(format: "%.2f", lineHeight)
        }
    }
    
    @objc private func sliderValueChanged(_ sender: UISlider) {
        let value = CGFloat(sender.value)
        
        if segmentControl.selectedSegmentIndex == 0 {
            // Update letter spacing
            letterSpacing = value
            valueLabel.text = String(format: "%.2f", letterSpacing)
            delegate?.spacingPickerDidUpdateLetterSpacing(self, letterSpacing: letterSpacing)
        } else {
            // Update line height
            lineHeight = value
            valueLabel.text = String(format: "%.2f", lineHeight)
            delegate?.spacingPickerDidUpdateLineHeight(self, lineHeight: lineHeight)
        }
    }
    
    @objc private func resetButtonTapped() {
        letterSpacing = 0.0
        lineHeight = 1.25
        
        // Also reset slider/segment to letter spacing (index = 0)
        segmentControl.selectedSegmentIndex = 0
        slider.minimumValue = 0
        slider.maximumValue = 2.0
        slider.value = Float(letterSpacing)
        valueLabel.text = String(format: "%.2f", letterSpacing)
        
        delegate?.spacingPickerDidReset(self)
    }
    
    @objc private func closeButtonTapped() {
        self.isHidden.toggle()
    }
}
