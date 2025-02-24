import Foundation

protocol ContactViewInterface: AnyObject {
    func reloadTableView()
    func updateFilter(_ filter: FilterType)
    func updateSearchBar()
    func updateLoadingState(_ isLoading: Bool)
}

final class ContactPresenter: BasePresenter {
    private let interactor: ContactInteractor
    let router: ContactRouter
    weak var viewInterface: ContactController?
    
    private var filter: FilterType = .defaultFilter
    private var searchText: String?
    private var filteredContacts: [ContactCardModel] = []
    private var currentContact: ContactCardModel?
    private var isEditing = false
    private var isLoading: Bool = false {
        didSet {
            viewInterface?.updateLoadingState(isLoading)
        }
    }
    
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
    
    func removeGroup(_ group: ContactGroup) {
        Task {
            isLoading = true
            await interactor.removeGroup(group)
            isLoading = false
        }
    }
    
    func deleteContact(for contact: ContactCardModel) {
        let deleteAction = ActionItem(title: "Delete contact", image: nil, isPrimary: true) { [self] in
            Task {
                isLoading = true
                await interactor.deleteContact(contact)
                isLoading = false
            }
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
    
    private func showCreateContactView(for contact: ContactCardModel?) {
        let view = CreateContactView(contact: contact, groups: interactor.groups)
        view.delegate = self
        router.showFloatingView(customView: view)
    }
    
    private func showEditContactView(for contact: ContactCardModel) {
        let view = EditContactView(contact: contact, groups: interactor.groups)
        view.delegate = self
        router.showFloatingView(customView: view)
    }
    
    func showEditGroupView(for group: ContactGroup) {
        let view = EditGroupView(contacts: interactor.contactCards, group: group)
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
    func viewDidLoad() {
        Task {
            isLoading = true
            await interactor.fetchAllContactsAndGroups()
            isLoading = false
        }
    }
    
    func viewWillAppear() {
        interactor.checkForUserUpdates()
        viewInterface?.updateSearchBar()
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
    
    func addNewTouch() {
        let addNewGroupAction = ActionItem(title: "Add new group", image: .group, isPrimary: true) {
            self.showCreateGroupView()
            print("Add new presed")
        }
        
        let addNewContactAction = ActionItem(title: "Add new contact", image: .guest, isPrimary: true) {
            self.showCreateContactView(for: nil)
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
}

extension ContactPresenter: ContactDataSource {
    func contactCardModel(for indexPath: IndexPath) -> ContactCardModel {
        filteredContacts[indexPath.section]
    }
    
    var user: IVUser? {
        interactor.currentUser
    }
    
    var numberOfRows: Int {
        1
    }
    
    var numberOfSections: Int {
        filteredContacts.count
    }
}

extension ContactPresenter: ContactInteractorDelegate {
    func contactDownloadSuccess() {
        applyFilterAndSort()
    }
}

extension ContactPresenter: CreateGroupViewDelegate {
    func didCreateGroup(_ group: ContactGroup, contacts: [ContactCardModel]) {
        Task {
            isLoading = true
            await interactor.saveGroup(group)
            contacts.forEach { $0.groupIds.append(group.id) }
            interactor.contactCards = contacts
            await MainActor.run {
                router.dismissModal(completion: { [weak self] in
                    guard let self, let currentContact else { return }
                    if isEditing {
                        showEditContactView(for: currentContact)
                    } else {
                        showCreateContactView(for: currentContact)
                    }
                })
            }
            isLoading = false
        }
    }
    
    func didTouchCancel() {
        router.dismissModal(completion: nil)
    }
}

extension ContactPresenter: CreateContactViewDelegate {
    func selectGroupCellDidTapEdit(contact: ContactCardModel, group: ContactGroup) {
        router.dismissModal(completion: { [ weak self] in
            self?.currentContact = contact
            self?.showCreateGroupView(group: group, global: true)
        })
    }
    
    func createNewGroup(contact: ContactCardModel, view: CreateContactView) {
        router.dismissModal(completion: { [ weak self ] in
            self?.currentContact = contact
            self?.showCreateGroupView(global: true)
        })
      
    }
    
    func selectGroupCellDidTapDelete(group: ContactGroup) {
        removeGroup(group)
    }

    func createContact(contact: ContactCardModel, groups: [ContactGroup]) {
        Task {
            isLoading = true
            await interactor.saveContact(contact)
            interactor.groups = groups
            await MainActor.run {
                router.dismissModal(completion: nil)
            }
            isLoading = false
        }
    }
}

extension ContactPresenter: EditGroupViewDelegate {
    func didEditGroup(_ group: ContactGroup, contacts: [ContactCardModel]) {
        Task {
            isLoading = true
            await interactor.saveGroup(group)
            await MainActor.run {
                router.dismissModal(completion: { [weak self] in
                    guard let self, let currentContact else { return }
                    if isEditing {
                        showEditContactView(for: currentContact)
                    } else {
                        showCreateContactView(for: currentContact)
                    }
                })
            }
            isEditing = false
            isLoading = false
        }
     }
}

extension ContactPresenter: EditContactViewDelegate {
    func editContactView(_ view: EditContactView, requestSave contact: ContactCardModel) {
        Task {
            isLoading = true
            await interactor.saveContact(contact)
            await MainActor.run {
                router.dismissModal(completion: nil)
            }
            isEditing = false
            isLoading = false
        }
    }
    
    func editContactViewDidCancel(_ view: EditContactView) {
        router.dismissModal(completion: nil)
    }
    
    func editContactView(_ view: EditContactView, requestCreateNewGroupFor contact: ContactCardModel) {
        router.dismissModal(completion: { [weak self] in
            guard let self else { return }
            self.currentContact = contact
            self.isEditing = true
            self.showCreateGroupView()
        })
    }
    
    func editContactView(_ view: EditContactView, requestEdit group: ContactGroup, for contact: ContactCardModel) {
        router.dismissModal(completion: { [weak self] in
            guard let self else { return }
            currentContact = contact
            self.isEditing = true
            showEditGroupView(for: group)
        })
    }
    
    func editContactView(_ view: EditContactView, requestDeleteGroup group: ContactGroup) {
        removeGroup(group)
    }
}
