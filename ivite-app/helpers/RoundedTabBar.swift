//
//  RoundedTabBar.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 02/12/2024.
//

import UIKit

final class RoundedTabBar: UITabBar {
    private let customBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.tabBarBackground
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1.0 // Add border width
        view.layer.borderColor = UIColor.dark20.cgColor
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCustomBackground()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCustomBackground()
    }

    private func setupCustomBackground() {
        addSubview(customBackgroundView)
        sendSubviewToBack(customBackgroundView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Adjust the custom background's frame to stretch to the screen edges
        let height = bounds.height + 16 // Extra height for the rounded effect
        let yOffset = bounds.minY - 8   // Slightly elevated for the rounded top
        customBackgroundView.frame = CGRect(
            x: bounds.minX,             // No inset for the left edge
            y: yOffset,
            width: bounds.width,        // Full width of the screen
            height: height
        )
        customBackgroundView.applySketchShadow(color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.05), valueX: 0, valueY: -1, spread: 0, cornerRadius: 16)
        
        // Adjust tab bar item positioning
        for subview in subviews where NSStringFromClass(type(of: subview)) == "UITabBarButton" {
            subview.frame.origin.y = 8  // Slightly lower the tab bar buttons
        }
    }
}
