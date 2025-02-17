//
//  Canvas.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 26/09/2024.
//

import UIKit
import CoreGraphics // optional, for CGFloat if desired

// MARK: - Protocol for Base Layer
protocol LayerProtocol: Codable {
    var figmaId: String? { get }       // Original Figma node ID
    var id: String { get }
    var name: String { get }
    var coordinates: Coordinates { get set }
    var size: Size { get set }
    var editable: Bool { get }
    var type: LayerType { get }
    var rotation: Double? { get set }  // rotation in degrees
}

// MARK: - Enum for Layer Type
enum LayerType: String, Codable {
    case text
    case image
    case shape
}

// MARK: - Coordinates & Size
struct Coordinates: Codable {
    var x: Double
    var y: Double
}

struct Size: Codable {
    var width: Double
    var height: Double
}

// MARK: - Text Layer
final class TextLayer: LayerProtocol {
    var figmaId: String?
    var id: String = UUID().uuidString
    
    let name: String
    var coordinates: Coordinates
    var size: Size
    let editable: Bool
    let type: LayerType = .text
    var rotation: Double?
    
    // Text-specific
    var textValue: String?
    var font: String?
    var fontSize: Double?
    /// Hex color, e.g. "#RRGGBBAA" or "#RRGGBB"
    var textColor: String?
    var textBoxCoordinates: TextBoxCoordinates?
    var textFormatting: TextFormatting?
    var textAlignment: TextAlignment?
    var letterSpacing: Double?
    var lineHeight: Double?
    
    init(
        figmaId: String? = nil,
        id: String = UUID().uuidString,
        name: String,
        coordinates: Coordinates,
        size: Size,
        editable: Bool,
        rotation: Double? = nil,
        textValue: String? = nil,
        font: String? = nil,
        fontSize: Double? = nil,
        textColor: String? = nil,
        textBoxCoordinates: TextBoxCoordinates? = nil,
        textFormatting: TextFormatting? = nil,
        textAlignment: TextAlignment? = nil,
        letterSpacing: Double? = nil,
        lineHeight: Double? = nil
    ) {
        self.figmaId = figmaId
        self.id = id
        self.name = name
        self.coordinates = coordinates
        self.size = size
        self.editable = editable
        self.rotation = rotation
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
        case figmaId = "figma_id"
        case name
        case coordinates
        case size
        case editable
        case type
        case rotation
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

// Optional NSCopying for duplication
extension TextLayer: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return TextLayer(
            figmaId: self.figmaId,
            id: self.id,
            name: self.name,
            coordinates: self.coordinates,
            size: self.size,
            editable: self.editable,
            rotation: self.rotation,
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

extension ImageLayer: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return ImageLayer(
            figmaId: self.figmaId,
            id: self.id,
            name: self.name,
            coordinates: self.coordinates,
            size: self.size,
            editable: self.editable,
            rotation: self.rotation,
            imageFile: self.imageFile,
            croppedSize: self.croppedSize,
            croppedCoordinates: self.croppedCoordinates
        )
    }
}

// MARK: - Shape Layer (New)
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

extension ShapeLayer: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return ShapeLayer(
            figmaId: self.figmaId,
            id: self.id,
            name: self.name,
            coordinates: self.coordinates,
            size: self.size,
            editable: self.editable,
            rotation: self.rotation,
            backgroundColor: self.backgroundColor,
            cornerRadius: self.cornerRadius
        )
    }
}

// MARK: - Enum for Layer that handles Decoding
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

extension Layer {
    func encoded() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        return try JSONSerialization.jsonObject(with: data) as! [String: Any]
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
        return Canvas(
            size: self.size,
            numberOfLayers: self.numberOfLayers,
            content: self.content.map { $0.copy() }
        )
    }
}

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

// MARK: - Other Supporting Structures
struct TextBoxCoordinates: Codable {
    let x: Double
    let y: Double
    let width: Double
    let height: Double
}

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

enum TextAlignment: String, Codable {
    case left
    case right
    case center
    case justified
}

