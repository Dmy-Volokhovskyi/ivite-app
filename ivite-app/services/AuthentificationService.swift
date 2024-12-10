//
//  AuthentificationService.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 24/10/2024.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import UIKit

enum AuthenticationProvider: Codable {
    case google
    case firebase
    case unknown
}

enum AuthenticationState {
    case unauthenticated
    case authenticating
    case authenticated
}

enum AuthenticationFlow {
    case login
    case signUp
}

final class AuthenticationService {

    private let userDefaultsService: UserDefaultsService
    
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    var provider: AuthenticationProvider = .unknown {
        didSet {
            saveAuthProvider()
        }
    }
    
    var isSignedIn: Bool {
        return authenticationState == .authenticated
    }
    
    var flow: AuthenticationFlow = .login {
        didSet {
            validateFields()
        }
    }
    
    var isValid: Bool = false {
        didSet {
            NotificationCenter.default.post(name: .validationStateDidChange, object: nil)
        }
    }
    
    var authenticationState: AuthenticationState = .unauthenticated {
           didSet {
               NotificationCenter.default.post(
                   name: .authStateDidChange,
                   object: nil,
                   userInfo: ["authState": authenticationState]
               )
           }
       }
    
    var errorMessage: String = ""
    var user: User?
    var displayName: String = ""
    
    private var authStateHandler: AuthStateDidChangeListenerHandle?

    init(userDefaultsService: UserDefaultsService) {
        self.userDefaultsService = userDefaultsService
        self.provider = loadAuthProvider()
        registerAuthStateHandler()
    }
    
    func registerAuthStateHandler() {
        if authStateHandler == nil {
            authStateHandler = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
                guard let self = self else { return }
                self.user = user
                self.authenticationState = user == nil ? .unauthenticated : .authenticated
                self.displayName = user?.email ?? ""
            }
        }
    }
    
    func switchFlow() {
        flow = flow == .login ? .signUp : .login
        errorMessage = ""
    }
    
    func reset() {
        flow = .login
        email = ""
        password = ""
        confirmPassword = ""
    }
    
    private func validateFields() {
        isValid = flow == .login
            ? !(email.isEmpty || password.isEmpty)
            : !(email.isEmpty || password.isEmpty || confirmPassword.isEmpty)
    }
    
    func signInWithEmailPassword(email: String, password: String) async throws -> User {
        print("Attempting to sign in with email: \(email)")
        authenticationState = .authenticating
        
        do {
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            self.authenticationState = .authenticated
            self.user = authResult.user
            print("Sign-in successful for email: \(email)")
            print("User ID: \(authResult.user.uid)")
            return authResult.user
        } catch let error as NSError {
            self.authenticationState = .unauthenticated
            self.errorMessage = error.localizedDescription
            print("Sign-in failed for email: \(email). Error: \(error.localizedDescription)")
            throw mapAuthError(error)
        }
    }

    func signUpWithEmailPassword(email: String, password: String) async throws -> User {
        print("Starting sign-up process with email: \(email)")
        authenticationState = .authenticating
        
        do {
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            self.authenticationState = .authenticated
            self.user = authResult.user
            print("Sign-up successful for email: \(email)")
            print("User ID: \(authResult.user.uid)")
            return authResult.user
        } catch let error as NSError {
            self.authenticationState = .unauthenticated
            self.errorMessage = error.localizedDescription
            print("Sign-up failed for email: \(email). Error: \(error.localizedDescription)")
            throw mapAuthError(error)
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            authenticationState = .unauthenticated
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func updateEmail(oldEmail: String, password: String, newEmail: String) async throws -> String {
        guard let user = Auth.auth().currentUser, user.email == oldEmail else {
            throw NSError(domain: "com.app.auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "Old email does not match the authenticated user's email."])
        }
        
        // Reauthenticate the user with old email and password
        let credential = EmailAuthProvider.credential(withEmail: oldEmail, password: password)
        try await user.reauthenticate(with: credential)
        
        // Send verification email to the new email address
        try await user.sendEmailVerification(beforeUpdatingEmail: newEmail)
        return "Verification email sent to \(newEmail). Please check your inbox to confirm the email change."
    }

    func updatePassword(oldEmail: String, currentPassword: String, newPassword: String) async throws {
        guard let user = Auth.auth().currentUser, user.email == oldEmail else {
            throw NSError(domain: "com.app.auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "Old email does not match the authenticated user's email."])
        }
        
        // Reauthenticate the user with old email and current password
        let credential = EmailAuthProvider.credential(withEmail: oldEmail, password: currentPassword)
        try await user.reauthenticate(with: credential)
        
        // Update the password to the new one
        try await user.updatePassword(to: newPassword)
    }
    
    func getCurrentUser() -> IVUser? {
        // Use Auth.auth().currentUser to get the current authenticated user
        guard let user = Auth.auth().currentUser else {
            return nil
        }
        
        // Retrieve basic information from the Firebase `User` object
        let firstName = user.displayName ?? "Unknown"
        let email = user.email
        let userId = user.uid
        let profileImageURL = user.photoURL // URL to use with SDWebImage
        
        // Construct and return `IVUser` with all available data
        return IVUser(
            firstName: firstName,
            profileImageURL: profileImageURL,
            email: email,
            lastName: nil, // Firebase User doesn't include last name by default
            userId: userId
        )
    }
    
    private func saveAuthProvider() {
        userDefaultsService.save(provider, for: .authProvider)
    }
    
    // Load the provider from UserDefaults
    private func loadAuthProvider() -> AuthenticationProvider {
        return userDefaultsService.get(AuthenticationProvider.self, for: .authProvider) ?? .unknown
    }

}

// Define custom notifications
extension Notification.Name {
    static let authStateDidChange = Notification.Name("authStateDidChange")
    static let validationStateDidChange = Notification.Name("validationStateDidChange")
}

// Google Sign-In extension
extension AuthenticationService {
    func signInWithGoogle(presentingViewController: UIViewController, completion: @escaping (Bool) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            fatalError("No client ID found in Firebase configuration")
        }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { [weak self] signInResult, error in
            guard let self = self else { return }
            if let error = error {
                self.errorMessage = error.localizedDescription
                completion(false)
                return
            }
            
            guard let userAuthentication = signInResult?.user,
                  let idToken = userAuthentication.idToken else {
                self.errorMessage = "Google Sign-In failed"
                completion(false)
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
                                                           accessToken: userAuthentication.accessToken.tokenString)
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    completion(false)
                } else {
                    self.provider = .google
                    self.authenticationState = .authenticated
                    completion(true)
                }
            }
        }
    }
}

extension AuthenticationService {
    func sendPasswordReset(to email: String) async throws {
        guard !email.isEmpty else {
            throw NSError(
                domain: "com.app.auth",
                code: 400,
                userInfo: [NSLocalizedDescriptionKey: "Email cannot be empty."]
            )
        }
        
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        } catch let error as NSError {
            self.errorMessage = error.localizedDescription
            throw error
        }
    }
}
