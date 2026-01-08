//
//  ProductAndCategoryDiscountType.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 08/01/26.
//

import Foundation

enum ProductAndCategoryDiscountType {
    
    case product
    case category
    
    mutating func toggle(){
        self = switch self {
        case .product : .category
        case .category : .product
        }
    }
    
}
