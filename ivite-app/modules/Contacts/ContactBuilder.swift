import Foundation

final class ContactBuilder: BaseBuilder {
    override func make() -> ContactController {
        let router = ContactRouter()
        let interactor = ContactInteractor(serviceProvider: serviceProvider)
        let presenter = ContactPresenter(router: router, interactor: interactor)
        let controller = ContactController(eventHandler: presenter, dataSource: presenter)

        presenter.viewInterface = controller

        interactor.delegate = presenter
        
        router.controller = controller

        return controller
    }
}
