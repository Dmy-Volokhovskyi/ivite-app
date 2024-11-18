//
//  Timezone+FormatedDescription.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 17/11/2024.
//

import Foundation

extension TimeZone {
    var formattedDescription: String {
        let seconds = secondsFromGMT()
        let hours = seconds / 3600
        let minutes = abs(seconds % 3600 / 60)
        let gmtString = String(format: "GMT%+03d:%02d", hours, minutes)
        let name = identifier.replacingOccurrences(of: "America/", with: "")
        return "(\(gmtString)) \(name)"
    }
}
