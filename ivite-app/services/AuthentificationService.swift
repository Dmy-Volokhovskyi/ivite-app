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

enum AuthenticationState {
    case unauthenticated
    case authenticating
    case authenticated
}

enum AuthenticationFlow {
    case login
    case signUp
}

class AuthenticationService {

    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    
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

    init() {
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
    
    func signInWithEmailPassword(completion: @escaping (Bool) -> Void) {
        authenticationState = .authenticating
        Auth.auth().signIn(withEmail: self.email, password: self.password) { [weak self] authResult, error in
            guard let self = self else { return }
            if let error = error {
                self.errorMessage = error.localizedDescription
                self.authenticationState = .unauthenticated
                completion(false)
            } else {
                self.authenticationState = .authenticated
                completion(true)
            }
        }
    }
    
    func signUpWithEmailPassword(completion: @escaping (Bool) -> Void) {
        authenticationState = .authenticating
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            if let error = error {
                self.errorMessage = error.localizedDescription
                self.authenticationState = .unauthenticated
                completion(false)
            } else {
                self.authenticationState = .authenticated
                completion(true)
            }
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
    
    func deleteAccount(completion: @escaping (Bool) -> Void) {
        user?.delete { [weak self] error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                completion(false)
            } else {
                completion(true)
            }
        }
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
            
            guard let userAuthentication = signInResult?.user else {
                self.errorMessage = "No Google user found."
                completion(false)
                return
            }
            
            guard let idToken = userAuthentication.idToken else {
                self.errorMessage = "ID token missing"
                completion(false)
                return
            }
            
            let accessToken = userAuthentication.accessToken
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
                                                           accessToken: accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    completion(false)
                } else {
                    self.authenticationState = .authenticated
                    completion(true)
                }
            }
        }
    }
}
