protocol LaunchInteractorDelegate: AnyObject {
}

final class LaunchInteractor: BaseInteractor {
    weak var delegate: LaunchInteractorDelegate?
}
