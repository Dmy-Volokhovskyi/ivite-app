//
//  IVTextView.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 11/10/2024.
//

import UIKit
import PureLayout
final class IVTextField: BaseControll, UITextFieldDelegate {
    private var placeholder: String = ""
    private let textField = UITextField()
    private var validationType: TextFieldValidationType = .none

    var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    }
    
    // Initializer
    init(text: String? = "", placeholder: String = "", validationType: TextFieldValidationType = .none) {
        self.placeholder = placeholder
        self.validationType = validationType
        textField.text = text
        super.init(frame: .zero)
        
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
        backgroundColor = .dark10
        self.isUserInteractionEnabled = true
        self.addTarget(self, action: #selector(didTouchUpInside), for: .touchUpInside)
        
        textField.placeholder = placeholder
        textField.borderStyle = .none
    }
    
    override func addSubviews() {
        super.addSubviews()
        addSubview(textField)
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        textField.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20))
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
    
    // Restrict zip code input to valid numeric format
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard validationType == .zipCode else {
            return true // Allow regular input if not zip code validation
        }

        // Restrict input to numbers and dash
        let allowedCharacters = CharacterSet(charactersIn: "0123456789-").inverted
        let filtered = string.components(separatedBy: allowedCharacters).joined()
        
        if string != filtered {
            return false // Block invalid characters
        }
        
        // Get the current text, including the newly typed character
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string

        // Format the zip code: 12345 or 12345-6789
        if currentText.count > 10 {
            return false // Limit to 10 characters
        }
        
        if currentText.count == 6 && !currentText.contains("-") {
            textField.text = currentText.prefix(5) + "-" + currentText.suffix(1) // Insert dash after 5 digits
            return false
        }

        return true
    }

    @objc private func textFieldDidChange() {
        if validationType == .email, !validationType.isValid(textField.text) {
            textField.textColor = .red // Invalid email input
        } else {
            textField.textColor = .black // Valid input or no validation
        }
    }
}
