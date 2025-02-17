//
//  Guest+ToDictionary.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 13/02/2025.
//

import Foundation

extension Guest {
    func toDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw NSError(domain: "com.app.firestore", code: 400, userInfo: [NSLocalizedDescriptionKey: "Unable to encode Guest to dictionary"])
        }
        return dictionary
    }
    // Convert Firestore Dictionary back to `Guest`
    static func fromDictionary(_ dictionary: [String: Any]) throws -> Guest {
        let data = try JSONSerialization.data(withJSONObject: dictionary)
        return try JSONDecoder().decode(Guest.self, from: data)
    }
}
