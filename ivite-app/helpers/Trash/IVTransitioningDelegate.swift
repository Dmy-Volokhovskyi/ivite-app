//
//  IVTransitioningDelegate.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 11/11/2024.
//

import UIKit

class IVTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    private let presentationStyle: IVPresentationStyle

    init(presentationStyle: IVPresentationStyle) {
        self.presentationStyle = presentationStyle
        super.init()
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return IVPresentationController(presentedViewController: presented, presenting: presenting)
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch presentationStyle {
        case .modal:
            return IVPresentAnimator()
        case .bottom:
            return IVBottomPresentAnimator()
        }
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch presentationStyle {
        case .modal:
            return IVDismissAnimator()
        case .bottom:
            return IVBottomDismissAnimator()
        }
    }
}
