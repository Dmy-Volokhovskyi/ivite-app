final class AddGuestsRouter: BaseRouter {
    
    func pushAddGuest(addGuestDelegate: AddNewGuestDelegate, serviceProvider: ServiceProvider) {
        let controller = AddNewGuestBuilder(serviceProvider: serviceProvider).make(addNewGuestDelgate: addGuestDelegate)
        self.controller?.navigationController?.pushViewController(controller, animated: true)
    }
    
    func pushEditGuest(guest: Guest, editGuestDelegate: EditGuestDelegate, serviceProvider: ServiceProvider) {
        let controller = EditGuestBuilder(serviceProvider: serviceProvider).make(guest: guest, editGuestDelgate: editGuestDelegate)
        self.controller?.navigationController?.pushViewController(controller, animated: true)
    }
    
    func pushAdressBook(guests: [Guest], adressBookDelegate: AdressBookDelegate, serviceProvider: ServiceProvider) {
        let controller = AdressBookBuilder(serviceProvider: serviceProvider).make(groups: [],
                                                                                  contacts: [],
                                                                                  guestList: guests,
                                                                                  adressBookDelegate: adressBookDelegate)
        self.controller?.navigationController?.pushViewController(controller, animated: true)
    }
}
