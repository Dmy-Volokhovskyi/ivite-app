protocol ReviewDelegate: AnyObject {
    func reviewDidAskForEdit(editOption: EditOption)
    func didEndReview()
}

protocol ReviewRefreshDelegate: AnyObject {
    func refreshReviewContent()
}

protocol ReviewInteractorDelegate: AnyObject {
    func refreshReviewContent()
}

final class ReviewInteractor: BaseInteractor {
    weak var delegate: ReviewInteractorDelegate?
    weak var reviewDelegate: ReviewDelegate?
    
    var creatorFlowModel: CreatorFlowModel
    
    init(creatorFlowModel: CreatorFlowModel, serviceProvider: ServiceProvider) {
        self.creatorFlowModel = creatorFlowModel
        super.init(serviceProvider: serviceProvider)
    }
}


extension ReviewInteractor: ReviewRefreshDelegate {
    func refreshReviewContent() {
        delegate?.refreshReviewContent()
    }
}
