protocol SignInInteractorDelegate: AnyObject {
}

final class SignInInteractor: BaseInteractor {
    weak var delegate: SignInInteractorDelegate?
}
