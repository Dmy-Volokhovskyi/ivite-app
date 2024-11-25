//
//  Guest.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 10/11/2024.
//

import Foundation

struct Guest: Equatable {
    let id: String
    var name: String
    var email: String
    var phone: String

    init(name: String, email: String, phone: String) {
        self.id = UUID().uuidString
        self.name = name
        self.email = email
        self.phone = phone
    }

    // Equatable conformance
    static func == (lhs: Guest, rhs: Guest) -> Bool {
        return lhs.id == rhs.id
    }
}
