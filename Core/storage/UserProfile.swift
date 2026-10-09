//
//  UserProfile.swift
//  project_Bank
//
//  Created by Slivets Margarita on 9.10.26.
//

import Foundation

struct UserProfile: Codable {
    let fullName: String
    let phone: String
}

protocol ProfileStorageProtocol: AnyObject {
    func saveUser(_ profile: UserProfile)
    func getUser() -> UserProfile?
    func hasUser() -> Bool
}

final class ProfileStorage: ProfileStorageProtocol {
    private let key = "bank_current_user_profile"
    private let defaults = UserDefaults.standard
    
    func saveUser(_ profile: UserProfile) {
        if let data = try? JSONEncoder().encode(profile) {
            defaults.set(data, forKey: key)
        }
    }
    
    func getUser() -> UserProfile? {
        guard let data = defaults.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(UserProfile.self, from: data)
    }
    
    func hasUser() -> Bool {
        return getUser() != nil
    }
}
