import Foundation

protocol ProfileViewInterface: AnyObject {
}

final class ProfilePresenter: BasePresenter {
    private let interactor: ProfileInteractor
    let router: ProfileRouter
    weak var viewInterface: ProfileController?
    
    init(router: ProfileRouter, interactor: ProfileInteractor) {
        self.router = router
        self.interactor = interactor
    }
}

extension ProfilePresenter: ProfileEventHandler {
    func didTouchShowProfile() {
         
    }
}

extension ProfilePresenter: ProfileDataSource {
}

extension ProfilePresenter: ProfileInteractorDelegate {
}
