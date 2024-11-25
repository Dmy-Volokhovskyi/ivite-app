protocol ReviewDelegate: AnyObject {
    func didEndReview()
}

protocol ReviewInteractorDelegate: AnyObject {
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
