//
//  SignInView.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 22/10/2024.
//

import UIKit

protocol SignInViewDelegate: AnyObject {
    func didTapSignIn()
}

final class SignInView: BaseView {
    
    private let label = UILabel()
    weak var delegate: SignInViewDelegate?
    
    override func setupView() {
        super.setupView()
        
        // Setup the attributed text
        let fullText = "Already have an account? Sign in"
        let regularText = "Already have an account?"
        let signInText = "Sign in"
        
        let attributedString = NSMutableAttributedString(string: fullText)
        
        // Set attributes for "Already have an account?"
        let regularRange = (fullText as NSString).range(of: regularText)
        attributedString.addAttribute(.font, value: UIFont.interFont(ofSize: 14), range: regularRange)
        attributedString.addAttribute(.foregroundColor, value: UIColor.secondary1, range: regularRange) // Regular text color
        
        // Set attributes for "Sign in"
        let signInRange = (fullText as NSString).range(of: signInText)
        attributedString.addAttribute(.font, value: UIFont.interFont(ofSize: 14, weight: .bold), range: signInRange)
        attributedString.addAttribute(.foregroundColor, value: UIColor.accent, range: signInRange) // Bold text color
        
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
        let signInText = "Sign in"
        let signInRange = (fullText as NSString).range(of: signInText)
        
        if gesture.didTapAttributedTextInLabel(label: label, inRange: signInRange) {
            delegate?.didTapSignIn()
        }
    }
}
