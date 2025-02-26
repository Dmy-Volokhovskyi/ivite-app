//
//  FontManager.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 30/01/2025.
//


import Foundation
import UIKit
import CoreText

final class FontManager {
    private let urlProvider: FontURLProvider
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    private var registeredFonts: [String: String] = [:] // Cache: "Font Name" -> "PostScript Name"
    private var fontMapping: [String: String] = [:] // "Raw Font Name" -> "Corrected Font Name"
    
    init(urlProvider: FontURLProvider) {
        self.urlProvider = urlProvider
        self.cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        loadFontMapping()
    }
    
    /// Loads the font mapping from `font_mapping.json`
    private func loadFontMapping() {
        guard let url = Bundle.main.url(forResource: "font_mapping", withExtension: "json") else {
            print("⚠️ Font mapping file not found!")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decodedMapping = try JSONDecoder().decode([String: String].self, from: data)
            self.fontMapping = decodedMapping
            print("✅ Loaded font mapping:", fontMapping)
        } catch {
            print("❌ Failed to load font mapping:", error.localizedDescription)
        }
    }
    
    /// Fetches and registers multiple fonts if needed
    func fetchFontsIfNeeded(fontNames: [String]) async throws -> [String: String] {
        var fontMapping: [String: String] = [:]
        
        try await withThrowingTaskGroup(of: (String, String?).self) { group in
            for fontName in fontNames {
                group.addTask {
                    let cleanedFontName = self.cleanFontName(fontName)
                    let postScriptName = try await self.fetchFontIfNeeded(fontName: cleanedFontName)
                    return (cleanedFontName, postScriptName)
                }
            }
            
            for try await (fontName, postScriptName) in group {
                if let postScript = postScriptName {
                    fontMapping[fontName] = postScript
                }
            }
        }
        
        return fontMapping
    }
    
    /// Fetches a single font if needed, downloads it if missing
    func fetchFontIfNeeded(fontName: String) async throws -> String {
        if let postScript = registeredFonts[fontName] {
            return postScript
        }
        
        let fontFileURL = cacheDirectory.appendingPathComponent("\(fontName).ttf")
        if fileManager.fileExists(atPath: fontFileURL.path) {
            let data = try Data(contentsOf: fontFileURL)
            if let postScriptName = registerFont(from: data) {
                #warning("Registering font synchronously is not recommended")
                
                registeredFonts[fontName] = postScriptName
                return postScriptName
            }
        }
        
        guard let fontURL = try await urlProvider.urlForFont(fontName: fontName) else {
            throw NSError(domain: "com.app.fonts", code: 404, userInfo: [NSLocalizedDescriptionKey: "Font not found"])
        }
        
        let (tempFileURL, _) = try await URLSession.shared.download(from: fontURL)
        try fileManager.moveItem(at: tempFileURL, to: fontFileURL)
        
        let data = try Data(contentsOf: fontFileURL)
        guard let postScriptName = registerFont(from: data) else {
            throw NSError(domain: "com.app.fonts", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to register font"])
        }
        
        registeredFonts[fontName] = postScriptName
        return postScriptName
    }
    
    /// Registers a font dynamically with CoreText
    private func registerFont(from fontData: Data) -> String? {
        guard let provider = CGDataProvider(data: fontData as CFData),
              let cgFont = CGFont(provider) else {
            return nil
        }
        
        var error: Unmanaged<CFError>?
        if CTFontManagerRegisterGraphicsFont(cgFont, &error) {
            return cgFont.postScriptName as String?
        } else {
            print("Font registration failed:", error?.takeUnretainedValue().localizedDescription ?? "Unknown error")
            return nil
        }
    }
    
    /// Cleans and standardizes font names by checking the mapping
    func cleanFontName(_ font: String) -> String {
        if let mappedFont = fontMapping[font] {
            return mappedFont
        }
        
        let baseFont = font.components(separatedBy: "-").first ?? font
        let spacedFont = baseFont.replacingOccurrences(of: "([a-z])([A-Z])", with: "$1 $2", options: .regularExpression)
        
        return spacedFont
    }
}
