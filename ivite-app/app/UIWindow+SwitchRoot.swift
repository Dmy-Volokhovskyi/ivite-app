//
//  UIWindow+SwitchRoot.swift
//  ivite-app
//
//  Created by GoApps Developer on 01/09/2024.
//

import UIKit

extension UIWindow {
    func changeRootViewController(to viewController: UIViewController, animated: Bool = true, duration: TimeInterval = 0.3, options: UIView.AnimationOptions = .transitionCrossDissolve, completion: (() -> Void)? = nil) {
        if animated {
            UIView.transition(with: self, duration: duration, options: options, animations: {
                self.rootViewController = viewController
            }, completion: { _ in
                completion?()
            })
        } else {
            self.rootViewController = viewController
            completion?()
        }

        makeKeyAndVisible()
    }
}
