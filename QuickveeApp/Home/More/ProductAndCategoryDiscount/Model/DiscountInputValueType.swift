//
//  DiscountInputValueType.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 08/01/26.
//

import Foundation

enum DiscountInputValueType: String {
    
    // Align raw values with API payload: "1" => percent, "2" => amount
    case percentValue = "1"
    case amountValue = "2"
    
    var stringValue: String {
        switch self {
        case .percentValue: "%"
        case .amountValue: "$"
        }
    }
    
    mutating func toggle() {
        self = switch self {
        case .percentValue: .amountValue
        case .amountValue: .percentValue
        }
    }
}

extension DiscountInputValueType: Codable {
    
    // Keep existing API value mapping
    
    var apiValue : String {
        switch self {
        case .percentValue: "1"
        case .amountValue: "2"
        }
    }
    
    static func parse(_ type : String?) -> Self{
        return switch type {
        case Self.percentValue.apiValue: .percentValue
        case Self.amountValue.apiValue: .amountValue
        default: .percentValue
        }
    }
    
}

// This are the helper methods for only to get the UI update
extension DiscountInputValueType {
    
    func getIndex() -> Int {
        switch self {
        case .amountValue: 0
        case .percentValue: 1
        }
    }
    
    static func getFromIndex(_ index : Int) -> Self{
        switch index {
        case 0: .amountValue
        case 1: .percentValue
        default: .amountValue
        }
    }
    
}
