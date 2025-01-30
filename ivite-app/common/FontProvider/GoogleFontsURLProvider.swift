//
//  GoogleFontsURLProvider.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 30/01/2025.
//

import Foundation

struct GoogleFontsURLProvider: FontURLProvider {
    
    /// Fetch the `.ttf` URL for a font using the Google Fonts CSS endpoint
    func urlForFont(fontName: String) async throws -> URL? {
        let googleFontsBaseURL = "https://fonts.googleapis.com/css2?family="
        let encodedFontName = fontName.replacingOccurrences(of: " ", with: "+")
        
        guard let url = URL(string: "\(googleFontsBaseURL)\(encodedFontName)") else {
            return nil
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        // Extract `.ttf` URL from the returned CSS
        guard let cssString = String(data: data, encoding: .utf8),
              let match = cssString.range(of: #"https:\/\/fonts.gstatic.com\/s\/[^)]+\.ttf"#, options: .regularExpression) else {
            return nil
        }
        
        return URL(string: String(cssString[match]))
    }
}
