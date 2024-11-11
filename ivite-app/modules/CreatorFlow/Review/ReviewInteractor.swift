protocol ReviewInteractorDelegate: AnyObject {
}

final class ReviewInteractor: BaseInteractor {
    weak var delegate: ReviewInteractorDelegate?
}
