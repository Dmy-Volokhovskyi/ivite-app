import UIKit
import FirebaseAuth

protocol SignInInteractorDelegate: AnyObject {
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func signInSuccessfully()
    func showAlert(title: String, message: String)
}

final class SignInInteractor: BaseInteractor {
    weak var delegate: SignInInteractorDelegate?
    
    func signIn(with email: String, password: String) async {
        delegate?.showLoadingIndicator()
        
        do {
            let authUser = try await serviceProvider.authenticationService.signInWithEmailPassword(email: email, password: password)
            await fetchUserFromFirestore(uid: authUser.uid)
        } catch {
            delegate?.hideLoadingIndicator()
            delegate?.showAlert(title: "Sign-In Failed", message: error.localizedDescription)
        }
    }
    
    @MainActor
    func signInWithGoogle(presentingViewController: UIViewController) async {
        delegate?.showLoadingIndicator()
        
        do {
            let authUser = try await serviceProvider.authenticationService.signInWithGoogle(presentingViewController: presentingViewController)
            await fetchUserFromFirestore(uid: authUser.uid)
        } catch {
            delegate?.hideLoadingIndicator()
            delegate?.showAlert(title: "Google Sign-In Failed", message: error.localizedDescription)
        }
    }
    
    @MainActor
    private func fetchUserFromFirestore(uid: String) async {
        do {
            let user = try await serviceProvider.firestoreManager.fetchUser(uid: uid)
            delegate?.hideLoadingIndicator()
            delegate?.signInSuccessfully()
        } catch {
            delegate?.hideLoadingIndicator()
            delegate?.showAlert(title: "Failed to Fetch User", message: error.localizedDescription)
        }
    }
}


