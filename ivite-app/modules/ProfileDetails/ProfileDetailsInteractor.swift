protocol ProfileDetailsInteractorDelegate: AnyObject {
}

final class ProfileDetailsInteractor: BaseInteractor {
    weak var delegate: ProfileDetailsInteractorDelegate?
}
