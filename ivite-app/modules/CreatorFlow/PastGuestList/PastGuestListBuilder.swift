import Foundation

final class PastGuestListBuilder: BaseBuilder {
    func make(pastListDelegate: PastGuestListDelegate) -> PastGuestListController {
        let router = PastGuestListRouter()
        let interactor = PastGuestListInteractor(serviceProvider: serviceProvider)
        let presenter = PastGuestListPresenter(router: router, interactor: interactor)
        let controller = PastGuestListController(eventHandler: presenter, dataSource: presenter)

        presenter.viewInterface = controller

        interactor.delegate = presenter
        interactor.pastListDelegate = pastListDelegate
        
        router.controller = controller

        return controller
    }
}
