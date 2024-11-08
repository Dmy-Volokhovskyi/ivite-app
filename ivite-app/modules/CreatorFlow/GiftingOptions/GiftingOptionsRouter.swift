import UIKit

final class GiftingOptionsRouter: BaseRouter {
    func presentActionAlertController(from viewController: UIViewController, with actionItems: [ActionItem]) {
        let actionVC = ActionsViewController()
        
        let navigationController = UINavigationController(rootViewController: actionVC)
        
        // Configure the modal presentation style
        navigationController.modalPresentationStyle = .pageSheet
        
        // iOS 15+ customization for sheet behavior
        if let sheet = navigationController.sheetPresentationController {
            sheet.detents = [.medium()] // Allow both medium and large detents
            sheet.prefersGrabberVisible = true // Show the grabber at the top of the sheet
        }

        actionVC.setActions(actionItems)

        viewController.present(navigationController, animated: true)
    }
}
