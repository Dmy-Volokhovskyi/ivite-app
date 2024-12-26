//
//  User.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 28/10/2024.
//

import UIKit
import FirebaseFirestore

struct IVUser: Codable {
    var userId: String
    var firstName: String
    var email: String
    var profileImageURL: String?  // Optional URL for profile image
    var createdAt: Date           // Timestamp of account creation
    var remainingInvites: Int     // Default to 10 invites
    var isPremium: Bool           // Indicates if the user is a premium user
    
    // Convert the user to a Firestore-compatible dictionary
    func toDictionary() -> [String: Any] {
        var data: [String: Any] = [
            "userId": userId,
            "firstName": firstName,
            "email": email,
            "createdAt": Timestamp(date: createdAt),
            "remainingInvites": remainingInvites,
            "isPremium": isPremium
        ]
        if let profileImageURL = profileImageURL {
            data["profileImageURL"] = profileImageURL
        }
        return data
    }
}
