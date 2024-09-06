//
//  UIFont+Inter.swift
//  ivite-app
//
//  Created by GoApps Developer on 03/09/2024.
//

import UIKit

extension UIFont {
    enum InterFontWeight: String {
        case regular = ""
        case thin = "_Thin"
        case extraLight = "_ExtraLight"
        case light = "_Light"
        case medium = "_Medium"
        case semiBold = "_SemiBold"
        case bold = "_Bold"
        case extraBold = "_ExtraBold"
        case black = "_Black"
    }
    
    static func interFont(ofSize size: CGFloat, weight: InterFontWeight = .regular, italic: Bool = false) -> UIFont {
        let fontName: String
        
        if italic {
            fontName = "Inter-Italic_\(weight.rawValue)-Italic"
        } else {
            fontName = "Inter-Regular\(weight.rawValue)"
        }
        
        for family in UIFont.familyNames {
            print("Font Family: \(family)")
            for name in UIFont.fontNames(forFamilyName: family) {
                print("   Font Name: \(name)")
            }
        }
        
        guard let font = UIFont(name: fontName, size: size) else {
            fatalError("Critical Error: Font \(fontName) not found. Make sure the font is added correctly.")
        }
        
        return font
    }
}
