//
//  Event+Dictionary.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 27/01/2025.
//

import Foundation
import FirebaseCore

extension Event {
    func toDictionary() throws -> [String: Any] {
        return [
            "id": id,
            "title": title,
            "date": Timestamp(date: date ?? Date()),
            "timeZone": timeZone ?? NSNull(),
            "hostName": hostName ?? NSNull(),
            "coHosts": coHosts.map { try? $0.toDictionary() },
            "location": location ?? NSNull(),
            "city": city ?? NSNull(),
            "state": state ?? NSNull(),
            "zipCode": zipCode ?? NSNull(),
            "note": note ?? NSNull(),
            "isBringListActive": isBringListActive,
            "bringList": bringList.map { try? $0.toDictionary() },
            "status": status.rawValue,
            "canvas": try? canvas?.toDictionary(),
            "canvasImageURL": canvasImageURL ?? NSNull()
        ]
    }

    
    static func fromDictionary(_ dictionary: [String: Any]) -> Event? {
        guard let id = dictionary["id"] as? String,
              let title = dictionary["title"] as? String else { return nil }
        
        let date = (dictionary["date"] as? TimeInterval).flatMap { Date(timeIntervalSince1970: $0) }
        let timeZone = dictionary["timeZone"] as? String
        let hostName = dictionary["hostName"] as? String
        let location = dictionary["location"] as? String
        let city = dictionary["city"] as? String
        let state = dictionary["state"] as? String
        let zipCode = dictionary["zipCode"] as? String
        let note = dictionary["note"] as? String
        let isBringListActive = dictionary["isBringListActive"] as? Bool ?? false
        let canvasImageURL = dictionary["canvasImageURL"] as? String
        let status = (dictionary["status"] as? String).flatMap { EventStatus(rawValue: $0) } ?? .draft
        
        return Event(
            id: id,
            title: title,
            date: date,
            timeZone: timeZone,
            hostName: hostName,
            location: location,
            city: city,
            state: state,
            zipCode: zipCode,
            note: note,
            isBringListActive: isBringListActive,
            status: status,
            canvasImageURL: canvasImageURL
        )
    }
}
