//
//  TermsAndServicesView.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 22/10/2024.
//

import UIKit

protocol TermsOfServiceViewDelegate: AnyObject {
    func didTapTermsOfService()
    func didAgreeToTerms(_ agreed: Bool)
}

final class TermsOfServiceView: BaseView {
    
    private let checkBox = UIButton(configuration: .borderless())
    private let label = UILabel()
    
    weak var delegate: TermsOfServiceViewDelegate?
    
    override func setupView() {
        super.setupView()
        
        checkBox.setImage(UIImage(systemName: "square"), for: .normal)
        checkBox.setImage(UIImage(systemName: "checkmark.square"), for: .selected)
        checkBox.tintColor = .dark30
        checkBox.addTarget(self, action: #selector(didTapCheckbox), for: .touchUpInside)
        
        // Setup the attributed text
        let fullText = "I agree to the terms of service"
        let boldText = "terms of service"
        let attributedString = NSMutableAttributedString(string: fullText)

        // Apply base font to entire text
        let fullRange = NSRange(location: 0, length: attributedString.length)
        attributedString.addAttribute(.font, value: UIFont.interFont(ofSize: 14), range: fullRange)

        // Apply bold font to "terms of service"
        let boldRange = (fullText as NSString).range(of: boldText)
        attributedString.addAttribute(.font, value: UIFont.interFont(ofSize: 14, weight: .bold), range: boldRange)
        attributedString.addAttribute(.foregroundColor, value: UIColor.secondary1, range: boldRange)
        
        // Set the attributed string to the label
        label.attributedText = attributedString
        label.isUserInteractionEnabled = true
        
        // Add tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapLabel(_:)))
        label.addGestureRecognizer(tapGesture)
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        addSubview(checkBox)
        addSubview(label)
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        checkBox.autoPinEdge(toSuperviewEdge: .leading)
        checkBox.autoPinEdge(toSuperviewEdge: .top)
        checkBox.autoPinEdge(toSuperviewEdge: .bottom)
        checkBox.autoSetDimensions(to: CGSize(width: 24, height: 24))
        
        label.autoPinEdge(.leading, to: .trailing, of: checkBox, withOffset: 16)
        label.autoPinEdge(toSuperviewEdge: .trailing)
        label.autoAlignAxis(.horizontal, toSameAxisOf: checkBox)
    }
    
    @objc private func didTapCheckbox() {
        checkBox.isSelected.toggle()
        delegate?.didAgreeToTerms(checkBox.isSelected)
    }
    
    @objc private func didTapLabel(_ gesture: UITapGestureRecognizer) {
        let fullText = label.attributedText?.string ?? ""
        let boldText = "terms of service"
        let boldRange = (fullText as NSString).range(of: boldText)
        
        if gesture.didTapAttributedTextInLabel(label: label, inRange: boldRange) {
            delegate?.didTapTermsOfService()
        }
    }
}
