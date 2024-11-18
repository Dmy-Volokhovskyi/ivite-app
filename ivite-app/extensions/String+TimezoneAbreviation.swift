//
//  String+TimezoneAbreviation.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 17/11/2024.
//

import Foundation

extension String {
    var timezoneShortAbbreviation: String {
        // Try to get the TimeZone from the identifier
        guard let timeZone = TimeZone(identifier: self) else {
            return "N/A" // Return a default placeholder if invalid
        }
        // Return the abbreviation or a fallback
        return timeZone.abbreviation() ?? "N/A"
    }
}
