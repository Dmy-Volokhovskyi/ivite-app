//
//  IVTextView.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 12/10/2024.
//

import UIKit
import PureLayout

protocol IVTextViewdDelegate: AnyObject {
    func textViewdDidChange(_ textView: IVTextView)
}

final class IVTextView: BaseControll, UITextViewDelegate {
    private var placeholder: String = ""
    private let textView = UITextView()
    private let placeholderLabel = UILabel()
    
    var text: String? {
        get { textView.text }
        set { textView.text = newValue }
    }

    weak var delegate: IVTextViewdDelegate?
    // Initializer
    init(text: String? = "", placeholder: String = "") {
        self.placeholder = placeholder
        textView.text = text
        super.init(frame: .zero)
        
        textView.isUserInteractionEnabled = true // Interactive text view
        setupView()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Setup the view with placeholder functionality
    override func setupView() {
        super.setupView()
        
        layer.cornerRadius = 16
        backgroundColor = .lightGray.withAlphaComponent(0.1) // Initial background color
        
        // Configure text view
        textView.delegate = self
        textView.backgroundColor = .clear
        textView.font = .interFont(ofSize: 16, weight: .regular)
        textView.textColor = .secondary1
        
        // Configure placeholder label
        placeholderLabel.text = placeholder
        placeholderLabel.textColor = .lightGray
        placeholderLabel.font = textView.font
        placeholderLabel.numberOfLines = 0
        placeholderLabel.isHidden = !textView.text.isEmpty // Hide if text exists
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        addSubview(textView)
        addSubview(placeholderLabel)
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        // Pin text view to the edges of the view
        textView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20))
        
        // Pin placeholder label to the same insets as the text view
        placeholderLabel.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 12, left: 25, bottom: 12, right: 20), excludingEdge: .bottom)
    }

    // UITextViewDelegate methods to show/hide the placeholder
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = true // Hide the placeholder when editing begins
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty // Show placeholder if text is empty after editing
    }

    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        delegate?.textViewdDidChange(self)
    }

    // Make the text view become first responder
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        return textView.becomeFirstResponder()
    }
    
    @discardableResult
    override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        return textView.resignFirstResponder()
    }
}
