//
//  ContactGroup.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 29/11/2024.
//

import Foundation

class ContactGroup {
    let id: String
    var name: String
    var members: [ContactCardModel]
    
    // Overload the init to allow setting 'id' from Firestore or a new UUID.
    init(name: String, members: [ContactCardModel] = [], id: String? = nil) {
        self.id = id ?? UUID().uuidString
        self.name = name
        self.members = members
    }
    
    // Convert to Firestore dictionary. We store contact IDs in Firestore
    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "name": name,
            // Just store the contact IDs, *not* the full contact data
            "members": members.map { $0.id }
        ]
    }
    
    // Add or remove members in memory
    func addMember(_ contact: ContactCardModel) {
        guard !members.contains(where: { $0.id == contact.id }) else { return }
        members.append(contact)
        // Optionally update the contact’s groupIds as well
        if !contact.groupIds.contains(id) {
            contact.groupIds.append(id)
        }
    }
    
    func removeMember(by contactId: String) {
        guard let index = members.firstIndex(where: { $0.id == contactId }) else { return }
        let contact = members[index]
        members.remove(at: index)
        
        // Remove group from the contact’s groupIds
        contact.groupIds.removeAll(where: { $0 == id })
    }
}

