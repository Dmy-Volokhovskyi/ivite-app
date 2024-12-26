import UIKit

protocol CreateAccountInteractorDelegate: AnyObject {
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func signInSuccessfully()
    func showAlert(title: String, message: String)
}

final class CreateAccountInteractor: BaseInteractor {
    weak var delegate: CreateAccountInteractorDelegate?
    
    func signUp(with name: String, email: String, password: String) async {
        delegate?.showLoadingIndicator()
        
        do {
            let authUser = try await serviceProvider.authenticationService.signUpWithEmailPassword(email: email, password: password)
            let newUser = IVUser(
                userId: authUser.uid,
                firstName: name,
                email: email,
                profileImageURL: nil,
                createdAt: Date(),
                remainingInvites: 0,
                isPremium: false
            )
            await handleNewUserCreation(newUser, successMessage: "Sign-Up Successful")
        } catch {
            delegate?.hideLoadingIndicator()
            delegate?.showAlert(title: "Sign-Up Failed", message: error.localizedDescription)
        }
    }
    
    func signUpWithGoogle(presentingViewController: UIViewController) async {
        delegate?.showLoadingIndicator()
        
        do {
            let authUser = try await serviceProvider.authenticationService.signInWithGoogle(presentingViewController: presentingViewController)
            let newUser = IVUser(
                userId: authUser.uid,
                firstName: authUser.displayName ?? "Unknown",
                email: authUser.email ?? "No Email",
                profileImageURL: authUser.photoURL?.absoluteString,
                createdAt: Date(),
                remainingInvites: 10,
                isPremium: false
            )
            await handleNewUserCreation(newUser, successMessage: "Google Sign-Up Successful")
        } catch {
            delegate?.hideLoadingIndicator()
            delegate?.showAlert(title: "Google Sign-Up Failed", message: error.localizedDescription)
        }
    }
    
    @MainActor
    private func handleNewUserCreation(_ user: IVUser, successMessage: String) async {
        do {
            try await serviceProvider.firestoreManager.createUser(user)
            delegate?.hideLoadingIndicator()
            delegate?.signInSuccessfully()
        } catch {
            delegate?.hideLoadingIndicator()
            delegate?.showAlert(title: successMessage, message: "Failed to save user: \(error.localizedDescription)")
        }
    }
}


