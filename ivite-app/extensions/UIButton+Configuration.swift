//
//  UIButton+Configuration.swift
//  ivite-app
//
//  Created by GoApps Developer on 04/09/2024.
//

import UIKit

extension UIButton.Configuration {
    static func primary(title: String, image: UIImage? = nil, insets: NSDirectionalEdgeInsets? = nil) -> UIButton.Configuration {
        var config = UIButton.Configuration.filled()
        config.title = title
        config.contentInsets = insets ?? NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        config.baseBackgroundColor = .accent
        config.baseForegroundColor = .primaryLight10
        config.cornerStyle = .capsule
        config.image = image
        config.imagePadding = 10
        
        var attributedTitle = AttributedString(title)
        attributedTitle.font = .interFont(ofSize: 16, weight: .bold)
        attributedTitle.foregroundColor = UIColor.primaryLight10
        config.imagePlacement = .trailing
        config.attributedTitle = attributedTitle
        
        return config
    }
    
    static func secondary(title: String, image: UIImage? = nil) -> UIButton.Configuration {
        var config = UIButton.Configuration.filled()
        config.title = title
        config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20)
        config.baseBackgroundColor = .primaryLight20
        config.baseForegroundColor = .accent
        config.cornerStyle = .capsule
        config.image = image
        config.imagePadding = 10
        
        var attributedTitle = AttributedString(title)
        attributedTitle.font = .interFont(ofSize: 16, weight: .bold)
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
    
    static func disabledPrimary(title: String) -> UIButton.Configuration {
        var config = UIButton.Configuration.filled()
        config.title = title
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        config.baseBackgroundColor = UIColor.primaryLight30 // Gray background when disabled
        config.baseForegroundColor = UIColor.white // Light gray text when disabled
        config.cornerStyle = .capsule
        
        var attributedTitle = AttributedString(title)
        attributedTitle.font = .interFont(ofSize: 16, weight: .bold)
        attributedTitle.foregroundColor = UIColor.white
        config.attributedTitle = attributedTitle
        
        return config
    }
    
    static func transparent(title: String, image: UIImage? = nil) -> UIButton.Configuration {
        var config = UIButton.Configuration.filled()
        config.title = title
        config.contentInsets = .zero
        config.baseBackgroundColor = .clear
        config.baseForegroundColor = .secondary70
        config.cornerStyle = .capsule
        config.image = image
        config.imagePadding = 8
        
        var attributedTitle = AttributedString(title)
        attributedTitle.font = .interFont(ofSize: 12, weight: .regular)
        attributedTitle.foregroundColor = UIColor.secondary70
        config.imagePlacement = .leading
        config.attributedTitle = attributedTitle
        
        return config
    }
}
