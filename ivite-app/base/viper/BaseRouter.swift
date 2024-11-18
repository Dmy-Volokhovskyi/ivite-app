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
    
    func popVC(animated: Bool = true) {
           if let navigationController = controller?.navigationController {
               // Pop view controller from navigation stack
               navigationController.popViewController(animated: animated)
           } else {
               // Fallback to dismiss if the controller is presented modally
               controller?.dismiss(animated: animated, completion: nil)
           }
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
    
    func showActions(actions: [ActionItem], global: Bool = false) {
        // Create an instance of ActionsViewController and set actions
        let actionsVC = ActionsViewController()
        actionsVC.setActions(actions)
        
        // Wrap ActionsViewController in a ModalNavigationController
        let navigationController = ModalNavigationController(rootViewController: actionsVC)
        navigationController.isFullScreen = false

        // Determine the presenting controller
        var controller = self.controller
        if global {
            while controller?.presentedViewController != nil {
                controller = controller?.presentedViewController
            }
        }
        
        // Present the navigation controller
        controller?.present(navigationController, animated: true)
    }
    
    func showAlert(alertItem: AlertItem, global: Bool = false) {
        // Create an instance of AlertViewController and set the AlertItem
        let alertVC = AlertViewController()
        alertVC.setAlertItem(alertItem)
        
        // Wrap AlertViewController in a ModalNavigationController
        let navigationController = ModalNavigationController(rootViewController: alertVC)
        navigationController.isFullScreen = false

        // Determine the presenting controller
        var controller = self.controller
        if global {
            while controller?.presentedViewController != nil {
                controller = controller?.presentedViewController
            }
        }
        
        // Present the navigation controller
        controller?.present(navigationController, animated: true)
    }

    func showFloatingView(customView: UIView, global: Bool = false) {
        // Create an instance of FloatingViewController and configure it with the custom view
        let floatingVC = FloatingViewController()
        floatingVC.configure(with: customView)
        
        // Wrap FloatingViewController in a ModalNavigationController
        let navigationController = ModalNavigationController(rootViewController: floatingVC)
        navigationController.isFullScreen = false

        // Determine the presenting controller
        var controller = self.controller
        if global {
            while controller?.presentedViewController != nil {
                controller = controller?.presentedViewController
            }
        }
        
        // Present the navigation controller
        controller?.present(navigationController, animated: true)
    }
}
