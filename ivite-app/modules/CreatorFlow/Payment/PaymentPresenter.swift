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
        router.showActions(actions: [
            ActionItem(
                title: "Edit",
                image: UIImage(systemName: "pencil"),
                isPrimary: false
            ) { [weak self] in
                guard let self = self else { return }
                print("Edit tapped")
//                self.editAction()
            },
            ActionItem(
                title: "Delete",
                image: UIImage(systemName: "trash"),
                isPrimary: false
            ) { [weak self] in
                guard let self = self else { return }
                print("Delete tapped")
//                self.deleteAction()
            }
        ])

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
