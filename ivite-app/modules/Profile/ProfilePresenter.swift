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
    
    private func logOut() {
        let logOutAction = ActionItem(title: "Log out", image: nil, isPrimary: true) {
            self.interactor.serviceProvider.authenticationService.signOut()
            self.router.dismissModal(completion: nil)
            print("Delete tapped")
        }
        
        let cancelAction = ActionItem(title: "Cancel", image: nil, isPrimary: false) {
            self.router.dismiss(completion: nil)
        }
        
        router.showAlert(alertItem: AlertItem(title: "Log out", message: "Do you really want to log out of your account?", actions: [logOutAction, cancelAction]))
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
            logOut()
        }
    }
    
    func didTouchShowProfile() {
        router.showProfileDetails(serviceProvider: interactor.serviceProvider)
    }
}

extension ProfilePresenter: ProfileDataSource {
    var user: IVUser? {
        interactor.serviceProvider.authenticationService.getCurrentUser()
    }
    
}

extension ProfilePresenter: ProfileInteractorDelegate {
}
