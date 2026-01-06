//
//  Storage.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 31/12/25.
//

import Foundation


@propertyWrapper
struct Storage<T : Codable> {
    
    private let key : String
    private let defaultValue: T
    private let userDefaults = UserDefaults.standard
    
    private let jsonEncoder : JSONEncoder
    private let jsonDecoder : JSONDecoder
    
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
        
        jsonEncoder = .init()
        jsonDecoder = .init()
    }
    
    init(key: UDHelper.Keys, defaultValue: T) {
        self.key = key.rawValue
        self.defaultValue = defaultValue
        
        jsonEncoder = .init()
        jsonDecoder = .init()
    }
    
    var wrappedValue: T {
        get {
            getData()
        }
        set {
            setData(newValue: newValue)
        }
    }
    
    private func encryptedKey() -> String{
        "Quickvee+Storage+\(key)"
    }
}

extension Storage {
    
    private func getData() -> T {
        if let data = userDefaults.value(forKey: encryptedKey()) as? Data {
            
            if let container = try? jsonDecoder.decode(JSONContainer<T>.self, from: data) {
                return container.value
                
            }else if let value = try? jsonDecoder.decode(T.self, from: data){
                setData(newValue: value)
                return value
            }
            
        }else if let value = userDefaults.value(forKey: key) as? T {
            setData(newValue: value)
            return value
        }
        return defaultValue
    }
    
    
    private func setData(newValue : T) {
        // Convert newValue to data
        let container = JSONContainer(value: newValue)
        let data = try? jsonEncoder.encode(container)
        
        // Set value to UserDefaults
        UserDefaults.standard.set(data, forKey: encryptedKey())
    }
}

