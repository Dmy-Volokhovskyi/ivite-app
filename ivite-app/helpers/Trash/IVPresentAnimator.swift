//
//  IVPresentAnimator.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 11/11/2024.
//

import UIKit

enum IVPresentationStyle {
    case modal // Default custom modal
    case bottom // Slide-up from bottom
}

class IVPresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else { return }
        
        let containerView = transitionContext.containerView
        toView.alpha = 0
        toView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        containerView.addSubview(toView)

        UIView.animate(withDuration: 0.3, animations: {
            toView.alpha = 1
            toView.transform = .identity
        }, completion: { finished in
            transitionContext.completeTransition(finished)
        })
    }
}

class IVDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from) else { return }

        UIView.animate(withDuration: 0.3, animations: {
            fromView.alpha = 0
            fromView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: { finished in
            fromView.removeFromSuperview()
            transitionContext.completeTransition(finished)
        })
    }
}
