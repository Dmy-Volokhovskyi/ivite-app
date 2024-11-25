import Foundation

protocol ReviewViewInterface: AnyObject {
}

final class ReviewPresenter: BasePresenter {
    private let interactor: ReviewInteractor
    let router: ReviewRouter
    weak var viewInterface: ReviewController?
    
    init(router: ReviewRouter, interactor: ReviewInteractor) {
        self.router = router
        self.interactor = interactor
    }
}

extension ReviewPresenter: ReviewEventHandler {
    func didTouchBackButton() {
        router.popVC()
    }
    
    func didTouchNextButton() {
        interactor.reviewDelegate?.didEndReview()
    }
    
}

extension ReviewPresenter: ReviewDataSource {
    var creatorFlowModel: CreatorFlowModel { interactor.creatorFlowModel }
}

extension ReviewPresenter: ReviewInteractorDelegate {
}
