//
//  FloatingViewController.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 16/11/2024.
//

import UIKit

class FloatingViewController: BaseViewController {
    private let contentView = UIView()
    private var customView: UIView? // Custom view to be added to the contentView

    override func setupView() {
        super.setupView()
        
        // Configure contentView
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 16
        contentView.clipsToBounds = true
        
        // Configure background of the main view
        view.backgroundColor = .clear
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        // Add contentView to the main view
        view.addSubview(contentView)
        
        // If a custom view is provided, add it to the contentView
        if let customView = customView {
            contentView.addSubview(customView)
        }
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        // Pin contentView to the safe area of the screen
        contentView.autoPinEdgesToSuperviewSafeArea(with: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
        
        // If a custom view exists, constrain it inside the contentView
        if let customView = customView {
            customView.autoPinEdgesToSuperviewEdges()
        }
    }
    
    /// Configure the floating view with a custom UIView.
    /// - Parameter view: The custom view to display inside the contentView.
    public func configure(with view: UIView) {
        // Clear existing customView
        customView?.removeFromSuperview()
        customView = view
        
        // Add the new customView to contentView and re-constrain
        if isViewLoaded {
            contentView.addSubview(customView!)
            constrainSubviews()
        }
    }
    
    /// Dismiss the floating view controller
    @objc private func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
}

extension FloatingViewController: ContentSizeProvider {
    func contentSize(for maxHeight: CGFloat) -> CGSize {
        let targetSize = CGSize(width: view.frame.width, height: UIView.layoutFittingCompressedSize.height)
        var contentSize = view.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .defaultHigh,
            verticalFittingPriority: .defaultLow
        )
        
        // Ensure height doesn't exceed maxHeight
        contentSize.height = min(contentSize.height, maxHeight)

        // Adjust for safe area insets (e.g., home indicator)
        if view.safeAreaInsets.bottom != .zero {
            contentSize.height -= view.safeAreaInsets.bottom
        }
        
        return contentSize
    }
}
