//
//  Error+AuthError.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 03/12/2024.
//

import Foundation

enum AuthenticationError: Error, LocalizedError {
    case invalidEmail
    case userNotFound
    case wrongPassword
    case emailAlreadyInUse
    case weakPassword
    case unknownError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "The email address is invalid. Please enter a valid email."
        case .userNotFound:
            return "No account found with this email. Please check or sign up."
        case .wrongPassword:
            return "The password is incorrect. Please try again."
        case .emailAlreadyInUse:
            return "The email address is already in use by another account."
        case .weakPassword:
            return "The password is too weak. Please choose a stronger password."
        case .unknownError(let message):
            return message
        }
    }
}
