protocol AdressBookDelegate: AnyObject {
    func didFinishWithGuestList(_ guestList: [Guest])
}

protocol AdressBookInteractorDelegate: AnyObject {
}

final class AdressBookInteractor: BaseInteractor {
    weak var delegate: AdressBookInteractorDelegate?
    weak var adressBookDelegate: AdressBookDelegate?
    
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
    }
    
    func isGuestSelected(_ id: String) -> Bool {
        return guestList.keys.contains(id)
    }
    
    func finish() {
        let values = Array(guestList.values)
        adressBookDelegate?.didFinishWithGuestList(values)
    }
}
