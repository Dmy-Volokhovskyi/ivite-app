//
//  CanvasResponse.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 25/09/2024.
//

import Foundation

//struct Canvas: Codable {
//    let size: Size
//    let numberOfLayers: Int
//    let content: [Layer]
//    
//    enum CodingKeys: String, CodingKey {
//        case size
//        case numberOfLayers = "number_of_layers"
//        case content
//    }
//}

struct CanvasResponse: Codable {
    let canvas: Canvas
}
