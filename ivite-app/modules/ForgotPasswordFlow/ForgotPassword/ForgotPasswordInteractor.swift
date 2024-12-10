protocol ForgotPasswordInteractorDelegate: AnyObject {
    func didSendForgetPasswordRequest(email: String, success: Bool, error: Error?)
}

final class ForgotPasswordInteractor: BaseInteractor {
    weak var delegate: ForgotPasswordInteractorDelegate?
    func sendForgetPasswordRequest(email: String) {
        Task {
            do {
                try await serviceProvider.authenticationService.sendPasswordReset(to: email)
                delegate?.didSendForgetPasswordRequest(email: email, success: true, error: nil)
            } catch {
                delegate?.didSendForgetPasswordRequest(email: email, success: false, error: error)
            }
        }
    }
}
