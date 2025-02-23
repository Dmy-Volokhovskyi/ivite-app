//
//  TextFormatting.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 23/02/2025.
//

import Foundation

enum TextFormatting: Codable {
    case allCaps
    case allLowercase
    case capitalized
    case none

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)

        switch rawValue.lowercased() {
        case "all_upper", "upper":
            self = .allCaps
        case "all_lower", "lower":
            self = .allLowercase
        case "capitalized":
            self = .capitalized
        case "none":
            self = .none
        default:
            self = .none  // or throw an error if you prefer strict mapping
        }
    }
}
