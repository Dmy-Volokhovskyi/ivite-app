protocol CreateAccountInteractorDelegate: AnyObject {
    func showAlert(title: String, message: String)
}

final class CreateAccountInteractor: BaseInteractor {
    weak var delegate: CreateAccountInteractorDelegate?
    
    func signUp(with email: String, password: String) async {
        do {
            let user = try await serviceProvider.authenticationService.signUpWithEmailPassword(email: email, password: password)
            print("Signed in successfully! User ID: \(user.uid)")
            // Navigate to the main screen or update UI
        } catch let error as AuthenticationError {
            delegate?.showAlert(title: "Sign-In Failed", message: error.localizedDescription)
        } catch {
            delegate?.showAlert(title: "Unexpected Error", message: error.localizedDescription)
        }
    }
}
