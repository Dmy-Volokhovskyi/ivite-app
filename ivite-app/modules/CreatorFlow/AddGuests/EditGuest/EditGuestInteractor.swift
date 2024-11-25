protocol EditGuestDelegate: AnyObject {
    func didEditGuest(guest: Guest)
}

protocol EditGuestInteractorDelegate: AnyObject {
}

final class EditGuestInteractor: BaseInteractor {
    weak var delegate: EditGuestInteractorDelegate?
    weak var editGuestDelegate: EditGuestDelegate?
    
    var guest: Guest
    
    init(guest: Guest, serviceProvide: ServiceProvider) {
        self.guest = guest
        super.init(serviceProvider: serviceProvide)
    }
}
