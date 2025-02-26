import Foundation

protocol EventsViewInterface: AnyObject {
    func reloadTableView()
    func updateFilter(_ filter: FilterType)
    func updateSearchBar()
}

final class EventsPresenter: BasePresenter {
    private let interactor: EventsInteractor
    let router: EventsRouter
    weak var viewInterface: EventsController?
    
    private var allEvents: [Event] = []
    private var filteredEvents: [Event] = []
    
    private var filter: FilterType = .defaultFilter
    private var searchText: String?
    private var selectedStatus: EventStatus?
    
    init(router: EventsRouter, interactor: EventsInteractor) {
        self.router = router
        self.interactor = interactor
    }
    
    private func applyFilters() {
        filteredEvents = allEvents

        if let status = selectedStatus {
            filteredEvents = filteredEvents.filter { $0.status == status }
        }

        if let text = searchText, !text.isEmpty {
            filteredEvents = filteredEvents.filter { $0.title.localizedCaseInsensitiveContains(text) }
        }

        switch filter {
        case .alphabet:
            filteredEvents.sort {
                $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending
            }
        case .defaultFilter:
            filteredEvents.sort {
                guard let date0 = $0.date, let date1 = $1.date else { return false }
                return date0 < date1
            }
        }
        
        viewInterface?.reloadTableView()
    }

    
    func updateSearchText(_ text: String?) {
        searchText = text
        applyFilters()
    }
    
    func updateStatusFilter(_ status: EventStatus?) {
        selectedStatus = status
        applyFilters()
    }
    
    func updateEvents(_ events: [Event]) {
        allEvents = events
        applyFilters()
    }
    
    func updateFilter(_ newFilter: FilterType) {
        filter = newFilter
        viewInterface?.updateFilter(newFilter)
        applyFilters()
    }
}

extension EventsPresenter: EventsEventHandler {
    func didSelectRow(at indexPath: IndexPath) {
        let flowModel = CreatorFlowModel(from: filteredEvents[indexPath.section])
        self.router.showPreview(creatorFlowModel: flowModel, serviceProvider: self.interactor.serviceProvider)
    }
    
    func didTapFilterButton() {
        let alphabetAction = ActionItem(title: "Alphabet", image: .alfabet, isPrimary: true) {
            self.updateFilter(.alphabet)
        }
        
        let defaultAction = ActionItem(title: "Default", image: .filter, isPrimary: false) {
            self.updateFilter(.defaultFilter)
        }
        
        router.showActions(actions: [alphabetAction, defaultAction])
    }
    
    func searchFieldTextDidChange(_ text: String?) {
        updateSearchText(text)
    }
    
    func createNewEventButtonTouch() {
        router.switchToTab(index: 0)
    }
    
    func didTouchMenu(for indexPath: IndexPath?) {
        // Define the actions
        let addGuestsAction = ActionItem(title: "Add guests", image: .guest, isPrimary: true) {
            print("Add guests pressed")
        }
        
        let editAction = ActionItem(title: "Edit", image: .edit, isPrimary: false) {
            print("Edit pressed")
        }
        
        let copyInvitationAction = ActionItem(title: "Copy Invitation", image: .copy, isPrimary: false) {
            print("Copy Invitation pressed")
        }
        
        let deleteAction = ActionItem(title: "Delete", image: .trash, isPrimary: false) {
            print("Delete pressed")
        }
        
        // Use the router to display the actions
        router.showActions(actions: [
            addGuestsAction,
            editAction,
            copyInvitationAction,
            deleteAction
        ])
        
    }
    
    func viewWillAppear() {
        interactor.checkForUserUpdates()
        viewInterface?.updateSearchBar()
    }
    
    func viewDidLoad() {
        interactor.getEvents()
    }
}

extension EventsPresenter: EventsDataSource {
    var user: IVUser? {
        interactor.currentUser
    }
    
    func eventCardModel(for indexPath: IndexPath) -> Event {
        filteredEvents[indexPath.section]
    }
    
    var numberOfRows: Int {
        1
    }
    
    var numberOfSections: Int {
        filteredEvents.count
    }
}

extension EventsPresenter: EventsInteractorDelegate {
    func eventDownloadSuccess() {
        updateEvents(interactor.eventCards)
    }
}

