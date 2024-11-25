import Foundation

final class AddNewGuestBuilder: BaseBuilder {
    func make(addNewGuestDelgate: AddNewGuestDelegate) -> AddNewGuestController {
        let router = AddNewGuestRouter()
        let interactor = AddNewGuestInteractor(serviceProvider: serviceProvider)
        let presenter = AddNewGuestPresenter(router: router, interactor: interactor)
        let controller = AddNewGuestController(eventHandler: presenter, dataSource: presenter)

        presenter.viewInterface = controller

        interactor.delegate = presenter
        interactor.addNewGuestDelgate = addNewGuestDelgate
        
        router.controller = controller

        return controller
    }
}
