//
//  UserDefaultsService.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 07/12/2024.
//
import UIKit

enum UserDefaultsKeys: String {
    case authProvider
}

final class UserDefaultsService {
    private let defaults: UserDefaults
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
    
    // Save a value to UserDefaults
    func save<T: Codable>(_ value: T, for key: UserDefaultsKeys) {
        do {
            let data = try JSONEncoder().encode(value)
            defaults.set(data, forKey: key.rawValue)
        } catch {
            print("Failed to save value for key \(key.rawValue): \(error)")
        }
    }
    
    // Retrieve a value from UserDefaults
    func get<T: Codable>(_ type: T.Type, for key: UserDefaultsKeys) -> T? {
        guard let data = defaults.data(forKey: key.rawValue) else { return nil }
        do {
            return try JSONDecoder().decode(type, from: data)
        } catch {
            print("Failed to retrieve value for key \(key.rawValue): \(error)")
            return nil
        }
    }
    
    // Remove a value from UserDefaults
    func remove(for key: UserDefaultsKeys) {
        defaults.removeObject(forKey: key.rawValue)
    }
}
