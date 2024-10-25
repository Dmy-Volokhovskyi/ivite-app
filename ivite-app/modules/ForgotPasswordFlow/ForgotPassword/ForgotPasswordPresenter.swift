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
    func didTapCloseButton() {
        router.popVC()
    }
    
    func didPressSend() {
        router.showCheckEmail(serviceProvider: interactor.serviceProvider)
    }
}

extension ForgotPasswordPresenter: ForgotPasswordDataSource {
}

extension ForgotPasswordPresenter: ForgotPasswordInteractorDelegate {
}
