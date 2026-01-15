//
//  ProductAndCategoryItemIDExtractor.swift
//  QuickveeApp
//
//  Created by Pallavi on 14/01/26.
//

import Foundation

class ProductAndCategoryItemIDExtractor {
    
    static func extract(from text: String) -> [String] {
        guard let data = text.data(using: .utf8) else {
            return []
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data) as? [String:Any] ?? [:]
            
            var result: [String] = []
            
            for (productID, variantIDs) in json {
                result.append(productID)
                
                let filtered = (variantIDs as? [String] ?? []).filter({ $0.isEmpty == false })
                result.append(contentsOf: filtered)
            }
            
            return result
            
        } catch {
            Logger.log("Something went wrong")
            return []
        }
    }
    
}
