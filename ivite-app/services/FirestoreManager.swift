//
//  FirestoreManager.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 15/12/2024.
//


import FirebaseFirestore
import FirebaseAuth

enum FirestoreCollection: String {
    case users = "users"
    case events = "events"
}

final class FirestoreManager {
    private let db: Firestore
    private let userDefaultsService: UserDefaultsService
    
    init(db: Firestore, userDefaultsService: UserDefaultsService) {
        self.db = db
        self.userDefaultsService = userDefaultsService
    }
    
    // MARK: - Fetch User
    func fetchUser(uid: String) async throws -> IVUser {
        let docRef = db.collection(FirestoreCollection.users.rawValue).document(uid)
        let snapshot = try await docRef.getDocument()
        guard let data = snapshot.data() else {
            throw NSError(domain: "com.app.firestore", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not found"])
        }
        
        guard let firstName = data["firstName"] as? String,
              let email = data["email"] as? String,
              let createdAtTimestamp = data["createdAt"] as? Timestamp,
              let remainingInvites = data["remainingInvites"] as? Int,
              let isPremium = data["isPremium"] as? Bool else {
            throw NSError(domain: "com.app.firestore", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid user data."])
        }
        
        let profileImageURL = data["profileImageURL"] as? String
        let user = IVUser(
            userId: uid,
            firstName: firstName,
            email: email,
            profileImageURL: profileImageURL,
            createdAt: createdAtTimestamp.dateValue(),
            remainingInvites: remainingInvites,
            isPremium: isPremium
        )
        
        userDefaultsService.saveUser(user)
        return user
    }
    
    // MARK: - Create or Update User
    func createUser(_ user: IVUser) async throws {
        guard db.collection(FirestoreCollection.users.rawValue).document(user.userId) != nil else {
            throw NSError(domain: "com.app.firestore", code: 400, userInfo: [NSLocalizedDescriptionKey: "User ID is missing or invalid."])
        }
        
        var docData = user.toDictionary()
        docData["createdAt"] = FieldValue.serverTimestamp() // Add creation timestamp
        
        try await db.collection(FirestoreCollection.users.rawValue).document(user.userId).setData(docData)
    }
    
    // Update an existing user in Firestore
    func updateUser(_ user: IVUser) async throws {
        var docData = user.toDictionary()
        docData["updatedAt"] = FieldValue.serverTimestamp() // Add updated timestamp
        
        try await db.collection(FirestoreCollection.users.rawValue).document(user.userId).setData(docData, merge: true)
    }
    
    // MARK: - Delete User
    func deleteUser(uid: String) async throws {
        try await db.collection(FirestoreCollection.users.rawValue).document(uid).delete()
    }
}

extension FirestoreManager {
    func fetchTemplates() async throws -> [Template] {
        let snapshot = try await db.collection("templates").getDocuments()
        
        let templates: [Template] = snapshot.documents.compactMap { document in
            guard let id = document["id"] as? String,
                  let name = document["name"] as? String,
                  let detailsURL = document["detailsURL"] as? String,
                  let prefabricatedImage = document["prefabricatedImage"] as? String,
                  let type = document["type"] as? String,
                  let categoryString = document["type"] as? String,
                  let category = TemplateCategory(rawValue: categoryString) else {
                print("Error parsing document with ID: \(document.documentID)")
                return nil
            }
            
            return Template(
                id: id,
                name: name,
                detailsURL: detailsURL,
                prefabricatedImage: prefabricatedImage,
                type: type,
                category: category
            )
        }
        
        return templates
    }
}

