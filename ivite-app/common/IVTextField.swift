//
//  IVTextView.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 11/10/2024.
//

import UIKit
import PureLayout

protocol IVTextFieldDelegate: AnyObject {
    func textFieldDidChange(_ textField: IVTextField)
}

final class IVTextField: BaseControll, UITextFieldDelegate {
    private let contentStackView = UIStackView()
    private var leadingImageView = UIImageView()
    private var placeholder: String = ""
    private let textField = UITextField()
    private let trailingImageView = UIImageView(image: .eyeOpen) // Replace with your asset
    
    private var validationType: TextFieldValidationType = .none
    
    weak var delegate: IVTextFieldDelegate?
    
    var secured: Bool = false {
        didSet {
            textField.isSecureTextEntry = secured
            trailingImageView.isHidden = !secured
            updateTrailingImage()
        }
    }
    
    var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    }
    
    var isValid: Bool {
        switch validationType {
        case .email:
            return validationType.isValid(textField.text)
        case .zipCode:
            return (textField.text?.count ?? 0) == 10 // Example: ZIP Code has 10 characters
        case .none:
            return !(textField.text?.isEmpty ?? true) // Valid if not empty
        }
    }
    
    // Initializer
    init(text: String? = "",
         placeholder: String = "",
         leadingImage: UIImage? = nil,
         trailingImage: UIImage? = nil,
         validationType: TextFieldValidationType = .none) {
        self.placeholder = placeholder
        self.validationType = validationType
        
        super.init(frame: .zero)
        
        leadingImageView.image = leadingImage
        leadingImageView.isHidden = leadingImage == nil
        
        trailingImageView.isUserInteractionEnabled = true // Enable interaction for the toggle
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleSecureEntry))
        trailingImageView.addGestureRecognizer(tapGesture)
        
        trailingImageView.isHidden = !secured // Initially hidden if not secure entry
        print("here")
        textField.text = text
        textField.isUserInteractionEnabled = true
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        super.setupView()
        
        layer.cornerRadius = 22
        backgroundColor = .dark20
        self.isUserInteractionEnabled = true
        self.addTarget(self, action: #selector(didTouchUpInside), for: .touchUpInside)
        
        contentStackView.axis = .horizontal
        contentStackView.spacing = 12
        
        textField.placeholder = placeholder
        textField.borderStyle = .none
        textField.isSecureTextEntry = secured
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        [
            leadingImageView,
            textField,
            trailingImageView
        ].forEach { contentStackView.addArrangedSubview($0) }
        
        addSubview(contentStackView)
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        contentStackView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20))
        
        leadingImageView.autoSetDimensions(to: CGSize(width: 20, height: 20))
        trailingImageView.autoSetDimensions(to: CGSize(width: 20, height: 20))
    }
    
    @objc private func didTouchUpInside() {
        becomeFirstResponder()
    }
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        return textField.becomeFirstResponder()
    }
    
    @discardableResult
    override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        return textField.resignFirstResponder()
    }
    
    @objc private func toggleSecureEntry() {
        textField.isSecureTextEntry.toggle()
        updateTrailingImage()// Toggle the secure text entry
    }
    
    private func updateTrailingImage() {
        DispatchQueue.main.async {
            self.trailingImageView.image = self.textField.isSecureTextEntry ? .edit : .eyeOpen
        }
    }
    
    @objc private func textFieldDidChange() {
        text = textField.text
        if validationType == .email, !validationType.isValid(textField.text) {
            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor.red.cgColor
        } else {
            self.layer.borderWidth = 0
        }
        delegate?.textFieldDidChange(self)
    }
}
