//
//  Favorites.swift
//  SnowSeeker
//
//  Created by Maks Winters on 13.09.2024.
//

import Foundation

@Observable
class Favorites {
    private var resorts: Set<String>
    private let key = "Favorites"
    
    init() {
        let defaults = UserDefaults.standard
        let decoder = JSONDecoder()
        let data = defaults.data(forKey: key)
        if let data = data {
            do {
                resorts = try decoder.decode(Set<String>.self, from: data)
            } catch {
                fatalError(error.localizedDescription)
            }
        } else {
            resorts = []
        }
    }
    
    func contains(_ resort: Resort) -> Bool {
        resorts.contains(resort.id)
    }
    
    func add(_ resort: Resort) {
        resorts.insert(resort.id)
        save()
    }
    
    func remove(_ resort: Resort) {
        resorts.remove(resort.id)
        save()
    }
    
    func save() {
        let defaults = UserDefaults.standard
        let encoder = JSONEncoder()
        do {
            let encoded = try encoder.encode(resorts)
            defaults.setValue(encoded, forKey: key)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
