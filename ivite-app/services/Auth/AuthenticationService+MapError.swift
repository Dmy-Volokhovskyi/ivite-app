//
//  AuthenticationService+MapError.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 07/12/2024.
//

import FirebaseAuth

extension AuthenticationService {
    func mapAuthError(_ error: NSError) -> AuthenticationError {
        guard let errorCode = AuthErrorCode(rawValue: error.code) else {
            return .unknownError(error.localizedDescription)
        }
        
        switch errorCode {
        case .invalidEmail:
            return .invalidEmail
        case .userNotFound:
            return .userNotFound
        case .wrongPassword:
            return .wrongPassword
        case .emailAlreadyInUse:
            return .emailAlreadyInUse
        case .weakPassword:
            return .weakPassword
        default:
            return .unknownError(error.localizedDescription)
        }
    }
}
