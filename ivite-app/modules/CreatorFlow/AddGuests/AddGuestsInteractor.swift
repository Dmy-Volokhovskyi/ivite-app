protocol AddGuestsDelegate: AnyObject {
    func didFinishAddGuests(with guests: [Guest])
}

protocol AddGuestsInteractorDelegate: AnyObject {
}

final class AddGuestsInteractor: BaseInteractor {
    weak var delegate: AddGuestsInteractorDelegate?
    weak var addGuestsDelegate: AddGuestsDelegate?
    
    var invitedGuests = [Guest]()
}
