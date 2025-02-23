//
//  TextLayer+Copying.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 23/02/2025.
//

import Foundation

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
