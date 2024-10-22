//
//  BringListItemView.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 14/10/2024.
//

import UIKit

protocol BringListItemViewDelegate: AnyObject {
    func bringListItemViewDidTapDeleteButton(_ view: BringListItemView, for id: String)
}

final class BringListItemView: BaseView, UITextFieldDelegate {
    private let model: BringListItem?
    private let containerView = UIView()
    private let titleTextField = UITextField()
    private let separatorView = UIView()
    private let countTextField = UITextField()
    private let deleteButton = UIButton()
    
    weak var delegate: BringListItemViewDelegate?
    
    init(model: BringListItem?) {
        self.model = model
        super.init(frame: .zero)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        super.setupView()
        
        containerView.backgroundColor = .dark10
        containerView.layer.cornerRadius = 25
        
        // Setup titleLabel placeholder and text
        titleTextField.text = model?.name
        titleTextField.placeholder = "ex: Flowers"
        setPlaceholderColor(for: titleTextField, color: .dark30)
        titleTextField.textColor = titleTextField.text?.isEmpty == false ? .secondary1 : .dark30
        titleTextField.addTarget(self, action: #selector(textValueChanged), for: .editingChanged)
        
        // Setup separator view
        separatorView.backgroundColor = titleTextField.text?.isEmpty == false ? .secondary1 : .dark30
        
        if let text = model?.count {
            countTextField.text = String(text)
        }
        countTextField.placeholder = "2x"
        setPlaceholderColor(for: countTextField, color: .dark30)
        countTextField.textColor = countTextField.text?.isEmpty == false ? .secondary1 : .dark30
        countTextField.keyboardType = .decimalPad
        countTextField.addTarget(self, action: #selector(textValueChanged), for: .editingChanged)
        countTextField.delegate = self  // Set the delegate to self
        
        deleteButton.setImage(.close, for: .normal)
        deleteButton.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        [
            containerView,
            deleteButton
        ].forEach(addSubview)
        
        [
            titleTextField,
            separatorView,
            countTextField
        ].forEach({ containerView.addSubview($0) })
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        containerView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .trailing)
        
        deleteButton.autoPinEdge(.leading, to: .trailing, of: containerView, withOffset: 12)
        deleteButton.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .leading)
        
        titleTextField.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16), excludingEdge: .trailing)
        
        separatorView.autoPinEdge(.leading, to: .trailing, of: titleTextField)
        separatorView.autoSetDimension(.width, toSize: 2)
        separatorView.autoPinEdge(toSuperviewEdge: .top, withInset: 16)
        separatorView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 16)
        
        countTextField.autoPinEdge(.leading, to: .trailing, of: separatorView, withOffset: 8)
        countTextField.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16), excludingEdge: .leading)
    }
    
    // Helper function to set placeholder color
    private func setPlaceholderColor(for textField: UITextField, color: UIColor) {
        if let placeholder = textField.placeholder {
            textField.attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [NSAttributedString.Key.foregroundColor: color]
            )
        }
    }
    
    @objc private func didTapDeleteButton(_ sender: UIButton) {
        guard let id = model?.id else { return }
        
        delegate?.bringListItemViewDidTapDeleteButton(self, for: id)
    }
    
    @objc func textValueChanged(_ sender: UITextField) {
        if sender == titleTextField {
            titleTextField.textColor = titleTextField.text?.isEmpty == false ? .secondary1 : .dark30
        } else  {
            countTextField.textColor = countTextField.text?.isEmpty == false ? .secondary1 : .dark30
            separatorView.backgroundColor = countTextField.text?.isEmpty == false ? .secondary1 : .dark30
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    #warning("Bug here put cursor behing x and it crashes.")
        // Get the current text without "x" for manipulation
        var currentTextWithoutX = textField.text?.replacingOccurrences(of: "x", with: "") ?? ""
        
        // Handle delete (backspace) by checking if the delete range includes the "x"
        if string.isEmpty {
            // Check if the user is trying to delete the "x"
            if range.location >= currentTextWithoutX.count {
                return false // Prevent deletion of "x"
            }
        }
        
        // Allow only numeric input
        let allowedCharacters = CharacterSet.decimalDigits.inverted
        let filtered = string.components(separatedBy: allowedCharacters).joined()
        
        if string != filtered {
            return false // Block invalid characters
        }
        
        // Generate the new text, including the replacement string
        let newText = (currentTextWithoutX as NSString).replacingCharacters(in: range, with: string)
        
        // If the numeric part becomes empty, set the text field to be empty
        if newText.isEmpty {
            textField.text = ""
            return false
        }
        
        // Ensure the length of the numeric part does not exceed your desired limit (optional)
        if newText.count > 10 { // Limit to 10 digits or whatever your limit is
            return false
        }
        
        // Set the updated text with "x" appended
        textField.text = "\(newText)x"
        
        // Set the cursor position before the "x"
        if let newPosition = textField.position(from: textField.beginningOfDocument, offset: newText.count) {
            textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
        }

        return false // Return false because we manually update the text
    }
}
