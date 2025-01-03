import Foundation

final class OrderHistoryBuilder: BaseBuilder {
    override func make() -> OrderHistoryController {
        let router = OrderHistoryRouter()
        let interactor = OrderHistoryInteractor(serviceProvider: serviceProvider)
        let presenter = OrderHistoryPresenter(router: router, interactor: interactor)
        let controller = OrderHistoryController(eventHandler: presenter, dataSource: presenter)

        presenter.viewInterface = controller

        interactor.delegate = presenter
        
        router.controller = controller

        return controller
    }
}
