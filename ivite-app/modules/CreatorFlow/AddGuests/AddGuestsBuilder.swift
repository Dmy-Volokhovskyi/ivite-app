import Foundation

final class AddGuestsBuilder: BaseBuilder {
    func make(addGuestDelegate: AddGuestsDelegate, serviceProvider: ServiceProvider) -> AddGuestsController {
        let router = AddGuestsRouter()
        let interactor = AddGuestsInteractor(serviceProvider: serviceProvider)
        let presenter = AddGuestsPresenter(router: router, interactor: interactor)
        let controller = AddGuestsController(eventHandler: presenter, dataSource: presenter)

        presenter.viewInterface = controller

        interactor.delegate = presenter
        interactor.addGuestsDelegate = addGuestDelegate
        
        router.controller = controller

        return controller
    }
}
