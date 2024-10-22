//
//  UIButton+Configuration.swift
//  ivite-app
//
//  Created by GoApps Developer on 04/09/2024.
//

import UIKit

extension UIButton.Configuration {
    static func primary(title: String, image: UIImage? = nil) -> UIButton.Configuration {
        var config = UIButton.Configuration.filled()
        config.title = title
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        config.baseBackgroundColor = .accent
        config.baseForegroundColor = .primaryLight10
        config.cornerStyle = .capsule
        config.image = image
        config.imagePadding = 10
        
        var attributedTitle = AttributedString(title)
        attributedTitle.font = .interFont(ofSize: 14, weight: .semiBold)
        attributedTitle.foregroundColor = UIColor.primaryLight10
        config.imagePlacement = .trailing
        config.attributedTitle = attributedTitle
        
        return config
    }
    
    static func secondary(title: String, image: UIImage? = nil) -> UIButton.Configuration {
        var config = UIButton.Configuration.filled()
        config.title = title
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        config.baseBackgroundColor = .primaryLight10
        config.baseForegroundColor = .accent
        config.cornerStyle = .capsule
        config.image = image
        config.imagePadding = 10
        
        var attributedTitle = AttributedString(title)
        attributedTitle.font = .interFont(ofSize: 14, weight: .semiBold)
        attributedTitle.foregroundColor = UIColor.accent
        config.imagePlacement = .trailing
        config.attributedTitle = attributedTitle
        
        return config
    }
    
    static func clear(title: String, image: UIImage? = nil) -> UIButton.Configuration {
        var config = UIButton.Configuration.filled()
        config.title = title
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        config.baseBackgroundColor = .clear
        config.baseForegroundColor = .accent
        config.cornerStyle = .capsule
        config.image = image
        config.imagePadding = 10
        
        var attributedTitle = AttributedString(title)
        attributedTitle.font = .interFont(ofSize: 14, weight: .semiBold)
        attributedTitle.foregroundColor = UIColor.accent
        config.imagePlacement = .trailing
        config.attributedTitle = attributedTitle
        
        return config
    }
    
    static func image(image: UIImage, color: UIColor? = nil) -> UIButton.Configuration {
        var config = UIButton.Configuration.bordered()
        config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
        config.baseBackgroundColor = color ?? .dark10
        config.baseForegroundColor = .dark30
        config.cornerStyle = .capsule
        config.image = image
        //        config.imagePadding = 8
        
        return config
    }
    
    static func actionButton(title: String, image: UIImage? = nil) -> UIButton.Configuration {
        var config = UIButton.Configuration.filled()
        config.title = title
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        
        // Default state: clear background
        config.baseBackgroundColor = .clear
        config.baseForegroundColor = .accent // Text and image accent color
        config.cornerStyle = .capsule
        config.image = image
        config.imagePadding = 10
        
        // Align image and title to leading (left)
        config.imagePlacement = .leading // Image on the left
        config.titleAlignment = .leading // Text aligned to the left
        
        // Handle the background color transformation when the button is highlighted
        config.background.backgroundColorTransformer = UIConfigurationColorTransformer { state in
            guard let configurationState = state as? UIControl.State else { return UIColor.clear }
            return configurationState.contains(.highlighted) ? UIColor.white : UIColor.clear
        }
        
        // Change text color when pressed (highlighted)
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            if let existingColor = incoming.foregroundColor as? UIColor {
                outgoing.foregroundColor = existingColor == UIColor.accent ? UIColor.primaryLight10 : existingColor
            }
            return outgoing
        }
        
        // Attributed title styling
//        var attributedTitle = AttributedString(title)
//        attributedTitle.font = .interFont(ofSize: 14, weight: .semiBold)
//        attributedTitle.foregroundColor = UIColor.accent
//        config.attributedTitle = attributedTitle
        
        return config
    }
}
