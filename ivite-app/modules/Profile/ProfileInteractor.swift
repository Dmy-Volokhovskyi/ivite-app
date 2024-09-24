protocol ProfileInteractorDelegate: AnyObject {
}

final class ProfileInteractor: BaseInteractor {
    weak var delegate: ProfileInteractorDelegate?
}
