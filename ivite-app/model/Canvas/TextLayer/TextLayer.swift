//
//  TextLayer.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 23/02/2025.
//

import Foundation

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
    
    init(figmaId: String? = nil,
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
         lineHeight: Double? = nil) {
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

