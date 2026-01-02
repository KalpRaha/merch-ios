//
//  BuildConfiguration.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 02/01/26.
//

import Foundation


enum BuildConfiguration {
    
    enum Error: Swift.Error {
        case missingkey, invalidValue
    }
    
    static func value<T: LosslessStringConvertible>(for key: String) throws -> T{
        guard let object = Bundle.main.object(forInfoDictionaryKey: key) else {
            throw Error.missingkey
        }
        
        switch object {
        case let string as String:
            guard let value = T(string) else { fallthrough }
            return value
        default:
            throw Error.invalidValue
        }
    }
    
    
}
