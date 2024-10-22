//
//  IVHeaderView.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 11/10/2024.
//

import UIKit

final class IVHeaderLabel: UILabel {
    
    init(text: String) {
        super.init(frame: .zero)
        self.text = text
        setupStyle()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupStyle()
    }
    
    private func setupStyle() {
        self.textColor = .secondary1
        self.font = .interFont(ofSize: 24, weight: .semiBold)
        self.numberOfLines = 1
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = 0.5
        self.letterSpacing = -0.72 // Apply letter spacing extension below
    }
}

// Extension to handle letter spacing (kerning)
extension UILabel {
    var letterSpacing: CGFloat {
        get {
            let spacing = self.attributedText?.attribute(.kern, at: 0, effectiveRange: nil) as? CGFloat
            return spacing ?? 0
        }
        set {
            let attributedString: NSMutableAttributedString
            if let existingText = self.attributedText {
                attributedString = NSMutableAttributedString(attributedString: existingText)
            } else {
                attributedString = NSMutableAttributedString(string: self.text ?? "")
            }
            attributedString.addAttribute(.kern, value: newValue, range: NSRange(location: 0, length: attributedString.length))
            self.attributedText = attributedString
        }
    }
}
