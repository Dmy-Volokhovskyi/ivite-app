//
//  ImageLayer+Copying.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 23/02/2025.
//

import Foundation

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

