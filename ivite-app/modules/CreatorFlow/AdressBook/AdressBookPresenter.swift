import Foundation

protocol AdressBookViewInterface: AnyObject {
    func reloadData()
    func updateSearchBar(with filter: FilterType, text: String?)
}

final class AdressBookPresenter: BasePresenter {
    private let interactor: AdressBookInteractor
    let router: AdressBookRouter
    weak var viewInterface: AdressBookController?
    
    internal var isGroup: Bool = false
    private var filter: FilterType = .defaultFilter
    private var searchText: String?
    private var filteredGuests: [Guest] = []
    private var filteredContacts: [ContactCardModel] = []
    private var filteredGroups: [ContactGroup] = []
    
    init(router: AdressBookRouter, interactor: AdressBookInteractor) {
        self.router = router
        self.interactor = interactor
        
        applyFilterAndSort()
    }
    
    private func applyFilterAndSort() {
        if isGroup {
            // Start with all groups
            filteredGroups = interactor.groups
            
            // Apply search text filter
            if let searchText = searchText, !searchText.isEmpty {
                filteredGroups = filteredGroups.filter { group in
                    group.name.localizedCaseInsensitiveContains(searchText) ||
                    group.members.contains { member in
                        member.name.localizedCaseInsensitiveContains(searchText) ||
                        member.email.localizedCaseInsensitiveContains(searchText)
                    }
                }
            }
            
            // Apply sorting to groups based on group name
            switch filter {
            case .alphabet:
                filteredGroups.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
            case .defaultFilter:
                break // No specific sorting for default
            }
        } else {
            // Handle flat contacts for "Contact" mode
            filteredContacts = interactor.contacts
            
            // Apply search text filter
            if let searchText = searchText, !searchText.isEmpty {
                filteredContacts = filteredContacts.filter { contact in
                    contact.name.localizedCaseInsensitiveContains(searchText) ||
                    contact.email.localizedCaseInsensitiveContains(searchText)
                }
            }
            
            // Apply sorting to contacts
            switch filter {
            case .alphabet:
                filteredContacts.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
            case .defaultFilter:
                break // No specific sorting for default
            }
        }
        
        // Notify the view to reload data
        viewInterface?.reloadData()
    }

    func updateFilter(_ newFilter: FilterType) {
        filter = newFilter
        applyFilterAndSort()
    }
}

extension AdressBookPresenter: AdressBookEventHandler {
    func didTapAdd() {
        interactor.finish()
    }
    
    func didTapSelectAllButton() {
        let shouldSelectAll: Bool
        if isGroup {
            // Determine if we should select or deselect all group members
            shouldSelectAll = !filteredGroups.flatMap { $0.members }.allSatisfy { interactor.isGuestSelected($0.id) }
            
            // Iterate over all filtered groups
            for group in filteredGroups {
                for member in group.members {
                    if shouldSelectAll && !interactor.isGuestSelected(member.id) {
                        let guest = Guest(
                            id: member.id,
                            name: member.name,
                            email: member.email,
                            phone: "N/A",
                            status: .invited
                        )
                        interactor.guestList[guest.id] = guest
                    } else if !shouldSelectAll && interactor.isGuestSelected(member.id) {
                        interactor.guestList.removeValue(forKey: member.id)
                    }
                }
            }
        } else {
            // Determine if we should select or deselect all contacts
            shouldSelectAll = !filteredContacts.allSatisfy { interactor.isGuestSelected($0.id) }
            
            // Iterate over all filtered contacts
            for contact in filteredContacts {
                if shouldSelectAll && !interactor.isGuestSelected(contact.id) {
                    let guest = Guest(
                        id: contact.id,
                        name: contact.name,
                        email: contact.email,
                        phone: "N/A",
                        status: .invited
                    )
                    interactor.guestList[guest.id] = guest
                } else if !shouldSelectAll && interactor.isGuestSelected(contact.id) {
                    interactor.guestList.removeValue(forKey: contact.id)
                }
            }
        }
        
        // Reload the view to reflect changes
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
    
    func didChangeTableMode(to groupView: Bool) {
        // Update the table mode
        isGroup = groupView
        
        // Apply filtering and sorting logic for the new mode
        applyFilterAndSort()
    }
    
    func toggleContactSelection(_ contact: ContactCardModel) {
        let guest = Guest(
            id: contact.id, // Use contact's id
            name: contact.name,
            email: contact.email,
            phone: "N/A", // Default phone since none is provided
            status: .invited
        )
        
        if interactor.isGuestSelected(contact.id) {
            // Remove from guest list
            interactor.guestList.removeValue(forKey: guest.id)
        } else {
            // Add to guest list
            interactor.guestList[guest.id] = guest
        }
        
        // Print the updated count (for debugging purposes)
        print("Guest list count: \(interactor.guestList.count)")
        
        // Reload the view
        viewInterface?.reloadData()
    }
}


extension AdressBookPresenter: AdressBookDataSource {
    var numberOfGroups: Int {
        return isGroup ? filteredGroups.count : 1
    }
    
    var allContacts: [ContactCardModel] {
        return filteredContacts
    }
    
    var isGroupView: Bool {
        return isGroup
    }
    
    func group(at index: Int) -> ContactGroup? {
        guard isGroup, index >= 0 && index < filteredGroups.count else { return nil }
        return filteredGroups[index]
    }
    
    func contactAndSelectionState(for indexPath: IndexPath, isGroupView: Bool) -> (contact: ContactCardModel, isSelected: Bool)? {
        if isGroupView {
            guard indexPath.section < filteredGroups.count,
                  indexPath.row < filteredGroups[indexPath.section].members.count else {
                return nil
            }
            let contact = filteredGroups[indexPath.section].members[indexPath.row]
            let isSelected = interactor.isGuestSelected(contact.id)
            return (contact, isSelected)
        } else {
            guard indexPath.row < filteredContacts.count else { return nil }
            let contact = filteredContacts[indexPath.row]
            let isSelected = interactor.isGuestSelected(contact.id)
            return (contact, isSelected)
        }
    }
}

extension AdressBookPresenter: AdressBookInteractorDelegate {
}
