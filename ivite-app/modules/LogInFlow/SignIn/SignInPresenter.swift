import Foundation

protocol SignInViewInterface: AnyObject {
}

final class SignInPresenter: BasePresenter {
    private let interactor: SignInInteractor
    let router: SignInRouter
    weak var viewInterface: SignInController?
    
    init(router: SignInRouter, interactor: SignInInteractor) {
        self.router = router
        self.interactor = interactor
    }
}

extension SignInPresenter: SignInEventHandler {
    func didTouchForgotPassword() {
        #warning("handle did forgot password")
    }
    
}

extension SignInPresenter: SignInDataSource {
}

extension SignInPresenter: SignInInteractorDelegate {
}
