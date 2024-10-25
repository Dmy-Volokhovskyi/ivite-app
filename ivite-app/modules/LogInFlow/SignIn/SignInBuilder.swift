import Foundation

final class SignInBuilder: BaseBuilder {
    func make(signInDelegate: SignInDelegate) -> SignInController {
        let router = SignInRouter()
        let interactor = SignInInteractor(serviceProvider: serviceProvider)
        let presenter = SignInPresenter(router: router, interactor: interactor)
        let controller = SignInController(eventHandler: presenter, dataSource: presenter)

        presenter.viewInterface = controller
        presenter.singInDelegate = signInDelegate

        interactor.delegate = presenter
        
        router.controller = controller

        return controller
    }
}
