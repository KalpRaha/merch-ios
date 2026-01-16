//
//  ProductAndCategoryDiscountType.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 08/01/26.
//

import Foundation

enum ProductAndCategoryDiscountType : String {
    
    case product = "product"
    case category = "category"
    
    mutating func toggle(){
        self = switch self {
        case .product : .category
        case .category : .product
        }
    }
    
}

extension ProductAndCategoryDiscountType : Codable {
    
    enum CodingKeys : String, CodingKey {
        case product = "product"
        case category = "category"
    }
    
    func apiValue() -> String {
        switch self {
        case .product: return "product"
        case .category: return "category"
        }
    }
    
}

extension ProductAndCategoryDiscountType {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        // 1️⃣ Try String
        if let stringValue = try? container.decode(String.self) {
            if let value = Self.parse(stringValue) {
                self = value
                return
            }
        }
        
        // 2️⃣ Try Int
        if let intValue = try? container.decode(Int.self) {
            if let value = Self.parse(String(intValue)) {
                self = value
                return
            }
        }
        
        // 3️⃣ Fail only if truly invalid
        throw DecodingError.dataCorruptedError(
            in: container,
            debugDescription: "Invalid ProductAndCategoryDiscountType"
        )
    }
    
    static func parse(_ value : String? ) -> Self? {
        guard let value else { return nil }
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        return switch trimmed {
        case "product", "1": .product
        case "category", "2": .category
        case "", "0": nil
        default:
            // Try numeric in string form just in case
            switch Int(trimmed) {
            case 1: .product
            case 2: .category
            default: nil
            }
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var single = encoder.singleValueContainer()
        try single.encode(apiValue())
    }
    
}
