import Foundation

final class HomeBuilder: BaseBuilder {
    override func make() -> HomeController {
        let router = HomeRouter()
        let interactor = HomeInteractor(serviceProvider: serviceProvider)
        let presenter = HomePresenter(router: router, interactor: interactor)
        let controller = HomeController(eventHandler: presenter, dataSource: presenter)

        presenter.viewInterface = controller

        interactor.delegate = presenter
        
        router.controller = controller

        return controller
    }
}
