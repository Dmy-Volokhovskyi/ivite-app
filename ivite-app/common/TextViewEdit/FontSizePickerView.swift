//
//  FontSizePickerView.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 30/09/2024.
//

import UIKit
import PureLayout

protocol FontSizePickerDelegate: AnyObject {
    func fontSizePickerDidSelectFontSize(_ pickerView: FontSizePickerView, fontSize: CGFloat)
    func fontSizePickerDidReset(_ pickerView: FontSizePickerView)
}

class FontSizePickerView: BaseView {
    weak var delegate: FontSizePickerDelegate?

    private let resetButton = UIButton(configuration: .secondary(title: "Reset"))
    private let titleLabel = UILabel()
    private let slider = UISlider()
    private let fontSizeLabel = UILabel()
    private let closeButton = UIButton(configuration: .secondary(title: "Close"))
    
    private var currentFontSize: CGFloat = 70.0 {
        didSet {
            fontSizeLabel.text = "\(Int(currentFontSize)) pt"
        }
    }

    override func setupView() {
        super.setupView()
        
        backgroundColor = .white
        layer.cornerRadius = 10
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        titleLabel.text = "FONT SIZE"
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textAlignment = .center
        
        fontSizeLabel.text = "\(Int(currentFontSize)) pt"
        fontSizeLabel.font = .systemFont(ofSize: 16)
        fontSizeLabel.textAlignment = .center
        
        slider.minimumValue = 10
        slider.maximumValue = 100
        slider.value = Float(currentFontSize)
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }

    override func addSubviews() {
        super.addSubviews()
        
        addSubview(resetButton)
        addSubview(titleLabel)
        addSubview(slider)
        addSubview(fontSizeLabel)
        addSubview(closeButton)
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
        
        slider.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 16)
        slider.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        slider.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        
        fontSizeLabel.autoPinEdge(.top, to: .bottom, of: slider, withOffset: 8)
        fontSizeLabel.autoPinEdge(toSuperviewEdge: .leading)
        fontSizeLabel.autoPinEdge(toSuperviewEdge: .trailing)
    }
    
    func setCurrentFontSize(_ fontSize: CGFloat) {
        slider.value = Float(fontSize)
        fontSizeLabel.text = "\(Int(fontSize)) pt"
    }
    
    // MARK: - Actions
    
    @objc private func sliderValueChanged(_ sender: UISlider) {
        currentFontSize = CGFloat(sender.value)
        delegate?.fontSizePickerDidSelectFontSize(self, fontSize: currentFontSize)
    }
    
    @objc private func resetButtonTapped() {
        currentFontSize = 70.0
        slider.value = Float(currentFontSize)
        fontSizeLabel.text = "\(Int(currentFontSize)) pt"
        delegate?.fontSizePickerDidReset(self)
    }
    
    @objc private func closeButtonTapped() {
        // Handle close action (hide or remove the picker view)
        self.isHidden.toggle() // Example: Removing the view when closed
    }
}
