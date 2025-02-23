//
//  LayerProtocol.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 23/02/2025.
//

import Foundation

protocol LayerProtocol: Codable {
    var figmaId: String? { get }
    var id: String { get }
    var name: String { get }
    var coordinates: Coordinates { get set }
    var size: Size { get set }
    var editable: Bool { get }
    var type: LayerType { get }
    var rotation: Double? { get set }
}
