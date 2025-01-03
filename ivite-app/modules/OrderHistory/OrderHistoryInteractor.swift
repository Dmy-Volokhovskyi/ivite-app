protocol OrderHistoryInteractorDelegate: AnyObject {
}

final class OrderHistoryInteractor: BaseInteractor {
    weak var delegate: OrderHistoryInteractorDelegate?
}
