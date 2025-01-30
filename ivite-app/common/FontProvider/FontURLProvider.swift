//
//  FontURLProvider.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 30/01/2025.
//

import Foundation

protocol FontURLProvider {
    func urlForFont(fontName: String) async throws -> URL?
}
