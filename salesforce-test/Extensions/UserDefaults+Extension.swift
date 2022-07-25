//
//  UserDefaults+Extension.swift
//  salesforce-test
//
//  Created by Kevin van den Hoek on 20/07/2022.
//

import Foundation

extension UserDefaults {
    
    func setCodable<T: Codable>(to newValue: T?, for key: String) {
        guard newValue != nil else {
            set(nil, forKey: key)
            return
        }
        let encoder = PropertyListEncoder()
        do {
            guard let item = newValue else { return }
            let data = try encoder.encode([item])
            set(data, forKey: key)
        } catch {
            print("\(#function) failed to encode \(T.self) because \(error.localizedDescription)")
        }
    }
    
    func getCodable<T: Codable>(for key: String) -> T? {
        guard let data = object(forKey: key) as? Data else {
            return nil
        }
        
        let decoder = PropertyListDecoder()
        do {
            return try decoder.decode([T].self, from: data).first
        } catch {
            print("\(#function) failed to decode to \(T.self) because \(error.localizedDescription)")
            return nil
        }
    }
}
