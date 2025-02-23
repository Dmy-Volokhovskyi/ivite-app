//
//  Layer+Copying.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 23/02/2025.
//

import Foundation

extension Layer {
    func copy() -> Layer {
        switch self {
        case .text(let textLayer):
            return .text(textLayer.copy() as! TextLayer)
        case .image(let imageLayer):
            return .image(imageLayer.copy() as! ImageLayer)
        case .shape(let shapeLayer):
            return .shape(shapeLayer.copy() as! ShapeLayer)
        }
    }
}
