//
//  SignInView.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 22/10/2024.
//

import UIKit

protocol ClickableTextViewDelegate: AnyObject {
    func didTapClickableText()
}

final class ClickableTextView: BaseView {
    private let label = UILabel()
    private var clickableText: String
    private var fullText: String
    weak var delegate: ClickableTextViewDelegate?
    
    init(fullText: String, clickableText: String) {
        self.fullText = fullText
        self.clickableText = clickableText
        super.init(frame: .zero)
        setupView()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        super.setupView()
        
        let attributedString = NSMutableAttributedString(string: fullText)
        
        // Set attributes for regular text
        let regularRange = (fullText as NSString).range(of: fullText)
        attributedString.addAttribute(.font, value: UIFont.interFont(ofSize: 14), range: regularRange)
        attributedString.addAttribute(.foregroundColor, value: UIColor.secondary1, range: regularRange) // Regular text color
        
        // Set attributes for clickable text
        let clickableRange = (fullText as NSString).range(of: clickableText)
        attributedString.addAttribute(.font, value: UIFont.interFont(ofSize: 14, weight: .bold), range: clickableRange)
        attributedString.addAttribute(.foregroundColor, value: UIColor.accent, range: clickableRange) // Clickable text color
        
        label.attributedText = attributedString
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        
        // Add tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapLabel(_:)))
        label.addGestureRecognizer(tapGesture)
    }
    
    override func addSubviews() {
        super.addSubviews()
        addSubview(label)
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        label.autoPinEdgesToSuperviewEdges()
    }
    
    @objc private func didTapLabel(_ gesture: UITapGestureRecognizer) {
        let fullText = label.attributedText?.string ?? ""
        let clickableRange = (fullText as NSString).range(of: clickableText)
        
        if gesture.didTapAttributedTextInLabel(label: label, inRange: clickableRange) {
            delegate?.didTapClickableText()
        }
    }
}
