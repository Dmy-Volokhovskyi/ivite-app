protocol CreateAccountInteractorDelegate: AnyObject {
}

final class CreateAccountInteractor: BaseInteractor {
    weak var delegate: CreateAccountInteractorDelegate?
}
