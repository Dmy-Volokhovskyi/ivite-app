//
//  FloatingViewController.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 16/11/2024.
//

import UIKit

protocol PreferredContentSizeUpdatable: AnyObject {
    func updatePreferredContentSize()
}

final class FloatingViewController: BaseViewController, PreferredContentSizeUpdatable {
    private let contentView = UIView()
    private var customView: UIView?
    
    override func setupView() {
        super.setupView()
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 16
        contentView.clipsToBounds = true
        view.backgroundColor = .clear
    }
    
    override func addSubviews() {
        super.addSubviews()
        view.addSubview(contentView)
        if let customView = customView {
            contentView.addSubview(customView)
        }
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        contentView.autoPinEdgesToSuperviewSafeArea(with: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
        if let customView = customView {
            customView.autoPinEdgesToSuperviewEdges()
        }
    }
    
    public func configure(with view: UIView) {
        customView?.removeFromSuperview()
        customView = view
        
        if var customViewWithDelegate = customView as? PreferredContentSizeUpdatable {
            customViewWithDelegate = self
        }
        
        if isViewLoaded {
            contentView.addSubview(customView!)
            constrainSubviews()
            updatePreferredContentSize()
        }
    }
    
    internal func updatePreferredContentSize() {
        guard let customView = customView else { return }
        let targetSize = CGSize(width: view.frame.width, height: UIView.layoutFittingCompressedSize.height)
        let fittingSize = customView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .defaultHigh,
            verticalFittingPriority: .fittingSizeLevel
        )
        preferredContentSize = CGSize(width: targetSize.width, height: fittingSize.height)
    }
    
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
