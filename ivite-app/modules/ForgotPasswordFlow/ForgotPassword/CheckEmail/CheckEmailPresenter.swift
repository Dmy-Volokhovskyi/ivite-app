import Foundation

protocol CheckEmailViewInterface: AnyObject {
}

final class CheckEmailPresenter: BasePresenter {
    private let interactor: CheckEmailInteractor
    let router: CheckEmailRouter
    weak var viewInterface: CheckEmailController?
    
    init(router: CheckEmailRouter, interactor: CheckEmailInteractor) {
        self.router = router
        self.interactor = interactor
    }
}

extension CheckEmailPresenter: CheckEmailEventHandler {
}

extension CheckEmailPresenter: CheckEmailDataSource {
}

extension CheckEmailPresenter: CheckEmailInteractorDelegate {
}
