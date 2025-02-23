//
//  ImageLayer.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 23/02/2025.
//

import UIKit

final class ImageLayer: LayerProtocol {
    var figmaId: String?
    var id: String = UUID().uuidString

    let name: String
    var coordinates: Coordinates
    var size: Size
    let editable: Bool
    let type: LayerType = .image
    var rotation: Double?
    var backgroundColor: String?

    /// Store image as a URL string
    var imageFile: String?
    var customImage: UIImage?
    var croppedSize: Size?
    var croppedCoordinates: Coordinates?

    enum CodingKeys: String, CodingKey {
        case figmaId = "figma_id"
        case id
        case name
        case coordinates
        case size
        case editable
        case type
        case rotation
        case imageFile = "image_file"
        case croppedSize = "cropped_size"
        case croppedCoordinates = "cropped_coordinates"
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
        imageFile: String? = nil,
        croppedSize: Size? = nil,
        croppedCoordinates: Coordinates? = nil
    ) {
        self.figmaId = figmaId
        self.id = id
        self.name = name
        self.coordinates = coordinates
        self.size = size
        self.editable = editable
        self.rotation = rotation
        self.backgroundColor = backgroundColor
        self.imageFile = imageFile
        self.croppedSize = croppedSize
        self.croppedCoordinates = croppedCoordinates
    }
}
