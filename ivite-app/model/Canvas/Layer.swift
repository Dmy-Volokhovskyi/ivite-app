//
//  Layer.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 23/02/2025.
//

import Foundation

enum Layer: Codable {
    case text(TextLayer)
    case image(ImageLayer)
    case shape(ShapeLayer)

    enum CodingKeys: String, CodingKey {
        case type
    }

    var id: String {
        switch self {
        case .text(let textLayer):
            return textLayer.id
        case .image(let imageLayer):
            return imageLayer.id
        case .shape(let shapeLayer):
            return shapeLayer.id
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let t = try container.decode(LayerType.self, forKey: .type)
        switch t {
        case .text:
            let textLayer = try TextLayer(from: decoder)
            self = .text(textLayer)
        case .image:
            let imageLayer = try ImageLayer(from: decoder)
            self = .image(imageLayer)
        case .shape:
            let shapeLayer = try ShapeLayer(from: decoder)
            self = .shape(shapeLayer)
        }
    }

    func encode(to encoder: Encoder) throws {
        switch self {
        case .text(let textLayer):
            try textLayer.encode(to: encoder)
        case .image(let imageLayer):
            try imageLayer.encode(to: encoder)
        case .shape(let shapeLayer):
            try shapeLayer.encode(to: encoder)
        }
    }
}
