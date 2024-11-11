import Foundation

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
