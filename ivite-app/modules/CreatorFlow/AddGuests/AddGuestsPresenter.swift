import Foundation

protocol AddGuestsViewInterface: AnyObject {
    func updateGuestList()
    func updateSearchBar(with filter: FilterType, text: String?)
}

final class AddGuestsPresenter: BasePresenter {
    private let interactor: AddGuestsInteractor
    let router: AddGuestsRouter
    
    private var filter: FilterType = .defaultFilter
    private var searchText: String?
    private var filteredGuests: [Guest] = []
    
    weak var viewInterface: AddGuestsController?
    
    
    init(router: AddGuestsRouter, interactor: AddGuestsInteractor) {
        self.router = router
        self.interactor = interactor
    }
    
    private func applyFilterAndSort() {
        var filteredGuests = interactor.invitedGuests
        
        // Apply search text filter
        if let searchText = searchText, !searchText.isEmpty {
            filteredGuests = filteredGuests.filter { guest in
                guest.name.localizedCaseInsensitiveContains(searchText) ||
                guest.email.localizedCaseInsensitiveContains(searchText) ||
                guest.phone.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Apply sorting based on filter type
        switch filter {
        case .alphabet:
            filteredGuests.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        case .defaultFilter:
            break // No specific sorting for default
        }
        self.filteredGuests = filteredGuests
        
        viewInterface?.updateGuestList()
    }
    
    func updateFilter(_ newFilter: FilterType) {
        filter = newFilter
        applyFilterAndSort()
    }
    
    func updateSearchText(_ text: String?) {
        searchText = text
        applyFilterAndSort()
    }
    
    func deleteGuest(for guest: Guest) {
        let deleteAction = ActionItem(title: "Delete guest", image: nil, isPrimary: true) {
            self.remove(gues: guest)
            print("Delete tapped")
        }
        
        let cancelAction = ActionItem(title: "Cancel", image: nil, isPrimary: false) {
            self.router.dismiss(completion: nil)
        }
        
        router.showAlert(alertItem: AlertItem(title: "Delete a guest from the list?", message: nil, actions: [deleteAction, cancelAction]))
    }
    
    private func remove(gues: Guest) {
        guard let index = interactor.invitedGuests.firstIndex(where: { $0.id == gues.id }) else  { return }
        interactor.invitedGuests.remove(at: index)
        router.dismiss(completion: { self.applyFilterAndSort() })
    }
}

extension AddGuestsPresenter: AddGuestsEventHandler {
    func viewDidLoad() {
        applyFilterAndSort()
    }
    
    func didTouchMenu(for indexPath: IndexPath?) {
        guard let indexPath else { return }
        
        let guest = filteredGuests[indexPath.row]
        let editAction = ActionItem(title: "Edit", image: .edit, isPrimary: true) {
            self.router.pushEditGuest(guest: guest, editGuestDelegate: self, serviceProvider: self.interactor.serviceProvider)
        }
        
        let deleteAction = ActionItem(title: "Delete", image: .trash, isPrimary: true) {
            self.deleteGuest(for: guest)
        }
        
        router.showActions(actions: [editAction, deleteAction])
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
        searchText = nil
        updateFilter(.defaultFilter)
        viewInterface?.updateSearchBar(with: filter, text: searchText)
    }
    
    func searchFieldTextFieldDidChange(_ text: String?) {
        updateSearchText(text)
    }
    
    func didSelectMenuItem(menuItem: AddGuestMenu) {
        switch menuItem {
        case .usePastList:
            return
        case .adressBook:
            router.pushAdressBook(guests: interactor.invitedGuests,
                                  adressBookDelegate: self,
                                  serviceProvider: interactor.serviceProvider)
        case .addNewGuest:
            router.pushAddGuest(addGuestDelegate: self, serviceProvider: interactor.serviceProvider)
        }
    }
    
    func didTouchBackButton() {
        router.popVC()
    }
    
    func didTouchNextButton() {
        if interactor.isEditing {
            router.dismiss(completion: nil)
            interactor.addGuestsDelegate?.didFinishAddGuests(with: interactor.invitedGuests, wasEditing: interactor.isEditing)
        } else {
            interactor.addGuestsDelegate?.didFinishAddGuests(with: interactor.invitedGuests, wasEditing: interactor.isEditing)
        }
    }
}

extension AddGuestsPresenter: AddGuestsDataSource {
    var numberOfRows: Int {
        filteredGuests.count
    }
    
    func getAddedGuest(for indexPath: IndexPath) -> Guest {
        filteredGuests[indexPath.row]
    }
    
    var nexButtonTitle: String {
        interactor.isEditing ? "Save" : "Next"
    }
}

extension AddGuestsPresenter: AddGuestsInteractorDelegate {
}

extension AddGuestsPresenter: AddNewGuestDelegate {
    func didAddNewGuest(gueast: Guest) {
        interactor.invitedGuests.append(gueast)
        applyFilterAndSort()
    }
}

extension AddGuestsPresenter: EditGuestDelegate {
    func didEditGuest(guest: Guest) {
        guard let index = interactor.invitedGuests.firstIndex(where: { $0.id == guest.id }) else  { return }
        interactor.invitedGuests[index] = guest
        applyFilterAndSort()
    }
}

extension AddGuestsPresenter: AdressBookDelegate {
    func didFinishWithGuestList(_ guestList: [Guest]) {
        interactor.invitedGuests = guestList
        applyFilterAndSort()
    }
}
