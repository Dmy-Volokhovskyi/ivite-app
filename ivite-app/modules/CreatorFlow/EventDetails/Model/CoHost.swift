//
//  CoHost.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 26/02/2025.
//

import Foundation

struct CoHost: Codable {
    let id: String
    var name: String
    var email: String
    
    init(id: String = UUID().uuidString, name: String, email: String) {
        self.id = id
        self.name = name
        self.email = email
    }
}

extension CoHost {
    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "name": name,
            "email": email
        ]
    }
}

extension CoHost {
    static func fromDictionary(_ dictionary: [String: Any]) -> CoHost {
        return CoHost(
            id: dictionary["id"] as? String ?? UUID().uuidString,
            name: dictionary["name"] as? String ?? "Unknown",
            email: dictionary["email"] as? String ?? "Unknown"
        )
    }
}
