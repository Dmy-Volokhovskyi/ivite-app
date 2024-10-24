protocol CheckEmailInteractorDelegate: AnyObject {
}

final class CheckEmailInteractor: BaseInteractor {
    weak var delegate: CheckEmailInteractorDelegate?
}
