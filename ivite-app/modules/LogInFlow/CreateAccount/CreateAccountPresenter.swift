import Foundation

protocol CreateAccountViewInterface: AnyObject {
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
        interactor.serviceProvider.authenticationService.signInWithGoogle(presentingViewController: controller, completion: {_ in
            self.router.popVC()
        })
    }
    
    func didTouchSignUp(with name: String, email: String, password: String) {
        Task {
            await interactor.signUp(with: email, password: password)
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
    func showAlert(title: String, message: String) {
        router.showSystemAlert(title: title, message: message)
    }
}
