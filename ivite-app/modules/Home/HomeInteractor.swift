protocol HomeInteractorDelegate: AnyObject {
}

final class HomeInteractor: BaseInteractor {
    weak var delegate: HomeInteractorDelegate?
}
