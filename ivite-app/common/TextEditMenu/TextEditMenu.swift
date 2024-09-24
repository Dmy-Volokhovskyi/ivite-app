//
//  TextEditMenu.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 24/09/2024.
//

import UIKit

// Enum for the menu items
enum TextEditMenuItem {
    case editText
    case font
    case size
    case color
    case format
    case spacing

    // Computed property to return the image for each case
    var image: UIImage? {
        switch self {
        case .editText:
            return UIImage(systemName: "keyboard") // Replace with your custom image if needed
        case .font:
            return UIImage(systemName: "textformat") // Replace with custom image if needed
        case .size:
            return UIImage(systemName: "textformat.size") // Replace with your custom image if needed
        case .color:
            return UIImage(systemName: "paintbrush") // Replace with your custom image if needed
        case .format:
            return UIImage(systemName: "text.alignleft") // Replace with your custom image if needed
        case .spacing:
            return UIImage(systemName: "line.horizontal.3.decrease") // Replace with custom image if needed
        }
    }

    // Computed property to return the title for each case
    var title: String {
        switch self {
        case .editText:
            return "Edit Text"
        case .font:
            return "Font"
        case .size:
            return "Size"
        case .color:
            return "Color"
        case .format:
            return "Format"
        case .spacing:
            return "Spacing"
        }
    }
}
