protocol ProfileInteractorDelegate: AnyObject {
    func didFetchUser(_ user: IVUser)
    func didFailToFetchUser(with error: String)
}

final class ProfileInteractor: BaseInteractor {
    weak var delegate: ProfileInteractorDelegate?
    
    var currentUser: IVUser?
    
    func fetchCurrentUser() async {
        guard let authUser = serviceProvider.authenticationService.getCurrentUser() else {
            delegate?.didFailToFetchUser(with: "No authenticated user found.")
            return
        }
        
        do {
            let user = try await serviceProvider.firestoreManager.fetchUser(uid: authUser.uid)
            currentUser = user
            delegate?.didFetchUser(user)
        } catch {
            delegate?.didFailToFetchUser(with: error.localizedDescription)
        }
    }
}
