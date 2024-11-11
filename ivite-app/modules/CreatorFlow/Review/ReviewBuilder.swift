import Foundation

final class ReviewBuilder: BaseBuilder {
    override func make() -> ReviewController {
        let router = ReviewRouter()
        let interactor = ReviewInteractor(serviceProvider: serviceProvider)
        let presenter = ReviewPresenter(router: router, interactor: interactor)
        let controller = ReviewController(eventHandler: presenter, dataSource: presenter)

        presenter.viewInterface = controller

        interactor.delegate = presenter
        
        router.controller = controller

        return controller
    }
}
