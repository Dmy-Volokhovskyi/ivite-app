import Foundation

protocol ReviewViewInterface: AnyObject {
    func loadData()
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
    func didTouchPreviewButton() {
        router.showPreview(creatorFlowModel: interactor.creatorFlowModel, serviceProvider: interactor.serviceProvider)
    }
    
    func didTouchBackButton() {
        router.popVC()
    }
    
    func didTouchNextButton() {
        interactor.reviewDelegate?.didEndReview()
    }
    
    func reviewMainDetailViewDidTapEditButton() {
        interactor.reviewDelegate?.reviewDidAskForEdit(editOption: .mainDetails)
    }
    
    func reviewGuestsViewDidTapEdit() {
        interactor.reviewDelegate?.reviewDidAskForEdit(editOption: .addGuests)
    }
    
    func reviewGiftsDetailViewDidTapEditButton() {
        interactor.reviewDelegate?.reviewDidAskForEdit(editOption: .gifting)
    }
}

extension ReviewPresenter: ReviewDataSource {
    var creatorFlowModel: CreatorFlowModel { interactor.creatorFlowModel }
}

extension ReviewPresenter: ReviewInteractorDelegate {
    func refreshReviewContent() {
        viewInterface?.loadData()
    }
}
