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
        print("'nex'")
    }
    
    func didTouchNextButton() {
        print("'bac'")
    }
    
}

extension ReviewPresenter: ReviewDataSource {
}

extension ReviewPresenter: ReviewInteractorDelegate {
}
