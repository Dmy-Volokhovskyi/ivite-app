import Foundation

final class AdressBookBuilder: BaseBuilder {
    func make(groups: [ContactGroup],
              contacts: [ContactCardModel],
              guestList: [Guest],
              adressBookDelegate: AdressBookDelegate) -> AdressBookController {
        let router = AdressBookRouter()
        let interactor = AdressBookInteractor(groups: groups,
                                              contacts: contacts,
                                              guestList: guestList,
                                              serviceProvider: serviceProvider)
        let presenter = AdressBookPresenter(router: router, interactor: interactor)
        let controller = AdressBookController(eventHandler: presenter, dataSource: presenter)
        
        presenter.viewInterface = controller
        
        interactor.delegate = presenter
        interactor.adressBookDelegate = adressBookDelegate
        
        router.controller = controller
        
        return controller
    }
}
