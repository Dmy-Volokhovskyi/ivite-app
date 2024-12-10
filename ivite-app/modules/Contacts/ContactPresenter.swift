import Foundation

protocol ContactViewInterface: AnyObject {
    func reloadTableView()
    func updateFilter(_ filter: FilterType)
}

final class ContactPresenter: BasePresenter {
    private let interactor: ContactInteractor
    let router: ContactRouter
    weak var viewInterface: ContactController?
    
    private var filter: FilterType = .defaultFilter
    private var searchText: String?
    private var filteredContacts: [ContactCardModel] = []
    lazy var curentUser: IVUser? = interactor.serviceProvider.authenticationService.getCurrentUser()
    
    init(router: ContactRouter, interactor: ContactInteractor) {
        self.router = router
        self.interactor = interactor
    }
    
    private func applyFilterAndSort() {
        var filteredContacts = interactor.contactCards
        
        // Apply search text filter
        if let searchText = searchText, !searchText.isEmpty {
            filteredContacts = filteredContacts.filter { contact in
                contact.name.localizedCaseInsensitiveContains(searchText) ||
                contact.email.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Apply sorting based on filter type
        switch filter {
        case .alphabet:
            filteredContacts.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        case .defaultFilter:
            break // No specific sorting for default
        }
        
        self.filteredContacts = filteredContacts
        viewInterface?.reloadTableView()
    }
    
    func updateFilter(_ newFilter: FilterType) {
        filter = newFilter
        viewInterface?.updateFilter(newFilter)
        applyFilterAndSort()
    }
    
    func updateSearchText(_ text: String?) {
        searchText = text
        applyFilterAndSort()
    }
    
    
    func deleteContact(for contact: ContactCardModel) {
        let deleteAction = ActionItem(title: "Delete contact", image: nil, isPrimary: true) {
            self.remove(contact: contact)
            print("Delete tapped")
        }
        
        let cancelAction = ActionItem(title: "Cancel", image: nil, isPrimary: false) {
            self.router.dismiss(completion: nil)
        }
        
        router.showAlert(alertItem: AlertItem(title: "Delete Contact?", message: "Do you want to delete this contact?", actions: [deleteAction, cancelAction]))
    }
    
    private func showCreateGroupView(group: ContactGroup? = nil, global: Bool = false) {
        let view = CreateGroupView(contacts: interactor.contactCards)
        view.delegate = self
        router.showFloatingView(customView: view, global: global)
    }
    
    private func showCreateContactView() {
        let view = CreateContactView(contact: nil, groups: interactor.groups)
        view.delegate = self
        router.showFloatingView(customView: view)
    }
    
    private func showEditContactView(for contact: ContactCardModel) {
        let view = CreateContactView(contact: contact, groups: interactor.groups)
        view.delegate = self
        router.showFloatingView(customView: view)
    }
    
    func showEditGroupView(for group: ContactGroup) {
        let view = CreateGroupView(contacts: interactor.contactCards, group: group)
        view.delegate = self
        router.showFloatingView(customView: view)
    }
    
    private func remove(contact: ContactCardModel) {
        guard let index = interactor.contactCards.firstIndex(where: { $0.id == contact.id }) else  { return }
        interactor.contactCards.remove(at: index)
        router.dismiss(completion: { self.applyFilterAndSort() })
    }
}

extension ContactPresenter: ContactEventHandler {
    func didTapFilterButton() {
        let alphabetAction = ActionItem(title: "Alphabet", image: .alfabet, isPrimary: true) {
            self.updateFilter(.alphabet)
        }
        
        let defaultAction = ActionItem(title: "Default", image: .filter, isPrimary: false) {
            self.updateFilter(.defaultFilter)
        }
        
        router.showActions(actions: [alphabetAction, defaultAction])
    }
    
    func addNewTouch() {
        let addNewGroupAction = ActionItem(title: "Add new group", image: .group, isPrimary: true) {
            self.showCreateGroupView()
            print("Add new presed")
        }
        
        let addNewContactAction = ActionItem(title: "Add new contact", image: .guest, isPrimary: true) {
            self.showCreateContactView()
            print("Add new presed")
        }
        
        router.showActions(actions: [addNewGroupAction, addNewContactAction])
    }
    
    func didTouchMenu(for indexPath: IndexPath?) {
        guard let indexPath else { return }
        
        let contact = filteredContacts[indexPath.row]
        let editAction = ActionItem(title: "Edit", image: .edit, isPrimary: true) {
            self.showEditContactView(for: contact)
        }
        
        let deleteAction = ActionItem(title: "Delete", image: .trash, isPrimary: true) {
            self.deleteContact(for: contact)
        }
        
        router.showActions(actions: [editAction, deleteAction])
    }
    
    func searchFieldTextDidChange(_ text: String?) {
        updateSearchText(text)
    }
    
    func viewDidLoad() {
        interactor.getContacts()
    }
}

extension ContactPresenter: ContactDataSource {
    func contactCardModel(for indexPath: IndexPath) -> ContactCardModel {
        filteredContacts[indexPath.section]
    }
    
    var user: IVUser? {
        curentUser
    }
    
    var numberOfRows: Int {
        1
    }
    
    var numberOfSections: Int {
        filteredContacts.count - 1
    }
}

extension ContactPresenter: ContactInteractorDelegate {
    func contactDownloadSuccess() {
        applyFilterAndSort()
    }
}

extension ContactPresenter: CreateGroupViewDelegate {
    func didCreateGroup(_ group: ContactGroup, contacts: [ContactCardModel]) {
        interactor.groups.append(group)
        contacts.forEach({ $0.groups.append(group) })
        interactor.contactCards = contacts
        applyFilterAndSort()
        interactor.groups.map({ print($0.name) })
        interactor.contactCards.map({ print($0.groups.map(\.name)) })
        router.dismissModal(completion: nil)
    }
    
    func didTouchCancel() {
        router.dismissModal(completion: nil)
    }
}

extension ContactPresenter: CreateContactViewDelegate {
    func createNewGroup(view: CreateContactView) {
        showCreateGroupView(global: true)
    }
    
    func createContact(contact: ContactCardModel, groups: [ContactGroup]) {
        interactor.contactCards.append(contact)
        interactor.groups = groups
    }
    
    func selectGroupCellDidTapDelete(group: ContactGroup) {
        interactor.removeGroup(group: group)
    }
    
    func selectGroupCellDidTapEdit(group: ContactGroup) {
        showCreateGroupView(group: group, global: true)
    }
}
