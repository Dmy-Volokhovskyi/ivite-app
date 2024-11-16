//
//  IVBottomPresentAnimator.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 11/11/2024.
//

import UIKit

class IVBottomPresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else { return }
        
        let containerView = transitionContext.containerView
        
        let finalFrame = transitionContext.finalFrame(for: transitionContext.viewController(forKey: .to)!)
        toView.frame = finalFrame.offsetBy(dx: 0, dy: containerView.bounds.height)
        containerView.addSubview(toView)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toView.frame = finalFrame
        }, completion: { finished in
            transitionContext.completeTransition(finished)
        })
    }
}

class IVBottomDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from) else { return }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromView.frame = fromView.frame.offsetBy(dx: 0, dy: fromView.bounds.height)
        }, completion: { finished in
            fromView.removeFromSuperview()
            transitionContext.completeTransition(finished)
        })
    }
}
