//
//  UserDefault.swift
//  salesforce-test
//
//  Created by Kevin van den Hoek on 20/07/2022.
//

import Foundation

@propertyWrapper
struct UserDefault<Value: Codable> {
    let key: String
    let defaultValue: Value
    var container: UserDefaults = .standard

    var wrappedValue: Value {
        get {
            if let existing: Value = container.getCodable(for: key) {
                return existing
            } else {
                container.setCodable(to: defaultValue, for: key)
                return defaultValue
            }
        }
        set { container.setCodable(to: newValue, for: key) }
    }

    var projectedValue: UserDefault<Value> {
        self
    }
}
