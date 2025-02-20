import Foundation

final class AddGuestsBuilder: BaseBuilder {
    func make(addGuestDelegate: AddGuestsDelegate, guests: [Guest],
              isEditing: Bool = false) -> AddGuestsController {
        let router = AddGuestsRouter()
        let interactor = AddGuestsInteractor(isEditing: isEditing, serviceProvider: serviceProvider)
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
