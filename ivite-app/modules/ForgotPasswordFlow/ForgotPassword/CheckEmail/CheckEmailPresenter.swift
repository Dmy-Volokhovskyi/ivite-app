import Foundation

protocol CheckEmailViewInterface: AnyObject {
}

final class CheckEmailPresenter: BasePresenter {
    private let interactor: CheckEmailInteractor
    let router: CheckEmailRouter
    weak var viewInterface: CheckEmailController?
    
    init(router: CheckEmailRouter, interactor: CheckEmailInteractor) {
        self.router = router
        self.interactor = interactor
    }
}

extension CheckEmailPresenter: CheckEmailEventHandler {
    func didTapResendButton() {
        interactor.sendForgetPasswordRequest()
    }
}

extension CheckEmailPresenter: CheckEmailDataSource {
}

extension CheckEmailPresenter: CheckEmailInteractorDelegate {
    func didSendForgetPasswordRequest(email: String, success: Bool, error: (any Error)?) {
        if let error, !success {
            router.showSystemAlert(title: "An error occurred", message: error.localizedDescription)
        }
    }
}
