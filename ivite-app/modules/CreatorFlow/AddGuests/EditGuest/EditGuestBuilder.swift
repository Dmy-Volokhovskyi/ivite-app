import Foundation

final class EditGuestBuilder: BaseBuilder {
    func make(guest: Guest, editGuestDelgate: EditGuestDelegate) -> EditGuestController {
        let router = EditGuestRouter()
        let interactor = EditGuestInteractor(guest: guest, serviceProvide: serviceProvider)
        let presenter = EditGuestPresenter(router: router, interactor: interactor)
        let controller = EditGuestController(eventHandler: presenter, dataSource: presenter)

        presenter.viewInterface = controller

        interactor.delegate = presenter
        interactor.editGuestDelegate = editGuestDelgate
        
        router.controller = controller

        return controller
    }
}
