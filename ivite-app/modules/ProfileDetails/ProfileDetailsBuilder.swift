import Foundation

final class ProfileDetailsBuilder: BaseBuilder {
    override func make() -> ProfileDetailsController {
        let router = ProfileDetailsRouter()
        let interactor = ProfileDetailsInteractor(serviceProvider: serviceProvider)
        let presenter = ProfileDetailsPresenter(router: router, interactor: interactor)
        let controller = ProfileDetailsController(eventHandler: presenter, dataSource: presenter)

        presenter.viewInterface = controller

        interactor.delegate = presenter
        
        router.controller = controller

        return controller
    }
}
