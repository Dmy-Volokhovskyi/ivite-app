import Foundation

final class CheckEmailBuilder: BaseBuilder {
    func make(email: String) -> CheckEmailController {
        let router = CheckEmailRouter()
        let interactor = CheckEmailInteractor(email: email, serviceProvider: serviceProvider)
        let presenter = CheckEmailPresenter(router: router, interactor: interactor)
        let controller = CheckEmailController(eventHandler: presenter, dataSource: presenter)

        presenter.viewInterface = controller

        interactor.delegate = presenter
        
        router.controller = controller

        return controller
    }
}
