import Foundation

final class ReviewBuilder: BaseBuilder {
    func make(reviewDelegate: ReviewDelegate, creatorFlowModel: CreatorFlowModel) -> (ReviewController, ReviewInteractor) {
        let router = ReviewRouter()
        let interactor = ReviewInteractor(creatorFlowModel: creatorFlowModel, serviceProvider: serviceProvider)
        let presenter = ReviewPresenter(router: router, interactor: interactor)
        let controller = ReviewController(eventHandler: presenter, dataSource: presenter)

        presenter.viewInterface = controller

        interactor.delegate = presenter
        interactor.reviewDelegate = reviewDelegate
        
        router.controller = controller

        return (controller, interactor)
    }
}
