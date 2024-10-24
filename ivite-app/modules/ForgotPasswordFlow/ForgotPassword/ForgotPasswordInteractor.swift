protocol ForgotPasswordInteractorDelegate: AnyObject {
}

final class ForgotPasswordInteractor: BaseInteractor {
    weak var delegate: ForgotPasswordInteractorDelegate?
}
