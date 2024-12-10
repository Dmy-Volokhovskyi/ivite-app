//
//  BringListItemView.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 14/10/2024.
//

import UIKit

protocol BringListItemViewDelegate: AnyObject {
    func bringListItemViewDidTapDeleteButton(_ view: BringListItemView, for id: String)
    func didUpdateBringListItem(_ view: BringListItemView, for id: String, with model: BringListItem)
}

final class BringListItemView: BaseView, UITextFieldDelegate {
    private var model: BringListItem?
    private let containerView = UIView()
    private let titleTextField = UITextField()
    private let separatorView = UIView()
    private let countTextField = UITextField()
    private let xLabel = UILabel()
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
        countTextField.placeholder = "2"
        setPlaceholderColor(for: countTextField, color: .dark30)
        countTextField.textColor = countTextField.text?.isEmpty == false ? .secondary1 : .dark30
        countTextField.keyboardType = .decimalPad
        countTextField.addTarget(self, action: #selector(textValueChanged), for: .editingChanged)
        countTextField.delegate = self  // Set the delegate to self
        
        xLabel.text = "x"
        xLabel.textColor = countTextField.text?.isEmpty == false ? .secondary1 : .dark30
        
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
            countTextField,
            xLabel
        ].forEach({ containerView.addSubview($0) })
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        containerView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .trailing)
        containerView.setContentCompressionResistancePriority(.init(1), for: .horizontal)
        containerView.setContentHuggingPriority(.init(1), for: .horizontal)
        
        deleteButton.autoPinEdge(.leading, to: .trailing, of: containerView, withOffset: 12)
        deleteButton.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .leading)
        deleteButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        deleteButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        titleTextField.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16), excludingEdge: .trailing)
        
        titleTextField.setContentHuggingPriority(.init(1), for: .horizontal)
        titleTextField.setContentCompressionResistancePriority(.init(1), for: .horizontal)
        
        separatorView.autoPinEdge(.leading, to: .trailing, of: titleTextField)
        separatorView.autoSetDimension(.width, toSize: 2)
        separatorView.autoPinEdge(toSuperviewEdge: .top, withInset: 16)
        separatorView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 16)
        
        countTextField.autoPinEdge(.leading, to: .trailing, of: separatorView, withOffset: 6)
        countTextField.autoPinEdge(toSuperviewEdge: .top, withInset: 12)
        countTextField.autoPinEdge(toSuperviewEdge: .bottom, withInset: 12)
        
        xLabel.autoPinEdge(.leading, to: .trailing, of: countTextField)
        xLabel.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 32), excludingEdge: .leading)
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
            model?.name = sender.text
        } else  {
            countTextField.textColor = countTextField.text?.isEmpty == false ? .secondary1 : .dark30
            separatorView.backgroundColor = countTextField.text?.isEmpty == false ? .secondary1 : .dark30
            xLabel.textColor = countTextField.text?.isEmpty == false ? .secondary1 : .dark30
            model?.count = Int(sender.text ?? "")
        }
        guard let model else { return }
        delegate?.didUpdateBringListItem(self, for: model.id, with: model)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Use a regular expression to allow only numeric input
        let regex = "^[0-9]*$"
        
        // Check if the replacement string matches the regex
        let isNumber = string.range(of: regex, options: .regularExpression) != nil
        
        if !isNumber {
            return false // Block non-numeric input
        }
        
        // Generate the new text with the replacement string
        if let currentText = textField.text as NSString? {
            let newText = currentText.replacingCharacters(in: range, with: string)
            
            // Optional: Limit the text length if needed (e.g., max 10 digits)
            if newText.count > 10 {
                return false
            }
        }
        
        return true // Allow the change
    }

}
