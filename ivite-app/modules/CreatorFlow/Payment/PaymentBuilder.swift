import Foundation

final class PaymentBuilder: BaseBuilder {
    override func make() -> PaymentController {
        let router = PaymentRouter()
        let interactor = PaymentInteractor(serviceProvider: serviceProvider)
        let presenter = PaymentPresenter(router: router, interactor: interactor)
        let controller = PaymentController(eventHandler: presenter, dataSource: presenter)

        presenter.viewInterface = controller

        interactor.delegate = presenter
        
        router.controller = controller

        return controller
    }
}
