//
//  UIButton+IVEnabled.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 18/02/2025.
//

import UIKit

extension UIButton {
    // Disable the button with its current title
    func IVdisable() {
        if let currentTitle = self.title(for: .normal) {
            print(self.attributedTitle(for: .normal))
            self.configuration = .disabledPrimary(title: currentTitle)
        }
        self.isUserInteractionEnabled = false
    }
    
    // Enable the button with its current title
    func IVenable() {
        if let currentTitle = self.title(for: .normal) {
            self.configuration = .primary(title: currentTitle)
        }
        self.isUserInteractionEnabled = true
    }
    
    // Set the button state with a custom title
    func IVsetEnabled(_ enabled: Bool, title: String? = nil) {
        let effectiveTitle = title ?? self.title(for: .normal) ?? ""
        print(self.attributedTitle(for: .normal))
        if enabled {
            self.configuration = .primary(title: effectiveTitle)
        } else {
            self.configuration = .disabledPrimary(title: effectiveTitle)
        }
        self.isUserInteractionEnabled = enabled
    }
}
