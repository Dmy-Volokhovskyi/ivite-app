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
    func didSelectMenuItem(menuItem: ProfileMenuItem) {
      
        switch menuItem {
        case .dataPrivacy:
            print(menuItem)
        case .orderHistory:
            print(menuItem)
        case .recentPaymentMethod:
            print(menuItem)
        case .logOut:
            interactor.serviceProvider.authentificationService.signOut()
        }
    }
    
    func didTouchShowProfile() {
        print("touch profile")
    }
}

extension ProfilePresenter: ProfileDataSource {
}

extension ProfilePresenter: ProfileInteractorDelegate {
}
