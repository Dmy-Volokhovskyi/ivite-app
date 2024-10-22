import Foundation

final class CreateAccountBuilder: BaseBuilder {
    override func make() -> CreateAccountController {
        let router = CreateAccountRouter()
        let interactor = CreateAccountInteractor(serviceProvider: serviceProvider)
        let presenter = CreateAccountPresenter(router: router, interactor: interactor)
        let controller = CreateAccountController(eventHandler: presenter, dataSource: presenter)

        presenter.viewInterface = controller

        interactor.delegate = presenter
        
        router.controller = controller

        return controller
    }
}
