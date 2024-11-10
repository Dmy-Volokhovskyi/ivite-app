protocol AddGuestsDelegate: AnyObject {
    func didFinishAddGuests()
}

protocol AddGuestsInteractorDelegate: AnyObject {
}

final class AddGuestsInteractor: BaseInteractor {
    weak var delegate: AddGuestsInteractorDelegate?
    weak var addGuestsDelegate: AddGuestsDelegate?
    
    let invitedGuests = [Guest(name: " Bam Bam", email: "@bam.com", phone: "No Phone"),
                         Guest(name: " Bam Bam!", email: "HEJOOO@bam.com", phone: "No Phone")]
}
