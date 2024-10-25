import Foundation

protocol SignInDelegate: AnyObject {
    func didSignIn()
}

protocol SignInViewInterface: AnyObject {
}

final class SignInPresenter: BasePresenter {
    private let interactor: SignInInteractor
    let router: SignInRouter
    weak var viewInterface: SignInController?
    weak var singInDelegate: SignInDelegate?
    
    init(router: SignInRouter, interactor: SignInInteractor) {
        self.router = router
        self.interactor = interactor
    }
}

extension SignInPresenter: SignInEventHandler {
    func didTouchSignIn() {
        if interactor.signIn() {
            singInDelegate?.didSignIn()
            router.popVC()
        }
    }
    
    func didTapCloseButton() {
        router.popVC()
    }
    
    func didTouchForgotPassword() {
        router.pushForgotPassword(serviceProvider: interactor.serviceProvider)
        #warning("handle did forgot password")
    }
    
}

extension SignInPresenter: SignInDataSource {
}

extension SignInPresenter: SignInInteractorDelegate {
}
