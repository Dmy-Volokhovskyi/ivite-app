protocol AdressBookDelegate: AnyObject {
    func didFinishWithGuestList(_ guestList: [Guest])
}

protocol AdressBookInteractorDelegate: AnyObject {
    func contactDownloadSuccess()
    func dismiss()
}

final class AdressBookInteractor: BaseInteractor {
    weak var delegate: AdressBookInteractorDelegate?
    weak var adressBookDelegate: AdressBookDelegate?
    
    var currentUser: IVUser?
    var groups: [ContactGroup]
    var contacts: [ContactCardModel]
    var guestList: [String: Guest] // Dictionary for efficient lookup
    
    init(groups: [ContactGroup],
         contacts: [ContactCardModel],
         guestList: [Guest],
         serviceProvider: ServiceProvider) {
        self.groups = groups
        self.contacts = contacts
        self.guestList = Dictionary(uniqueKeysWithValues: guestList.map { ($0.id, $0) }) // Transform array to dictionary
        super.init(serviceProvider: serviceProvider)
        
        currentUser = serviceProvider.userDefaultsService.getUser()
    }
    
    func isGuestSelected(_ id: String) -> Bool {
        return guestList.keys.contains(id)
    }
    
    func fetchAllContactsAndGroups() async {
        guard let currentUser = currentUser else { return }
        
        do {
            // Fetch contacts
            let contacts = try await serviceProvider.firestoreManager.fetchAllContacts(userId: currentUser.userId)
            self.contacts = contacts
            
            // Fetch groups
            let groups = try await serviceProvider.firestoreManager.fetchAllGroups(for: currentUser.userId)
            self.groups = groups
            
            // Notify the presenter that the data is ready
            await MainActor.run {
                delegate?.contactDownloadSuccess()
            }
        } catch {
            // Handle errors if needed
            print("Error fetching contacts or groups: \(error)")
        }
    }
    
    func finish() {
        let values = Array(guestList.values)
        adressBookDelegate?.didFinishWithGuestList(values)
        delegate?.dismiss()
    }
}
