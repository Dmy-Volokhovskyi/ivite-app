import Foundation

final class DataPrivacyBuilder: BaseBuilder {
    override func make() -> DataPrivacyController {
        let router = DataPrivacyRouter()
        let interactor = DataPrivacyInteractor(serviceProvider: serviceProvider)
        let presenter = DataPrivacyPresenter(router: router, interactor: interactor)
        let controller = DataPrivacyController(eventHandler: presenter, dataSource: presenter)

        presenter.viewInterface = controller

        interactor.delegate = presenter
        
        router.controller = controller

        return controller
    }
}
