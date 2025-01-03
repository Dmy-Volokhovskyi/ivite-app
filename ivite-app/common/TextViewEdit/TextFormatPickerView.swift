//
//  TextFormatPickerView.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 30/09/2024.
//

import UIKit
import PureLayout

protocol TextFormatPickerDelegate: AnyObject {
    func textFormatPickerDidSelectFormat(_ pickerView: TextFormatPickerView, format: TextFormatting)
    func textFormatPickerDidSelectAlignment(_ pickerView: TextFormatPickerView, alignment: TextAlignment)
    func textFormatPickerDidReset(_ pickerView: TextFormatPickerView)
}

class TextFormatPickerView: BaseView {
    weak var delegate: TextFormatPickerDelegate?
    
    private let resetButton = UIButton(configuration: .secondary(title: "Reset"))
    private let closeButton = UIButton(configuration: .secondary(title: "Close"))
    private let titleLabel = UILabel()
    
    private let formattingStackView = UIStackView()
    private let alignmentStackView = UIStackView()

    private var selectedFormat: TextFormatting?
    private var selectedAlignment: TextAlignment = .left
    
    override func setupView() {
        super.setupView()

        backgroundColor = .white
        layer.cornerRadius = 10
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        setupTitleLabel()
        setupResetAndCloseButtons()
        setupFormattingButtons()
        setupAlignmentButtons()
    }

    override func addSubviews() {
        super.addSubviews()
        
        addSubview(resetButton)
        addSubview(closeButton)
        addSubview(titleLabel)
        addSubview(formattingStackView)
        addSubview(alignmentStackView)
    }

    override func constrainSubviews() {
        super.constrainSubviews()
        
        resetButton.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        resetButton.autoPinEdge(toSuperviewEdge: .top, withInset: 16)
        
        closeButton.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 16)
        closeButton.autoPinEdge(toSuperviewSafeArea: .top, withInset: 16)
        closeButton.autoMatch(.height, to: .height, of: resetButton)
        
        titleLabel.autoPinEdge(.top, to: .bottom, of: closeButton, withOffset: 16)
        titleLabel.autoPinEdge(toSuperviewEdge: .leading)
        titleLabel.autoPinEdge(toSuperviewEdge: .trailing)
        
        formattingStackView.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 16)
        formattingStackView.autoAlignAxis(toSuperviewAxis: .vertical)
        formattingStackView.autoSetDimension(.height, toSize: 40)
        
        alignmentStackView.autoPinEdge(.top, to: .bottom, of: formattingStackView, withOffset: 16)
        alignmentStackView.autoAlignAxis(toSuperviewAxis: .vertical)
        alignmentStackView.autoSetDimension(.height, toSize: 40)
    }

    // MARK: - Setup Methods
    
    private func setupTitleLabel() {
        titleLabel.text = "TEXT FORMAT"
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textAlignment = .center
    }

    private func setupResetAndCloseButtons() {
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }

    private func setupFormattingButtons() {
        formattingStackView.axis = .horizontal
        formattingStackView.spacing = 12
        formattingStackView.distribution = .fillEqually
        
        // Create buttons for text formatting (All Caps, Lowercase, Capitalized)
        let allCapsButton = createFormatButton(title: "AA")
        allCapsButton.tag = 0
        allCapsButton.addTarget(self, action: #selector(formatSelected(_:)), for: .touchUpInside)
        
        let allLowercaseButton = createFormatButton(title: "aa")
        allLowercaseButton.tag = 1
        allLowercaseButton.addTarget(self, action: #selector(formatSelected(_:)), for: .touchUpInside)
        
        let capitalizedButton = createFormatButton(title: "Aa")
        capitalizedButton.tag = 2
        capitalizedButton.addTarget(self, action: #selector(formatSelected(_:)), for: .touchUpInside)
        
        [allCapsButton, allLowercaseButton, capitalizedButton].forEach { formattingStackView.addArrangedSubview($0) }
    }

    private func setupAlignmentButtons() {
        alignmentStackView.axis = .horizontal
        alignmentStackView.spacing = 12
        alignmentStackView.distribution = .fillEqually
        
        // Create buttons for text alignment (Left, Center, Right)
        let leftAlignButton = createAlignmentButton(systemImageName: "text.alignleft")
        leftAlignButton.tag = 0
        leftAlignButton.addTarget(self, action: #selector(alignmentSelected(_:)), for: .touchUpInside)
        
        let centerAlignButton = createAlignmentButton(systemImageName: "text.aligncenter")
        centerAlignButton.tag = 1
        centerAlignButton.addTarget(self, action: #selector(alignmentSelected(_:)), for: .touchUpInside)
        
        let rightAlignButton = createAlignmentButton(systemImageName: "text.alignright")
        rightAlignButton.tag = 2
        rightAlignButton.addTarget(self, action: #selector(alignmentSelected(_:)), for: .touchUpInside)
        
        [leftAlignButton, centerAlignButton, rightAlignButton].forEach { alignmentStackView.addArrangedSubview($0) }
    }

    // MARK: - Helper Methods
    
    private func createFormatButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 8
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.widthAnchor.constraint(equalToConstant: 60).isActive = true
        return button
    }

    private func createAlignmentButton(systemImageName: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: systemImageName), for: .normal)
        button.tintColor = .black
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 20
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        return button
    }

    // MARK: - Actions
    
    @objc private func formatSelected(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            selectedFormat = .allCaps
        case 1:
            selectedFormat = .allLowercase
        case 2:
            selectedFormat = .capitalized
        default:
            return
        }
        if let format = selectedFormat {
            delegate?.textFormatPickerDidSelectFormat(self, format: format)
        }
    }
    
    @objc private func alignmentSelected(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            selectedAlignment = .left
        case 1:
            selectedAlignment = .center
        case 2:
            selectedAlignment = .right
        default:
            return
        }
        delegate?.textFormatPickerDidSelectAlignment(self, alignment: selectedAlignment)
    }
    
    @objc private func resetButtonTapped() {
        selectedFormat = nil
        selectedAlignment = .left
        delegate?.textFormatPickerDidReset(self)
    }
    
    @objc private func closeButtonTapped() {
        self.isHidden.toggle()
    }
}

