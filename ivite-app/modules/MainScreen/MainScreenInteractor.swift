protocol MainScreenInteractorDelegate: AnyObject {
}

final class MainScreenInteractor: BaseInteractor {
    weak var delegate: MainScreenInteractorDelegate?
}
