//
//  Event+Dictionary.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 27/01/2025.
//

import Foundation

extension Event {
    
    // Convert `Event` to Firestore Dictionary
    func toDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw NSError(domain: "com.app.firestore", code: 400, userInfo: [NSLocalizedDescriptionKey: "Unable to encode Event to dictionary"])
        }
        return dictionary
    }
    
    // Create `Event` from Firestore Dictionary
    static func fromDictionary(_ dictionary: [String: Any]) throws -> Event {
        let data = try JSONSerialization.data(withJSONObject: dictionary)
        return try JSONDecoder().decode(Event.self, from: data)
    }
}
