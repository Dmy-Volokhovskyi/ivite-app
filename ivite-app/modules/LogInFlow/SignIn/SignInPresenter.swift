import Foundation

protocol SignInViewInterface: AnyObject {
    func showLoadingIndicator()
    func hideLoadingIndicator()
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
        Task {
            await interactor.signInWithGoogle(presentingViewController: controller)
        }
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
    }
    
}

extension SignInPresenter: SignInDataSource {
}

extension SignInPresenter: SignInInteractorDelegate {
    func signInSuccessfully() {
        router.popVC()
    }
    
    func showLoadingIndicator() {
        viewInterface?.showLoadingIndicator() // Pass loading state to the view
    }
    
    func hideLoadingIndicator() {
        viewInterface?.hideLoadingIndicator() // Hide loading indicator in the view
    }
    
    func showAlert(title: String, message: String) {
        router.showSystemAlert(title: title, message: message)
    }
}
