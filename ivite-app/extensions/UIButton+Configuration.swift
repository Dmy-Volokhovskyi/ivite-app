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
        config.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 24, bottom: 14, trailing: 24)
        config.baseBackgroundColor = .accent
        config.baseForegroundColor = .primaryLight10
        config.cornerStyle = .medium
        config.image = image
        config.imagePadding = 8
        config.buttonSize = .large
        
        return config
    }
    
    static func secondary(title: String, image: UIImage? = nil) -> UIButton.Configuration {
        var config = UIButton.Configuration.filled()
        config.title = title
        config.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 24, bottom: 14, trailing: 24)
        config.baseBackgroundColor = .systemBlue
        config.baseForegroundColor = .white
        config.cornerStyle = .medium
        config.image = image
        config.imagePadding = 8
        config.buttonSize = .large
        
        return config
    }

    static func image(image: UIImage) -> UIButton.Configuration {
        var config = UIButton.Configuration.bordered()
        config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
        config.baseBackgroundColor = .systemGray5
        config.baseForegroundColor = .systemBlue
        config.cornerStyle = .medium
        config.image = image
        config.imagePadding = 8
        
        return config
    }
}
