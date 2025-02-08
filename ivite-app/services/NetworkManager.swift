//
//  NetworkManager.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 03/02/2025.
//


import Foundation

class NetworkManager {
    static let shared = NetworkManager()  // Singleton
    
    private init() {}
    
    func sendRequest(
        url: URL,
        method: String = "POST",
        headers: [String: String] = [:],
        body: Data?
    ) async throws {
        var request = URLRequest(url: url)
        request.httpMethod = method
        headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        request.httpBody = body
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 202 else {
            throw NSError(domain: "NetworkError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response from server"])
        }
    }
}

