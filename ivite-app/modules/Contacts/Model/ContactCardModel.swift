//
//  ContactCardModel.swift
//  ivite-app
//
//  Created by GoApps Developer on 06/09/2024.
//

import Foundation
import Firebase

class ContactCardModel: Equatable {
    let id: String
    var name: String
    var email: String
    var phone: String
    var date: Date
    var groupIds: [String] // Array of group references
    
    init(id: String? = nil, name: String, email: String, phone: String, date: Date = Date(), groupIds: [String] = []) {
        self.id = id ?? UUID().uuidString
        self.name = name
        self.email = email
        self.phone = phone
        self.date = date
        self.groupIds = groupIds
    }
    
    // Convert to Firestore dictionary
    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "name": name,
            "email": email,
            "phone": phone,
            "date": Timestamp(date: date), // Convert `Date` to Firestore `Timestamp`
            "groupIds": groupIds
        ]
    }
    
    // Initialize from Firestore dictionary
    convenience init?(from dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String,
              let name = dictionary["name"] as? String,
              let email = dictionary["email"] as? String,
              let phone = dictionary["phone"] as? String,
              let timestamp = dictionary["date"] as? Timestamp,
              let groupIds = dictionary["groupIds"] as? [String] else {
            return nil
        }
        self.init(id: id, name: name, email: email, phone: phone, date: timestamp.dateValue(), groupIds: groupIds)
    }
    
    // Add a group ID
    func addGroupId(_ groupId: String) {
        if !groupIds.contains(groupId) {
            groupIds.append(groupId)
        }
    }
    
    // Remove a group ID
    func removeGroupId(_ groupId: String) {
        groupIds.removeAll { $0 == groupId }
    }
    
    // Equatable conformance
    static func == (lhs: ContactCardModel, rhs: ContactCardModel) -> Bool {
        return lhs.id == rhs.id
    }
}


