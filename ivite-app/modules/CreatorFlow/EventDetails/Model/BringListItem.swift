//
//  BringListItem.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 26/02/2025.
//

import Foundation

struct BringListItem: Codable {
    let id: String
    var name: String?
    var count: Int?
    
    init(id: String = UUID().uuidString, name: String? = nil, count: Int? = nil) {
        self.id = id
        self.name = name
        self.count = count
    }
}

extension BringListItem {
    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "name": name ?? NSNull(),
            "count": count ?? NSNull()
        ]
    }
}

extension BringListItem {
    static func fromDictionary(_ dictionary: [String: Any]) -> BringListItem {
        return BringListItem(
            id: dictionary["id"] as? String ?? UUID().uuidString,
            name: dictionary["name"] as? String,
            count: dictionary["count"] as? Int
        )
    }
}
