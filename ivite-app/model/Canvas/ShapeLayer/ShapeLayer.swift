//
//  ShapeLayer.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 23/02/2025.
//

import Foundation

final class ShapeLayer: LayerProtocol {
    var figmaId: String?
    var id: String = UUID().uuidString

    let name: String
    var coordinates: Coordinates
    var size: Size
    let editable: Bool
    let type: LayerType = .shape
    var rotation: Double?

    /// e.g. "#RRGGBBAA" or nil
    var backgroundColor: String?
    /// Corner radius if uniform. If corners are different, you might store an array or just the average.
    var cornerRadius: Double?

    enum CodingKeys: String, CodingKey {
        case figmaId = "figma_id"
        case id
        case name
        case coordinates
        case size
        case editable
        case type
        case rotation
        case backgroundColor = "background_color"
        case cornerRadius = "corner_radius"
    }

    init(
        figmaId: String? = nil,
        id: String = UUID().uuidString,
        name: String,
        coordinates: Coordinates,
        size: Size,
        editable: Bool,
        rotation: Double? = nil,
        backgroundColor: String? = nil,
        cornerRadius: Double? = nil
    ) {
        self.figmaId = figmaId
        self.id = id
        self.name = name
        self.coordinates = coordinates
        self.size = size
        self.editable = editable
        self.rotation = rotation
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
    }
}
