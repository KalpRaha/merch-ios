//
//  DiscountPerItemDiscountType.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 08/01/26.
//

import Foundation


enum DiscountPerItemDiscountType {
    
    case percentage
    case currencyValue
    
    var stringValue : String {
        switch self {
        case .percentage: "%"
        case .currencyValue: "$"
        }
    }
    
    mutating func toggle(){
        self = switch self {
        case .percentage : .currencyValue
        case .currencyValue : .percentage
        }
    }
    
}
