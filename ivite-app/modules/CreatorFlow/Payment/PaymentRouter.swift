import UIKit

final class PaymentRouter: BaseRouter {
    func presentActionAlertController(from viewController: UIViewController, style: IVPresentationStyle) {
        let actionVC = ActionsViewController()
        
        let navigationController = UINavigationController(rootViewController: actionVC)
        
        let ivTransitioningDelegate = IVTransitioningDelegate(presentationStyle: style)
        navigationController.modalPresentationStyle = .custom
        navigationController.transitioningDelegate = ivTransitioningDelegate
        
        actionVC.setActions([
            ActionItem(title: "Edit", image: UIImage(systemName: "pencil"), isPrimary: true) { print("Edit tapped") },
            ActionItem(title: "Delete", image: UIImage(systemName: "trash"), isPrimary: false) { print("Delete tapped") }
        ])
        
        viewController.present(navigationController, animated: true)
    }
}
