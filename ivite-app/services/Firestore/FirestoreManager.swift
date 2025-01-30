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
    case templates = "templates"
}

final class FirestoreManager {
    let db: Firestore
    let userDefaultsService: UserDefaultsService
    
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
        let snapshot = try await db.collection(FirestoreCollection.templates.rawValue).getDocuments()
        
        let templates: [Template] = snapshot.documents.compactMap { document in
            guard let id = document["id"] as? String,
                  let name = document["name"] as? String,
                  let detailsURL = document["detailsURL"] as? String,
                  let prefabricatedImage = document["prefabricatedImage"] as? String,
                  let categoryString = document["category"] as? String,
                  let category = TemplateCategory(rawValue: categoryString.capitalizeFirstLetter()) else {
                print("Error parsing document with ID: \(document.documentID)")
                return nil
            }
            
            return Template(
                id: id,
                name: name,
                detailsURL: detailsURL,
                prefabricatedImage: prefabricatedImage,
                category: category
            )
        }
        
        return templates
    }
}

extension FirestoreManager {
    
    // CREATE or UPDATE a single ContactCardModel for a user
    func createOrUpdateContact(userId: String, contact: ContactCardModel) async throws {
        let contactRef = db.collection(FirestoreCollection.users.rawValue)
            .document(userId)
            .collection("contacts")
            .document(contact.id)
        
        try await contactRef.setData(contact.toDictionary(), merge: true)
    }
    
    // FETCH a single contact
    func fetchContact(userId: String, contactId: String) async throws -> ContactCardModel {
        let contactRef = db.collection(FirestoreCollection.users.rawValue)
            .document(userId)
            .collection("contacts")
            .document(contactId)
        
        let snapshot = try await contactRef.getDocument()
        guard let data = snapshot.data() else {
            throw NSError(domain: "com.app.firestore", code: 404, userInfo: [NSLocalizedDescriptionKey: "Contact not found"])
        }
        
        // Parse data
        let id     = data["id"] as? String ?? snapshot.documentID
        let name   = data["name"] as? String ?? ""
        let email  = data["email"] as? String ?? ""
        let phone  = data["phone"] as? String ?? ""
        let groups = data["groupIds"] as? [String] ?? []
        
        let contact = ContactCardModel(id: id, name: name, email: email, phone: phone)
        contact.groupIds = groups
        return contact
    }
    
    // DELETE a contact
    func deleteContact(userId: String, contactId: String) async throws {
        let contactRef = db.collection(FirestoreCollection.users.rawValue)
            .document(userId)
            .collection("contacts")
            .document(contactId)
        
        try await contactRef.delete()
    }
    
    // FETCH all contacts for a user
    func fetchAllContacts(userId: String) async throws -> [ContactCardModel] {
        let contactsRef = db.collection(FirestoreCollection.users.rawValue)
            .document(userId)
            .collection("contacts")
        
        let snapshot = try await contactsRef.getDocuments()
        
        let contacts = snapshot.documents.compactMap { doc -> ContactCardModel? in
            guard let name  = doc["name"] as? String,
                  let email = doc["email"] as? String,
                  let phone = doc["phone"] as? String
            else { return nil }
            
            let id        = doc["id"] as? String ?? doc.documentID
            let groupIds  = doc["groupIds"] as? [String] ?? []
            let contact   = ContactCardModel(id: id, name: name, email: email, phone: phone)
            contact.groupIds = groupIds
            return contact
        }
        
        return contacts
    }
}

extension FirestoreManager {
    
    // CREATE a contact group
    func createGroup(for userId: String, group: ContactGroup) async throws {
        let groupRef = db.collection(FirestoreCollection.users.rawValue)
            .document(userId)
            .collection("contactGroups")
            .document(group.id)
        
        var data = group.toDictionary()
        data["createdAt"] = FieldValue.serverTimestamp()
        
        try await groupRef.setData(data)
        
        // Optionally, update each member’s contact doc to include this group’s ID
        for member in group.members {
            try await addGroupIdToContact(userId: userId, contactId: member.id, groupId: group.id)
        }
    }
    
    // UPDATE group name or members in Firestore
    // Typically you can re-save entire group doc with toDictionary(), or do partial updates.
    func updateGroup(for userId: String, group: ContactGroup) async throws {
        let groupRef = db.collection(FirestoreCollection.users.rawValue)
            .document(userId)
            .collection("contactGroups")
            .document(group.id)
        
        var data = group.toDictionary()
        data["updatedAt"] = FieldValue.serverTimestamp()
        
        try await groupRef.setData(data, merge: true)
        
        // You could also handle the member’s contact doc references if needed
        // (e.g., ensuring each contact has group.id in groupIds)
        for member in group.members {
            try await addGroupIdToContact(userId: userId, contactId: member.id, groupId: group.id)
        }
    }
    
