import Foundation

final class MainScreenBuilder: BaseBuilder {
    override func make() -> MainScreenController {
        let router = MainScreenRouter()
        let interactor = MainScreenInteractor(serviceProvider: serviceProvider)
        let presenter = MainScreenPresenter(router: router, interactor: interactor)
        let controller = MainScreenController(eventHandler: presenter, dataSource: presenter)

        presenter.viewInterface = controller

        interactor.delegate = presenter
        
        router.controller = controller

        return controller
    }
}
