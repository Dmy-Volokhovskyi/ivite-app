//
//  UIFont+Inter.swift
//  ivite-app
//
//  Created by GoApps Developer on 03/09/2024.
//

import UIKit

extension UIFont {
    enum InterFontWeight: String {
        case regular = "Regular"
        case thin = "Thin"
        case extraLight = "ExtraLight"
        case light = "Light"
        case medium = "Medium"
        case semiBold = "SemiBold"
        case bold = "Bold"
        case extraBold = "ExtraBold"
        case black = "Black"
    }
    
    static func interFont(ofSize size: CGFloat, weight: InterFontWeight = .regular, italic: Bool = false) -> UIFont {
        let fontName: String
        
        if italic {
            fontName = "Inter-Italic_\(weight.rawValue)-Italic"
        } else {
            fontName = "Inter-Regular_\(weight.rawValue)"
        }
        
        guard let font = UIFont(name: fontName, size: size) else {
            fatalError("Critical Error: Font \(fontName) not found. Make sure the font is added correctly.")
        }
        
        return font
    }
}
