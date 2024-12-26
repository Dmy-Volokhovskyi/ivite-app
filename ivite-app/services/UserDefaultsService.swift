//
//  UserDefaultsService.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 07/12/2024.
//
import UIKit

enum UserDefaultsKeys: String {
    case authProvider
    case currentUser
}

final class UserDefaultsService {
    private let defaults: UserDefaults
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func save<T: Codable>(_ value: T, for key: UserDefaultsKeys) {
        do {
            let data = try JSONEncoder().encode(value)
            defaults.set(data, forKey: key.rawValue)
        } catch {
            print("Failed to save value for key \(key.rawValue): \(error)")
        }
    }

    func get<T: Codable>(_ type: T.Type, for key: UserDefaultsKeys) -> T? {
        guard let data = defaults.data(forKey: key.rawValue) else { return nil }
        do {
            return try JSONDecoder().decode(type, from: data)
        } catch {
            print("Failed to retrieve value for key \(key.rawValue): \(error)")
            return nil
        }
    }

    func remove(for key: UserDefaultsKeys) {
        defaults.removeObject(forKey: key.rawValue)
    }
    
    // MARK: - Store User Data
    func saveUser(_ user: IVUser) {
        save(user, for: .currentUser)
    }
    
    // MARK: - Retrieve User Data
    func getUser() -> IVUser? {
        return get(IVUser.self, for: .currentUser)
    }
    
    // MARK: - Remove User Data
    func removeUser() {
        remove(for: .currentUser)
    }
}
