import Foundation

protocol EventsViewInterface: AnyObject {
}

final class EventsPresenter: BasePresenter {
    private let interactor: EventsInteractor
    let router: EventsRouter
    weak var viewInterface: EventsController?
    
    init(router: EventsRouter, interactor: EventsInteractor) {
        self.router = router
        self.interactor = interactor
    }
}

extension EventsPresenter: EventsEventHandler {
}

extension EventsPresenter: EventsDataSource {
}

extension EventsPresenter: EventsInteractorDelegate {
}
