//
//  DiscountPerItemDiscountType.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 08/01/26.
//

import Foundation


enum DiscountPerItemDiscountType {
    
    case percentValue
    case amountValue
    
    var stringValue : String {
        switch self {
        case .percentValue: "%"
        case .amountValue: "$"
        }
    }
    
    mutating func toggle(){
        self = switch self {
        case .percentValue : .amountValue
        case .amountValue : .percentValue
        }
    }
    
}
