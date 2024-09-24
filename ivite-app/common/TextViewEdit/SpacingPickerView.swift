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
    
    override func setupView() {
        super.setupView()
        
        backgroundColor = .white
        
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
        resetButton.autoPinEdge(toSuperviewEdge: .top, withInset: 16)
        
        closeButton.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        closeButton.autoPinEdge(toSuperviewEdge: .top, withInset: 16)
        closeButton.autoMatch(.height, to: .height, of: resetButton)
        
        titleLabel.autoPinEdge(.top, to: .bottom, of: closeButton, withOffset: 16)
        titleLabel.autoPinEdge(toSuperviewEdge: .leading)
        titleLabel.autoPinEdge(toSuperviewEdge: .trailing)
        
        segmentControl.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 16)
        segmentControl.autoAlignAxis(toSuperviewAxis: .vertical)
        
        slider.autoPinEdge(.top, to: .bottom, of: segmentControl, withOffset: 24)
        slider.autoAlignAxis(toSuperviewAxis: .vertical)
        slider.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        slider.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        
        valueLabel.autoPinEdge(.top, to: .bottom, of: slider, withOffset: 12)
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
        slider.minimumValue = 0
        slider.maximumValue = 2.0
        slider.value = Float(letterSpacing) // Default to letter spacing
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
    }

    private func setupValueLabel() {
        valueLabel.font = .systemFont(ofSize: 16)
        valueLabel.textAlignment = .center
        valueLabel.text = "\(String(format: "%.2f", letterSpacing))" // Display letter spacing by default
    }

    // MARK: - Actions
    
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        // Switch between Letter Spacing and Line Height
        if sender.selectedSegmentIndex == 0 {
            // Letter Spacing
            slider.value = Float(letterSpacing)
            valueLabel.text = "\(String(format: "%.2f", letterSpacing))"
        } else {
            // Line Height
            slider.value = Float(lineHeight)
            valueLabel.text = "\(String(format: "%.2f", lineHeight))"
        }
    }
    
    @objc private func sliderValueChanged(_ sender: UISlider) {
        let value = CGFloat(sender.value)
        
        if segmentControl.selectedSegmentIndex == 0 {
            // Update letter spacing
            letterSpacing = value
            valueLabel.text = "\(String(format: "%.2f", letterSpacing))"
            delegate?.spacingPickerDidUpdateLetterSpacing(self, letterSpacing: letterSpacing)
        } else {
            // Update line height
            lineHeight = value
            valueLabel.text = "\(String(format: "%.2f", lineHeight))"
            delegate?.spacingPickerDidUpdateLineHeight(self, lineHeight: lineHeight)
        }
    }
    
    @objc private func resetButtonTapped() {
        letterSpacing = 0.0
        lineHeight = 1.25
        slider.value = Float(letterSpacing)
        valueLabel.text = "\(String(format: "%.2f", letterSpacing))"
        segmentControl.selectedSegmentIndex = 0
        
        delegate?.spacingPickerDidReset(self)
    }
    
    @objc private func closeButtonTapped() {
        self.isHidden.toggle()
    }
}

