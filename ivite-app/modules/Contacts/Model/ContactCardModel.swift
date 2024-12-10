//
//  ContactCardModel.swift
//  ivite-app
//
//  Created by GoApps Developer on 06/09/2024.
//

import UIKit

class ContactCardModel: Equatable {
    let id: String
    var name: String
    var email: String
    var date: Date
    var groups: [ContactGroup] // Array of references to groups
    
    init(name: String, email: String, date: Date, groups: [ContactGroup] = []) {
        self.id = UUID().uuidString
        self.name = name
        self.email = email
        self.date = date
        self.groups = groups
    }
    
    func addGroup(_ group: ContactGroup) {
        if !groups.contains(where: { $0.id == group.id }) {
            groups.append(group)
        }
    }
    
    func removeGroup(_ group: ContactGroup) {
        groups.removeAll { $0.id == group.id }
    }
    
    static func == (lhs: ContactCardModel, rhs: ContactCardModel) -> Bool {
        lhs.id == rhs.id
    }
}
