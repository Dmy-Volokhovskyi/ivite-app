import Foundation

final class EventsBuilder: BaseBuilder {
    override func make() -> EventsController {
        let router = EventsRouter()
        let interactor = EventsInteractor(serviceProvider: serviceProvider)
        let presenter = EventsPresenter(router: router, interactor: interactor)
        let controller = EventsController(eventHandler: presenter, dataSource: presenter)

        presenter.viewInterface = controller

        interactor.delegate = presenter
        
        router.controller = controller

        return controller
    }
}
