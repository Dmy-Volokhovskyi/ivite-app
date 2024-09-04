import Foundation

final class ProfileBuilder: BaseBuilder {
    override func make() -> ProfileController {
        let router = ProfileRouter()
        let interactor = ProfileInteractor(serviceProvider: serviceProvider)
        let presenter = ProfilePresenter(router: router, interactor: interactor)
        let controller = ProfileController(eventHandler: presenter, dataSource: presenter)

        presenter.viewInterface = controller

        interactor.delegate = presenter
        
        router.controller = controller

        return controller
    }
}
