import Foundation

protocol ProfileDetailsViewInterface: AnyObject {
}

final class ProfileDetailsPresenter: BasePresenter {
    private let interactor: ProfileDetailsInteractor
    let router: ProfileDetailsRouter
    weak var viewInterface: ProfileDetailsController?
    
    init(router: ProfileDetailsRouter, interactor: ProfileDetailsInteractor) {
        self.router = router
        self.interactor = interactor
    }
}

extension ProfileDetailsPresenter: ProfileDetailsEventHandler {
}

extension ProfileDetailsPresenter: ProfileDetailsDataSource {
    var user: IVUser? {
        interactor.serviceProvider.authentificationService.getCurrentUser()
    }
}

extension ProfileDetailsPresenter: ProfileDetailsInteractorDelegate {
}
