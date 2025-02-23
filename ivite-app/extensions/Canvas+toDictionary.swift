//
//  Canvas+toDictionary.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 23/02/2025.
//

import Foundation

extension Canvas {
    func toDictionary() throws -> [String: Any] {
        return [
            "size": [
                "width": size.width,
                "height": size.height
            ],
            "numberOfLayers": numberOfLayers,
            "content": try content.map { try $0.encoded() } // Convert Layer Enum to Dictionary
        ]
    }
}
