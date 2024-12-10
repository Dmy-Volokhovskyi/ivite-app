protocol CheckEmailInteractorDelegate: AnyObject {
    func didSendForgetPasswordRequest(email: String, success: Bool, error: Error?)
}

final class CheckEmailInteractor: BaseInteractor {
    weak var delegate: CheckEmailInteractorDelegate?
    
    let email: String
    
    init(email: String, serviceProvider: ServiceProvider) {
        self.email = email
        super.init(serviceProvider: serviceProvider)
    }
    
    func sendForgetPasswordRequest() {
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
