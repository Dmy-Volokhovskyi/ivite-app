import Foundation

final class EventDetailsBuilder: BaseBuilder {
    func make(eventDetailsViewModel: EventDetailsViewModel) -> EventDetailsController {
        let router = EventDetailsRouter()
        let interactor = EventDetailsInteractor(eventDetailsViewModel: eventDetailsViewModel,
                                                serviceProvider: serviceProvider)
        let presenter = EventDetailsPresenter(router: router, interactor: interactor)
        let controller = EventDetailsController(eventHandler: presenter, dataSource: presenter)

        presenter.viewInterface = controller

        interactor.delegate = presenter
        
        router.controller = controller

        return controller
    }
}
