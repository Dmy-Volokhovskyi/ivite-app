//
//  Canvas.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 26/09/2024.
//

import Foundation

struct Canvas: Codable {
    let size: Size
    let numberOfLayers: Int
    var content: [Layer]

    enum CodingKeys: String, CodingKey {
        case size
        case numberOfLayers = "number_of_layers"
        case content
    }
}
