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
    var members: [ContactCardModel] // Array of references to contacts
    
    init(name: String, members: [ContactCardModel] = []) {
        self.id = UUID().uuidString
        self.name = name
        self.members = members
    }
    
    func addMember(_ contact: ContactCardModel) {
        if !members.contains(where: { $0.id == contact.id }) {
            members.append(contact)
            contact.addGroup(self) // Update the contact's groups
        }
    }
    
    func removeMember(by id: String) {
        if let index = members.firstIndex(where: { $0.id == id }) {
            members[index].removeGroup(self) // Update the contact's groups
            members.remove(at: index)
        }
    }
}
