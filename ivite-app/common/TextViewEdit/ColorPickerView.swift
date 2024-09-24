//
//  ColorPickerView.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 30/09/2024.
//
import UIKit
import PureLayout

protocol ColorPickerDelegate: AnyObject {
    func colorPickerDidSelectColor(_ pickerView: ColorPickerView, color: String)
    func colorPickerDidReset(_ pickerView: ColorPickerView)
}

class ColorPickerView: BaseView {
    weak var delegate: ColorPickerDelegate?
    
    private let resetButton = UIButton(configuration: .secondary(title: "Reset"))
    private let closeButton = UIButton(configuration: .secondary(title: "Close"))
    private let titleLabel = UILabel()
    
    // Define color options as hex strings
    private let colorOptions: [(color: UIColor, hex: String)] = [
        (.systemRed, "#FF3B30"),
        (.systemYellow, "#FFCC00"),
        (.systemGreen, "#34C759"),
        (.systemBlue, "#007AFF"),
        (.systemPink, "#FF2D55"),
        (.systemPurple, "#AF52DE"),
        (.systemTeal, "#5AC8FA"),
        (.systemGray, "#8E8E93")
    ]
    
    private let colorStackView = UIStackView()
    
    private var selectedColor: String?

    override func setupView() {
        super.setupView()

        backgroundColor = .white
        
        setupTitleLabel()
        setupResetAndCloseButtons()
        setupColorStackView()
    }

    override func addSubviews() {
        super.addSubviews()
        
        addSubview(resetButton)
        addSubview(closeButton)
        addSubview(titleLabel)
        addSubview(colorStackView)
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
        
        colorStackView.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 16)
        colorStackView.autoAlignAxis(toSuperviewAxis: .vertical)
        colorStackView.autoSetDimension(.height, toSize: 40)
    }

    // MARK: - Setup Methods
    
    private func setupTitleLabel() {
        titleLabel.text = "COLOR"
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textAlignment = .center
    }

    private func setupResetAndCloseButtons() {
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }

    private func setupColorStackView() {
        colorStackView.axis = .horizontal
        colorStackView.spacing = 12
        colorStackView.distribution = .fillEqually
        
        // Add custom color button
        let customColorButton = createColorButton(withImage: UIImage(systemName: "plus.circle.fill"), tintColor: .systemRed)
        customColorButton.addTarget(self, action: #selector(customColorSelected), for: .touchUpInside)
        colorStackView.addArrangedSubview(customColorButton)

        // Add preset color buttons
        colorOptions.forEach { colorOption in
            let colorButton = createColorButton(withColor: colorOption.color)
            colorButton.tag = colorOptions.firstIndex(where: { $0.hex == colorOption.hex }) ?? 0 // Tag for identifying the hex value
            colorButton.addTarget(self, action: #selector(colorSelected(_:)), for: .touchUpInside)
            colorStackView.addArrangedSubview(colorButton)
        }
    }

    // MARK: - Helper Methods
    
    private func createColorButton(withColor color: UIColor) -> UIButton {
        let button = UIButton()
        button.backgroundColor = color
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        return button
    }

    private func createColorButton(withImage image: UIImage?, tintColor: UIColor) -> UIButton {
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.tintColor = tintColor
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        return button
    }

    // MARK: - Actions
    
    @objc private func colorSelected(_ sender: UIButton) {
        let selectedColorHex = colorOptions[sender.tag].hex
        selectedColor = selectedColorHex
        delegate?.colorPickerDidSelectColor(self, color: selectedColorHex)
    }
    
    @objc private func customColorSelected() {
        print("Custom color picker selected")
        // Handle custom color selection logic (e.g., opening a color picker)
    }
    
    @objc private func resetButtonTapped() {
        selectedColor = nil
        delegate?.colorPickerDidReset(self)
    }
    
    @objc private func closeButtonTapped() {
        self.isHidden.toggle()
    }
}

