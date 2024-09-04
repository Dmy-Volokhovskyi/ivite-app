import Foundation

final class LaunchBuilder: BaseBuilder {
    override func make() -> LaunchController {
        let router = LaunchRouter()
        let interactor = LaunchInteractor(serviceProvider: serviceProvider)
        let presenter = LaunchPresenter(router: router, interactor: interactor)
        let controller = LaunchController(eventHandler: presenter, dataSource: presenter)

        presenter.viewInterface = controller

        interactor.delegate = presenter
        
        router.controller = controller

        return controller
    }
}
