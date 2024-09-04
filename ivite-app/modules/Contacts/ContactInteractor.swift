protocol ContactInteractorDelegate: AnyObject {
}

final class ContactInteractor: BaseInteractor {
    weak var delegate: ContactInteractorDelegate?
}
