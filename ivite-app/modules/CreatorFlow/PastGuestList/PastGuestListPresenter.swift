import Foundation

protocol PastGuestListViewInterface: AnyObject {
}

final class PastGuestListPresenter: BasePresenter {
    private let interactor: PastGuestListInteractor
    let router: PastGuestListRouter
    weak var viewInterface: PastGuestListController?
    
    private var filter: FilterType = .defaultFilter
    private var searchText: String?
    private var events: [Event] = []
    private var filteredEvents: [Event] = []
    
    init(router: PastGuestListRouter, interactor: PastGuestListInteractor) {
        self.router = router
        self.interactor = interactor
    }
    
    private func applyFilterAndSort() {
        // Handle flat contacts for "Contact" mode
        filteredEvents = interactor.events
        
        // Apply search text filter
        if let searchText = searchText, !searchText.isEmpty {
            filteredEvents = filteredEvents.filter { event in
                event.title.localizedCaseInsensitiveContains(searchText)
            }
        }
        // Apply sorting to contacts
        switch filter {
        case .alphabet:
            filteredEvents.sort { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
        case .defaultFilter:
            break // No specific sorting for default
        }
        
        // Notify the view to reload data
        viewInterface?.reloadData()
    }
    
    func updateFilter(_ newFilter: FilterType) {
        filter = newFilter
        applyFilterAndSort()
    }
}

extension PastGuestListPresenter: PastGuestListEventHandler {
    func toggleEventSelection(_ indePath: Int) {
        let event = filteredEvents[indePath]
        if interactor.isEventSelected(event.id) {
            // Remove from guest list
            interactor.selectedEvents.removeValue(forKey: event.id)
        } else {
            // Add to guest list
            interactor.selectedEvents[event.id] = event
        }
        // Reload the view
        viewInterface?.reloadData()
    }

    func searchFieldTextFieldDidChange(_ text: String?) {
        searchText = text
        applyFilterAndSort()
    }
    
    func searchFilterViewDidTapFilterButton() {
        let alphabetAction = ActionItem(title: "Alphabet", image: .alfabet, isPrimary: true) {
            self.updateFilter(.alphabet)
            self.viewInterface?.updateSearchBar(with: self.filter, text: self.searchText)
        }
        
        let defaultAction = ActionItem(title: "Default", image: .filter, isPrimary: false) {
            self.updateFilter(.defaultFilter)
            self.viewInterface?.updateSearchBar(with: self.filter, text: self.searchText)
        }
        
        router.showActions(actions: [alphabetAction, defaultAction])
    }
    
    func searchFilterViewDidTapDeleteButton() {
        // Reset the search text
        searchText = nil
        filter = .defaultFilter
        // Reapply filters to show unfiltered data
        applyFilterAndSort()
        
        // Reset the search bar in the view
        viewInterface?.updateSearchBar(with: filter, text: nil)
    }
    
    func didTapAdd() {
        let guests = interactor.selectedEvents.values.flatMap(\.guests)
        interactor.pastListDelegate?.didFinishPicking(with: guests)
        router.popVC()
    }
    
    func viewDidLoad() {
        interactor.getEvents()
    }
}

extension PastGuestListPresenter: PastGuestListDataSource {
    func event(at index: Int) -> (Event?, Bool) {
        (filteredEvents[index], interactor.isEventSelected(filteredEvents[index].id))
    }
    
    var numberOfEvents: Int {
        filteredEvents.count
    }
}

extension PastGuestListPresenter: PastGuestListInteractorDelegate {
    func eventDownloadSuccess() {
        applyFilterAndSort()
    }
}
