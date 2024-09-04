import Foundation

protocol ContactViewInterface: AnyObject {
}

final class ContactPresenter: BasePresenter {
    private let interactor: ContactInteractor
    let router: ContactRouter
    weak var viewInterface: ContactController?
    
    init(router: ContactRouter, interactor: ContactInteractor) {
        self.router = router
        self.interactor = interactor
    }
}

extension ContactPresenter: ContactEventHandler {
}

extension ContactPresenter: ContactDataSource {
}

extension ContactPresenter: ContactInteractorDelegate {
}
