import Foundation

protocol OrderHistoryViewInterface: AnyObject {
}

final class OrderHistoryPresenter: BasePresenter {
    private let interactor: OrderHistoryInteractor
    let router: OrderHistoryRouter
    weak var viewInterface: OrderHistoryController?
    
    init(router: OrderHistoryRouter, interactor: OrderHistoryInteractor) {
        self.router = router
        self.interactor = interactor
    }
}

extension OrderHistoryPresenter: OrderHistoryEventHandler {
    func viewWillAppear() {
        
    }
}

extension OrderHistoryPresenter: OrderHistoryDataSource {
    var numberOfRows: Int {
        2
    }
}

extension OrderHistoryPresenter: OrderHistoryInteractorDelegate {
}
