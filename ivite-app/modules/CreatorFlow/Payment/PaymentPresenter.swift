import Foundation
import UIKit

protocol PaymentViewInterface: AnyObject {
    func reload()
}

final class PaymentPresenter: BasePresenter {
    private let interactor: PaymentInteractor
    let router: PaymentRouter
    weak var viewInterface: PaymentController?
    
    init(router: PaymentRouter, interactor: PaymentInteractor) {
        self.router = router
        self.interactor = interactor
    }
}

extension PaymentPresenter: PaymentEventHandler {
    func didTouchBackButton() {
        router.popVC()
    }
    
    func didTouchNextButton() {
        guard let viewInterface else { return }
//        router.showActions(actions: [ ActionItem(title: "Edit", image: UIImage(systemName: "pencil")) { print("Edit tapped") },
//                                      ActionItem(title: "Delete", image: UIImage(systemName: "trash")) { print("Delete tapped") }
//                                    ])
        
        let actions = [
            ActionItem(title: "Confirm", image: UIImage(systemName: "checkmark"), isPrimary: true) {
                print("Confirm tapped")
            },
            ActionItem(title: "Cancel", image: UIImage(systemName: "xmark"), isPrimary: false) {
                print("Cancel tapped")
            }
        ]

        let alertItem = AlertItem(
            title: "Alert Title",
            message: "This is an alert message.",
            actions: actions
        )

        router.showAlert(alertItem: alertItem)
    }
    
    func didSelectOption(at indexPath: IndexPath) {
        interactor.selectedOption = interactor.paymentOptions[indexPath.row]
        viewInterface?.reload()
    }
}

extension PaymentPresenter: PaymentDataSource {
    var paymentOptions: [PaymentOption] {
        interactor.paymentOptions
    }
    
    var selectedOption: PaymentOption? {
        interactor.selectedOption
    }
    
}

extension PaymentPresenter: PaymentInteractorDelegate {
}
