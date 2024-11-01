//
//  GoogleSignInButton.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 01/11/2024.
//

import UIKit

final class GoogleSignInButton: UIButton {

    init(text: String) {
        super.init(frame: .zero)
        setupConfiguration(text: text)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupConfiguration(text: "Sign in with Google") // Default text
    }

    private func setupConfiguration(text: String) {
        var configuration = UIButton.Configuration.plain()
        
        // Set the title
        configuration.title = text
        configuration.titleAlignment = .center
        configuration.baseForegroundColor = UIColor(named: "GoogleTextColor") ?? .darkGray
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.interFont(ofSize: 16, weight: .bold)
            return outgoing
        }
        
        // Set image and padding
        configuration.image = UIImage(resource: .google1)
        configuration.imagePadding = 12  // Based on guidelines
        configuration.imagePlacement = .leading

        // Set button height and width constraints according to the guidelines
        self.heightAnchor.constraint(equalToConstant: 44).isActive = true  // Button height as shown in iOS guidelines

        // Set border, rounded corners, and background color
        configuration.background.strokeColor = UIColor.dark20
        configuration.background.strokeWidth = 1
        configuration.background.cornerRadius = 22  // Rounded corners for a height of 44
        configuration.background.backgroundColor = .clear

        // Apply configuration to the button
        self.configuration = configuration

        // Update colors based on color scheme
        updateColors()
    }

    private func updateColors() {
        if traitCollection.userInterfaceStyle == .dark {
            configuration?.baseForegroundColor = .white
            configuration?.image?.withTintColor(.white)
        } else {
            configuration?.baseForegroundColor = .black
            configuration?.image?.withTintColor(.black)
        }
    }

    // Override to handle color scheme changes
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle {
            updateColors()
        }
    }
}
