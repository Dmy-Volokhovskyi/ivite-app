//
//  IVPresentationController.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 11/11/2024.
//

import UIKit

class IVPresentationController: UIPresentationController {
    private let dimmingView = UIView()
    private let maxHeight: CGFloat = 600 // Set a reasonable max height

    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }
        
        dimmingView.frame = containerView.bounds
        dimmingView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        dimmingView.alpha = 0
        containerView.addSubview(dimmingView)

        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1
        })
    }

    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        
        guard let presentedView = presentedView, let containerView = containerView else { return }
        
        var preferredContentSize = presentedView.intrinsicContentSize
        if let contentSizeProvider = presentedViewController as? ContentSizeProvider {
            preferredContentSize = contentSizeProvider.contentSize(for: maxHeight)
        }

        let preferredWidth = containerView.bounds.width - 40
        let yPosition = containerView.bounds.height - preferredContentSize.height - 20

        presentedView.frame = CGRect(
            x: 20,
            y: yPosition,
            width: preferredWidth,
            height: preferredContentSize.height
        )

        dimmingView.frame = containerView.bounds
    }

    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0
        })
    }
}

