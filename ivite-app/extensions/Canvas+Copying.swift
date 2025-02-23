//
//  Canvas+Copying.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 23/02/2025.
//

import Foundation

extension Canvas {
    func copy() -> Canvas {
        return Canvas(
            size: self.size,
            numberOfLayers: self.numberOfLayers,
            content: self.content.map { $0.copy() }
        )
    }
}
