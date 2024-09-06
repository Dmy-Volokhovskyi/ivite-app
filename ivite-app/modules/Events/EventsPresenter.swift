import Foundation

protocol EventsViewInterface: AnyObject {
    func reloadTableView()
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
    func didTouchMenu(for indexPath: IndexPath?) {
        print("open MENU!")
    }

    func viewDidLoad() {
        interactor.getEvents()
    }
}

extension EventsPresenter: EventsDataSource {
    func eventCardModel(for indexPath: IndexPath) -> EventCardModel {
        interactor.eventCards[indexPath.section]
    }
    
    var numberOfRows: Int {
        1
    }
    
    var numberOfSections: Int {
        interactor.eventCards.count - 1
    }
    
    var eventCardModels: [EventCardModel] {
        interactor.eventCards
    }
    
}

extension EventsPresenter: EventsInteractorDelegate {
    func eventDownloadSuccess() {
        viewInterface?.reloadTableView()
    }
}
