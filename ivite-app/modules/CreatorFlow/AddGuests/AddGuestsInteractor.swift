protocol AddGuestsDelegate: AnyObject {
    func didFinishAddGuests(with guests: [Guest], wasEditing: Bool)
}

protocol AddGuestsInteractorDelegate: AnyObject {
}

final class AddGuestsInteractor: BaseInteractor {
    weak var delegate: AddGuestsInteractorDelegate?
    weak var addGuestsDelegate: AddGuestsDelegate?
    
    var invitedGuests = [Guest]()
    let isEditing: Bool
    init(invitedGuests: [Guest] = [Guest](),
         isEditing: Bool,
         serviceProvider: ServiceProvider) {
        self.invitedGuests = invitedGuests
        self.isEditing = isEditing
        super.init(serviceProvider: serviceProvider)
    }
}
