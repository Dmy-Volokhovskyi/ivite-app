import Foundation

protocol ProfileDetailsViewInterface: AnyObject {
    func update(_ user: IVUser)
    func clearPasswordChange()
}

final class ProfileDetailsPresenter: BasePresenter {
    private let interactor: ProfileDetailsInteractor
    let router: ProfileDetailsRouter
    weak var viewInterface: ProfileDetailsController?
    
    init(router: ProfileDetailsRouter, interactor: ProfileDetailsInteractor) {
        self.router = router
        self.interactor = interactor
        
        print(interactor.serviceProvider.authenticationService.provider)
    }
    
    func deleteAccount() {
    }
    
    private func handlePasswordChange() {
        
    }
}

extension ProfileDetailsPresenter: ProfileDetailsEventHandler {
    func viewWillAppear() {
        viewInterface?.update(interactor.currentUser)
    }
    
    func changeEmail(newEmail: String, confirmPassword: String) {
        guard let currentEmail = user?.email else { return }
        Task {
            do {
                let message = try await interactor.serviceProvider
                    .authenticationService
                    .updateEmail(oldEmail: currentEmail, password: confirmPassword, newEmail: newEmail)
                print(message)
            } catch {
                print("Failed to update email: \(error.localizedDescription)")
            }
        }
    }
    
    func changePassword(oldPassword: String, newPassword: String) {
        interactor.changePassword(oldPassword: oldPassword, newPassword: newPassword)
    }
    
    func didTouchDeleteAccount() {
        let deleteAction = ActionItem(title: "Delete", image: nil, isPrimary: true) { [weak self] in
            guard let self = self else { return }
            
//            Task {
//                do {
//                    try await self.interactor.serviceProvider.authenticationService.deleteAccount(email: <#String#>, password: <#String#>)
//                    self.router.dismiss(completion: nil) // Navigate away or dismiss on success
//                } catch {
//                    let errorMessage = (error as NSError).localizedDescription
//                    self.router.showSystemAlert(title: "Error", message: errorMessage, global: true)
//                }
//            }
        }
        
        let cancelAction = ActionItem(title: "Cancel", image: nil, isPrimary: false) {
            self.router.dismiss(completion: nil)
        }
        
        router.showAlert(alertItem: AlertItem(
            title: "Delete Account",
            message: "Do you really want to delete your account?",
            actions: [deleteAction, cancelAction]
        ))
    }
}

extension ProfileDetailsPresenter: ProfileDetailsDataSource {
    var user: IVUser? {
        interactor.currentUser
    }
    
    var authProvider: AuthenticationProvider {
        interactor.serviceProvider.authenticationService.provider
    }
}

extension ProfileDetailsPresenter: ProfileDetailsInteractorDelegate {
    func didUpdatePassword() {
        viewInterface?.clearPasswordChange()
        router.showSystemAlert(title: "Sucess", message: "Your password was updated")
    }
    
    func failedToUpdatePassword(with error: any Error) {
        router.showSystemAlert(title: "Failed to update password:", message: error.localizedDescription)
    }
    
    func didFetchUser(_ user: IVUser) {
        viewInterface?.update(user)
    }
    
    func didFailToFetchUser(with error: String) {
    #warning("Come back to this later")
    }
}
