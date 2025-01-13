import Foundation

final class AdressBookBuilder: BaseBuilder {
    func make(groups: [ContactGroup],
              contacts: [ContactCardModel],
              guestList: [Guest]) -> AdressBookController {
        let router = AdressBookRouter()
        let interactor = AdressBookInteractor(groups: groups,
                                              contacts: contacts,
                                              guestList: guestList,
                                              serviceProvider: serviceProvider)
        let presenter = AdressBookPresenter(router: router, interactor: interactor)
        let controller = AdressBookController(eventHandler: presenter, dataSource: presenter)
        
        presenter.viewInterface = controller
        
        interactor.delegate = presenter
        
        router.controller = controller
        
        return controller
    }
}
