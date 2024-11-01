protocol SignInInteractorDelegate: AnyObject {
}

final class SignInInteractor: BaseInteractor {
    weak var delegate: SignInInteractorDelegate?
    
    func signIn() -> Bool {
//        serviceProvider.authentificationService.isLoggedId.toggle()
//        return serviceProvider.authentificationService.isLoggedId
        true
    }
}
