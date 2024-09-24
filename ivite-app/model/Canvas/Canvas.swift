//
//  Canvas.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 26/09/2024.
//

import Foundation

// MARK: - Protocol for Base Layer
protocol LayerProtocol: Codable {
    var id: String { get }
    var name: String { get }
    var coordinates: Coordinates { get }
    var size: Size { get }
    var editable: Bool { get }
    var type: LayerType { get }
}

// MARK: - Enum for Layer Type
enum LayerType: String, Codable {
    case text
    case image
}

// MARK: - Text Layer
final class TextLayer: LayerProtocol {
    var id: String = UUID().uuidString
    let name: String
    var coordinates: Coordinates
    var size: Size
    let editable: Bool
    let type: LayerType = .text
    var textValue: String?
    var font: String?
    var fontSize: Double?
    var textColor: String?
    var textBoxCoordinates: TextBoxCoordinates?
    var textFormatting: TextFormatting?
    var textAlignment: TextAlignment?
    var letterSpacing: Double?
    var lineHeight: Double?
    
    init(id: String, name: String, coordinates: Coordinates, size: Size, editable: Bool, textValue: String? = nil, font: String? = nil, fontSize: Double? = nil, textColor: String? = nil, textBoxCoordinates: TextBoxCoordinates? = nil, textFormatting: TextFormatting? = nil, textAlignment: TextAlignment? = nil, letterSpacing: Double? = nil, lineHeight: Double? = nil) {
        self.id = id
        self.name = name
        self.coordinates = coordinates
        self.size = size
        self.editable = editable
        self.textValue = textValue
        self.font = font
        self.fontSize = fontSize
        self.textColor = textColor
        self.textBoxCoordinates = textBoxCoordinates
        self.textFormatting = textFormatting
        self.textAlignment = textAlignment
        self.letterSpacing = letterSpacing
        self.lineHeight = lineHeight
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case coordinates
        case size
        case editable
        case type
        case textValue = "text_value"
        case font
        case fontSize = "font_size"
        case textColor = "text_color"
        case textBoxCoordinates = "text_box_coordinates"
        case textFormatting = "text_formatting"
        case textAlignment = "text_alignment"
        case letterSpacing = "letter_spacing"
        case lineHeight = "line_height"
    }
}
extension TextLayer {
    func copy() -> TextLayer {
        return TextLayer(
            id: self.id,
            name: self.name,
            coordinates: self.coordinates,
            size: self.size,
            editable: self.editable,
            textValue: self.textValue,
            font: self.font,
            fontSize: self.fontSize,
            textColor: self.textColor,
            textBoxCoordinates: self.textBoxCoordinates,
            textFormatting: self.textFormatting,
            textAlignment: self.textAlignment,
            letterSpacing: self.letterSpacing,
            lineHeight: self.lineHeight
        )
    }
}



// MARK: - Image Layer
final class ImageLayer: LayerProtocol {
    var id: String = UUID().uuidString
    let name: String
    var coordinates: Coordinates
    var size: Size
    let editable: Bool
    let type: LayerType = .image
    var imageFile: String?
    var croppedSize: Size?
    var croppedCoordinates: Coordinates?
    
    enum CodingKeys: String, CodingKey {
        case name
        case coordinates
        case size
        case editable
        case type
        case imageFile = "image_file"
        case croppedSize = "cropped_size"
        case croppedCoordinates = "cropped_coordinates"
    }
    
    init(id: String,
         name: String,
         coordinates: Coordinates,
         size: Size,
         editable: Bool,
         imageFile: String? = nil,
         croppedSize: Size? = nil,
         croppedCoordinates: Coordinates? = nil) {
        self.id = id
        self.name = name
        self.coordinates = coordinates
        self.size = size
        self.editable = editable
        self.imageFile = imageFile
        self.croppedSize = croppedSize
        self.croppedCoordinates = croppedCoordinates
    }
}

extension ImageLayer {
    func copy() -> ImageLayer {
        return ImageLayer(
            id: self.id,
            name: self.name,
            coordinates: self.coordinates,
            size: self.size,
            editable: self.editable,
            imageFile: self.imageFile,
            croppedSize: self.croppedSize,
            croppedCoordinates: self.croppedCoordinates
        )
    }
}

// MARK: - Enum for Layer that handles Decoding
enum Layer: Codable {
    case text(TextLayer)
    case image(ImageLayer)
    
    enum CodingKeys: String, CodingKey {
        case type
    }
    
    var id: String {
        switch self {
        case .text(let textLayer):
            return textLayer.id
        case .image(let imageLayer):
            return imageLayer.id
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(LayerType.self, forKey: .type)
        
        switch type {
        case .text:
            let textLayer = try TextLayer(from: decoder)
            self = .text(textLayer)
        case .image:
            let imageLayer = try ImageLayer(from: decoder)
            self = .image(imageLayer)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        switch self {
        case .text(let textLayer):
            try textLayer.encode(to: encoder)
        case .image(let imageLayer):
            try imageLayer.encode(to: encoder)
        }
    }
}

extension Layer {
    func copy() -> Layer {
        switch self {
        case .text(let textLayer):
            return Layer.text(textLayer.copy())
        case .image(let imageLayer):
            return Layer.image(imageLayer.copy())
        }
    }
}


// MARK: - Canvas Model
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

extension Canvas {
    func copy() -> Canvas {
        return Canvas(size: self.size, numberOfLayers: self.numberOfLayers, content: self.content.map { $0.copy() })
    }
}


// MARK: - Other Supporting Structures
struct Coordinates: Codable {
    let x: Int
    let y: Int
}

struct TextBoxCoordinates: Codable {
    let x: Double
    let y: Double
    let width: Double
    let height: Double
}

struct Size: Codable {
    let width: Int
    let height: Int
}

// MARK: - Enum for Text Formatting
enum TextFormatting: String, Codable {
    case allCaps = "all_caps"
    case allLowercase = "all_lowercase"
    case capitalized
    case none
}

// MARK: - Enum for Text Alignment
enum TextAlignment: String, Codable {
    case left
    case right
    case center
    case justified
}

extension TextLayer: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = TextLayer(id: id, name: name, coordinates: coordinates, size: size, editable: editable, textValue: textValue, font: font, fontSize: fontSize, textColor: textColor, textBoxCoordinates: textBoxCoordinates, textFormatting: textFormatting, textAlignment: textAlignment, letterSpacing: letterSpacing, lineHeight: lineHeight)
        return copy
    }
}

extension ImageLayer: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = ImageLayer(id: id, name: name, coordinates: coordinates, size: size, editable: editable, imageFile: imageFile, croppedSize: croppedSize, croppedCoordinates: croppedCoordinates)
        return copy
    }
}

//extension Layer: NSCopying {
//    func copy(with zone: NSZone? = nil) -> Any {
//        switch self {
//        case .text(let textLayer):
//            return Layer.text(textLayer.copy() as! TextLayer)
//        case .image(let imageLayer):
//            return Layer.image(imageLayer.copy() as! ImageLayer)
//        }
//    }
//}
//
//extension Canvas: NSCopying {
//    func copy(with zone: NSZone? = nil) -> Any {
//        return Canvas(size: size, numberOfLayers: numberOfLayers, content: content.map { $0.copy() as! Layer })
//    }
//}
