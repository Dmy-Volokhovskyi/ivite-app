////
////  Layer.swift
////  ivite-app
////
////  Created by Max Volokhovskyi on 25/09/2024.
////
//
//import Foundation
//
//struct Layer: Codable {
//    let name: String
//    let coordinates: Coordinates
//    let size: Size
//    let editable: Bool
//    let type: String
//    let imageFile: String?
//    let textValue: String?
//    let font: String?
//    let fontSize: Double?
//    let textBoxCoordinates: TextBoxCoordinates?
//    let croppedSize: Size?
//    let croppedCoordinates: Coordinates?
//    
//    enum CodingKeys: String, CodingKey {
//        case name
//        case coordinates
//        case size
//        case editable
//        case type
//        case imageFile = "image_file"
//        case textValue = "text_value"
//        case font
//        case fontSize = "font_size"
//        case textBoxCoordinates = "text_box_coordinates"
//        case croppedSize = "cropped_size"
//        case croppedCoordinates = "cropped_coordinates"
//    }
//}
//
//struct Coordinates: Codable {
//    let x: Int
//    let y: Int
//}
//
//struct TextBoxCoordinates: Codable {
//    let x: Double
//    let y: Double
//    let width: Double
//    let height: Double
//}
//
//struct Size: Codable {
//    let width: Int
//    let height: Int
//}
