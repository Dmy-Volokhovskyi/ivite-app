import Foundation

protocol CreateAccountViewInterface: AnyObject {
    func showLoadingIndicator()
    func hideLoadingIndicator()
}

final class CreateAccountPresenter: BasePresenter {
    private let interactor: CreateAccountInteractor
    let router: CreateAccountRouter
    weak var viewInterface: CreateAccountController?
    
    init(router: CreateAccountRouter, interactor: CreateAccountInteractor) {
        self.router = router
        self.interactor = interactor
    }
}

extension CreateAccountPresenter: CreateAccountEventHandler {
    func didTouchSignUpWithGoogle() {
        guard let controller = viewInterface else { return }
        Task {
            await interactor.signUpWithGoogle(presentingViewController: controller)
        }
    }
    
    func didTouchSignUp(with name: String, email: String, password: String) {
        Task {
            await interactor.signUp(with: name, email: email, password: password)
        }
    }
    
    func didTapCloseButton() {
        router.popVC()
    }
    
    func didTapClickableText() {
        router.showSignIn(serviceProvider: interactor.serviceProvider)
    }
}

extension CreateAccountPresenter: CreateAccountDataSource {
}

extension CreateAccountPresenter: CreateAccountInteractorDelegate {
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
