//
//  DiscountPerItemDiscountType.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 08/01/26.
//

import Foundation


enum DiscountPerItemDiscountType {
    
    case percentValue
    case currencyValue
    
    var stringValue : String {
        switch self {
        case .percentValue: "%"
        case .currencyValue: "$"
        }
    }
    
    mutating func toggle(){
        self = switch self {
        case .percentValue : .currencyValue
        case .currencyValue : .percentValue
        }
    }
    
}
