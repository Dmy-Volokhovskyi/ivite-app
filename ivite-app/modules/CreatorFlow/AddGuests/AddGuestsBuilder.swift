import Foundation

final class AddGuestsBuilder: BaseBuilder {
    func make(addGuestDelegate: AddGuestsDelegate, guests: [Guest]) -> AddGuestsController {
        let router = AddGuestsRouter()
        let interactor = AddGuestsInteractor(serviceProvider: serviceProvider)
        let presenter = AddGuestsPresenter(router: router, interactor: interactor)
        let controller = AddGuestsController(eventHandler: presenter, dataSource: presenter)

        presenter.viewInterface = controller

        interactor.delegate = presenter
        interactor.addGuestsDelegate = addGuestDelegate
        interactor.invitedGuests = guests
        
        router.controller = controller

        return controller
    }
}
