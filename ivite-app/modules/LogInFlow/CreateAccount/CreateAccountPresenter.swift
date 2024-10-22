import Foundation

protocol CreateAccountViewInterface: AnyObject {
}

final class CreateAccountPresenter: BasePresenter {
    private let interactor: CreateAccountInteractor
    let router: CreateAccountRouter
    weak var viewInterface: CreateAccountController?
    
    init(router: CreateAccountRouter, interactor: CreateAccountInteractor) {
        self.router = router
        self.interactor = interactor
    }
}

extension CreateAccountPresenter: CreateAccountEventHandler {
}

extension CreateAccountPresenter: CreateAccountDataSource {
}

extension CreateAccountPresenter: CreateAccountInteractorDelegate {
}
