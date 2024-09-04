//
//  BaseRouter.swift
//  ivite-app
//
//  Created by GoApps Developer on 01/09/2024.
//

import UIKit

class BaseRouter {
    weak var controller: UIViewController?
    
    func dismiss(completion: (() -> Void)?) {
        controller?.dismiss(animated: true, completion: completion)
    }
    
    func changeRoot(to viewController: UIViewController) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.changeRootViewController(to: viewController, animated: true, duration: 0.2, options: [], completion: { })
        }
//
//        guard let window = UIApplication.shared.sceneDelegate?.window else { return }
//        window.changeRootViewController(to: viewController, animated: true, duration: 0.2, options: [], completion: { })
    }
}
