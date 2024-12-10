import Foundation

protocol ForgotPasswordViewInterface: AnyObject {
}

final class ForgotPasswordPresenter: BasePresenter {
    private let interactor: ForgotPasswordInteractor
    let router: ForgotPasswordRouter
    weak var viewInterface: ForgotPasswordController?
    
    init(router: ForgotPasswordRouter, interactor: ForgotPasswordInteractor) {
        self.router = router
        self.interactor = interactor
    }
}

extension ForgotPasswordPresenter: ForgotPasswordEventHandler {
    func didPressSend(with email: String) {
        interactor.sendForgetPasswordRequest(email: email)
    }
    
    func didTapCloseButton() {
        router.popVC()
    }
}

extension ForgotPasswordPresenter: ForgotPasswordDataSource {
}

extension ForgotPasswordPresenter: ForgotPasswordInteractorDelegate {
    func didSendForgetPasswordRequest(email: String, success: Bool, error: (any Error)?) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            if let error, !success {
                self.router.showSystemAlert(title: "An error occurred", message: error.localizedDescription)
            } else {
                self.router.showCheckEmail(email: email, serviceProvider: self.interactor.serviceProvider)
            }
        }
    }
}
