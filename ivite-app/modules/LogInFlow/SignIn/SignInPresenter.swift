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
    func didTapClickableText() {
        router.showCreateAccount(serviceProvider: interactor.serviceProvider)
    }
    
    func didTouchSignInWithGoogle() {
        guard let controller = viewInterface else { return }
        interactor.serviceProvider.authenticationService.signInWithGoogle(presentingViewController: controller, completion: {_ in 
            self.router.popVC()
        })
    }
    
    func didTouchSignIn(with email: String, password: String) {
        Task {
            await interactor.signIn(with: email, password: password)
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
    func showAlert(title: String, message: String) {
        router.showSystemAlert(title: title, message: message)
    }
    
    func signInDidComplete(did signIn: Bool) {
        router.popVC()
    }
}
