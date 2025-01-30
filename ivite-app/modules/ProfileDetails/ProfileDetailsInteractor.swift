import UIKit

protocol ProfileDetailsInteractorDelegate: AnyObject {
    func didFetchUser(_ user: IVUser)
    func didFailToFetchUser(with error: String)
    func didUpdatePassword()
    func failedToUpdatePassword(with error: Error)
}

final class ProfileDetailsInteractor: BaseInteractor {
    weak var delegate: ProfileDetailsInteractorDelegate?
    
    let currentUser: IVUser
    
    init(currentUser: IVUser, serviceProvider: ServiceProvider) {
        self.currentUser = currentUser
        super.init(serviceProvider: serviceProvider)
    }
    
    func fetchCurrentUser() async {
        guard let authUser = serviceProvider.authenticationService.getCurrentUser() else {
            delegate?.didFailToFetchUser(with: "No authenticated user found.")
            return
        }
        
        do {
            let user = try await serviceProvider.firestoreManager.fetchUser(uid: authUser.uid)
            delegate?.didFetchUser(user)
        } catch {
            delegate?.didFailToFetchUser(with: error.localizedDescription)
        }
    }
    
    func changePassword(oldPassword: String, newPassword: String) {
        Task {
            do {
                try await serviceProvider
                    .authenticationService
                    .updatePassword(oldEmail: currentUser.email.lowercased(),
                                    currentPassword: oldPassword,
                                    newPassword: newPassword)
                delegate?.didUpdatePassword()
            } catch {
                delegate?.failedToUpdatePassword(with: error)
            }
        }
    }
    
    func uploadProfileImage(_ image: UIImage) async throws -> String {
        let imagePath = "profile_images/\(currentUser.userId).jpg"
        return try await serviceProvider.firestoreManager.uploadImageToStorage(image: image, path: imagePath)
    }
    
    func updateUserProfileImage(_ newImageUrl: String) async {
        var updatedUser = currentUser
        updatedUser.profileImageURL = newImageUrl
        
        do {
            try await serviceProvider.firestoreManager.updateUser(updatedUser)
            delegate?.didFetchUser(updatedUser) // Notify Presenter about the updated user
        } catch {
            print("Failed to update user profile image: \(error.localizedDescription)")
        }
    }

}
