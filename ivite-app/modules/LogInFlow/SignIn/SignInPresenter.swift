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
    func didTouchSignInWithGoogle() {
        guard let controller = viewInterface else { return }
        interactor.serviceProvider.authentificationService.signInWithGoogle(presentingViewController: controller, completion: {_ in 
            print("sucess")
        })
    }
    
    func didTouchSignIn() {
        if interactor.signIn() {
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
