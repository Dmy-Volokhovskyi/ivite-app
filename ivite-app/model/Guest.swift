//
//  Guest.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 10/11/2024.
//

import Foundation

enum GuestStatus: String, Codable {
    case invited
    case confirmed
    case declined
    
    var stringValue: String {
        switch self {
        case .invited: return "Expected"
        case .confirmed: return "Is coming"
        case .declined: return "Won't come"
        }
    }
}

struct Guest: Equatable {
    let id: String
    var name: String
    var email: String
    var phone: String
    var status: GuestStatus = .invited
    
    init(id: String? = nil, name: String, email: String, phone: String, status: GuestStatus = .invited) {
        self.id = id ?? UUID().uuidString
        self.name = name
        self.email = email
        self.phone = phone
    }
    
    // Equatable conformance
    static func == (lhs: Guest, rhs: Guest) -> Bool {
        return lhs.id == rhs.id
    }
}
