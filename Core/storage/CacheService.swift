//
//  CacheService.swift
//  project_Bank
//
//  Created by Slivets Margarita on 9.10.26.
//
import Foundation

protocol CacheServiceProtocol: AnyObject {
    func saveFavorites(_ codes: Set<String>)
    func loadFavorites() -> Set<String>
}

final class CacheService: CacheServiceProtocol {
    private let favoritesKey = "bank_app_favorite_currencies"
    private let defaults = UserDefaults.standard

    func saveFavorites(_ codes: Set<String>) {
        defaults.set(Array(codes), forKey: favoritesKey)
    }

    func loadFavorites() -> Set<String> {
        let array = defaults.stringArray(forKey: favoritesKey) ?? ["USD", "EUR", "CNY"]
        return Set(array)
    }
}
