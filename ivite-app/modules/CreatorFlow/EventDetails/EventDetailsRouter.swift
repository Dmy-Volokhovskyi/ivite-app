import UIKit

final class EventDetailsRouter: BaseRouter {
    
    func presentAddCoHostViewController(from viewController: UIViewController, delegate: AddCoHostViewControllerDelegate) {
        // Initialize AddCoHostViewController
        let addCoHostVC = AddCoHostViewController()
        addCoHostVC.delegate = delegate // Set the delegate if needed
        
        // Wrap the controller in a UINavigationController, if necessary
        let navigationController = UINavigationController(rootViewController: addCoHostVC)
        
        // Configure the modal presentation style
        navigationController.modalPresentationStyle = .pageSheet
        
        // iOS 15+ customization for sheet behavior
        if let sheet = navigationController.sheetPresentationController {
            sheet.detents = [.medium(), .large()] // Allow both medium and large detents
            sheet.prefersGrabberVisible = true // Show the grabber at the top of the sheet
        }
        
        // Present the view controller
        viewController.present(navigationController, animated: true, completion: nil)
    }
    
    func presentDatePickerViewController(from viewController: UIViewController, delegate: DatePickerViewControllerDelegate) {
        // Initialize AddCoHostViewController
        let datePickerViewController = DatePickerViewController()
        datePickerViewController.delegate = delegate // Set the delegate if needed
        
        // Wrap the controller in a UINavigationController, if necessary
        let navigationController = UINavigationController(rootViewController: datePickerViewController)
        
        // Configure the modal presentation style
        navigationController.modalPresentationStyle = .pageSheet
        
        // iOS 15+ customization for sheet behavior
        if let sheet = navigationController.sheetPresentationController {
            sheet.detents = [.large()] // Allow both medium and large detents
            sheet.prefersGrabberVisible = true // Show the grabber at the top of the sheet
        }
        
        // Present the view controller
        viewController.present(navigationController, animated: true, completion: nil)
    }
    
    func presentActionAlertController(from viewController: UIViewController) {
        let actionVC = ActionsViewController()
        
        let navigationController = UINavigationController(rootViewController: actionVC)
        
        // Configure the modal presentation style
        navigationController.modalPresentationStyle = .pageSheet
        
        // iOS 15+ customization for sheet behavior
        if let sheet = navigationController.sheetPresentationController {
            sheet.detents = [.medium()] // Allow both medium and large detents
            sheet.prefersGrabberVisible = true // Show the grabber at the top of the sheet
        }
        #warning("transition the actions to the presenter and work about them")
        let editAction = ActionItem(title: "Edit", image: UIImage(systemName: "pencil")) {
            print("Edit tapped")
        }

        let deleteAction = ActionItem(title: "Delete", image: UIImage(systemName: "trash")) {
            print("Delete tapped")
        }

        actionVC.setActions([editAction, deleteAction])

        viewController.present(navigationController, animated: true)
    }
}
