protocol AddNewGuestDelegate: AnyObject {
    func didAddNewGuest(gueast: Guest)
}

protocol AddNewGuestInteractorDelegate: AnyObject {
}

final class AddNewGuestInteractor: BaseInteractor {
    weak var delegate: AddNewGuestInteractorDelegate?
    weak var addNewGuestDelgate: AddNewGuestDelegate?
}
