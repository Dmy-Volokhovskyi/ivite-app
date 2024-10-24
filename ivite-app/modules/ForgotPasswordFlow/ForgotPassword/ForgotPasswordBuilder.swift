import Foundation

final class ForgotPasswordBuilder: BaseBuilder {
    override func make() -> ForgotPasswordController {
        let router = ForgotPasswordRouter()
        let interactor = ForgotPasswordInteractor(serviceProvider: serviceProvider)
        let presenter = ForgotPasswordPresenter(router: router, interactor: interactor)
        let controller = ForgotPasswordController(eventHandler: presenter, dataSource: presenter)

        presenter.viewInterface = controller

        interactor.delegate = presenter
        
        router.controller = controller

        return controller
    }
}