    // FETCH one group
    func fetchGroup(for userId: String, groupId: String) async throws -> ContactGroup {
        let groupRef = db.collection(FirestoreCollection.users.rawValue)
            .document(userId)
            .collection("contactGroups")
            .document(groupId)
        
        let snapshot = try await groupRef.getDocument()
        guard let data = snapshot.data() else {
            throw NSError(domain: "com.app.firestore", code: 404, userInfo: [NSLocalizedDescriptionKey: "Group not found"])
        }
        
        let id = data["id"] as? String ?? snapshot.documentID
        let name = data["name"] as? String ?? "Untitled"
        let memberIds = data["members"] as? [String] ?? []
        
        // If you want to load full contact docs for each member:
        var members = [ContactCardModel]()
        for cid in memberIds {
            let contact = try await fetchContact(userId: userId, contactId: cid)
            members.append(contact)
        }
        
        let group = ContactGroup(name: name, members: members, id: id)
        return group
    }
    
    // FETCH all groups for a user
    func fetchAllGroups(for userId: String) async throws -> [ContactGroup] {
        let groupCollectionRef = db.collection(FirestoreCollection.users.rawValue)
            .document(userId)
            .collection("contactGroups")
        
        let snapshot = try await groupCollectionRef.getDocuments()
        
        // For each group, we load its data + optional member contacts
        var groups: [ContactGroup] = []
        
        for doc in snapshot.documents {
            let data = doc.data()
            let id = data["id"] as? String ?? doc.documentID
            let name = data["name"] as? String ?? "Untitled"
            let memberIds = data["members"] as? [String] ?? []
            
            // Load each member contact
            var members = [ContactCardModel]()
            for cid in memberIds {
                let contact = try await fetchContact(userId: userId, contactId: cid)
                members.append(contact)
            }
            
            let group = ContactGroup(name: name, members: members, id: id)
            groups.append(group)
        }
        
        return groups
    }
    
    // DELETE group
    func deleteGroup(for userId: String, groupId: String) async throws {
        let groupRef = db.collection(FirestoreCollection.users.rawValue)
            .document(userId)
            .collection("contactGroups")
            .document(groupId)
        
        // Before deleting, you might want to remove 'groupId' from each contact’s groupIds array:
        let group = try? await fetchGroup(for: userId, groupId: groupId)
        if let group = group {
            for contact in group.members {
                try await removeGroupIdFromContact(userId: userId, contactId: contact.id, groupId: groupId)
            }
        }
        
        try await groupRef.delete()
    }
}

extension FirestoreManager {
    
    // Add single contact to group
    func addMemberToGroup(userId: String, groupId: String, contactId: String) async throws {
        let groupRef = db.collection(FirestoreCollection.users.rawValue)
            .document(userId)
            .collection("contactGroups")
            .document(groupId)
        
        // Add contactId to the group's "members" array
        try await groupRef.updateData([
            "members": FieldValue.arrayUnion([contactId])
        ])
        
        // Also update the contact doc to include this group ID
        try await addGroupIdToContact(userId: userId, contactId: contactId, groupId: groupId)
    }
    
    // Remove single contact from group
    func removeMemberFromGroup(userId: String, groupId: String, contactId: String) async throws {
        let groupRef = db.collection(FirestoreCollection.users.rawValue)
            .document(userId)
            .collection("contactGroups")
            .document(groupId)
        
        // Remove contactId from the group's "members" array
        try await groupRef.updateData([
            "members": FieldValue.arrayRemove([contactId])
        ])
        
        // Also remove the group ID from the contact’s groupIds
        try await removeGroupIdFromContact(userId: userId, contactId: contactId, groupId: groupId)
    }
    
    // Utility: Add group ID to a contact’s groupIds array
    private func addGroupIdToContact(userId: String, contactId: String, groupId: String) async throws {
        let contactRef = db.collection(FirestoreCollection.users.rawValue)
            .document(userId)
            .collection("contacts")
            .document(contactId)
        
        try await contactRef.updateData([
            "groupIds": FieldValue.arrayUnion([groupId])
        ])
    }
    
    // Utility: Remove group ID from a contact’s groupIds array
    private func removeGroupIdFromContact(userId: String, contactId: String, groupId: String) async throws {
        let contactRef = db.collection(FirestoreCollection.users.rawValue)
            .document(userId)
            .collection("contacts")
            .document(contactId)
        
        try await contactRef.updateData([
            "groupIds": FieldValue.arrayRemove([groupId])
        ])
    }
}
