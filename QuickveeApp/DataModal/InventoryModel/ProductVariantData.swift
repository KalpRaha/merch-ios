//
//  ProductVariantData.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 09/01/26.
//

import Foundation

struct ProductVariantData : Decodable {
    
    var id: String
    var title: String
    var costPerItem: String
    
    var upc: String
    var category: String
    var quantity: String
    var price: String
    var customCode: String
    var brand: String
    var brandId: String
    var tags: String
    
    var isVarient: String
    var isLottery: String
    
    var isDeleted: String
    
    enum CodingKeys : String, CodingKey {
        case id
        case title
        case costPerItem = "costperItem"
        
        case upc
        case category = "cotegory"
        case quantity
        case price
        case customCode = "custom_code"
        case brand
        case brandId = "brand_id"
        case tags
        
        case isVarient = "isvarient"
        case isLottery = "is_lottery"
        
        case isDeleted = "is_deleted"
        
    }
    
    func toInventoryVariant() -> InventoryVariant {
        InventoryVariant(
            id: id,
            costperItem: costPerItem,
            title: title,
            isvarient: isVarient,
            upc: upc,
            cotegory: category,
            var_id: "",
            var_upc: "",
            quantity: quantity,
            price: price,
            custom_code: customCode,
            variant: "",
            var_price: "",
            is_lottery: isLottery,
            var_costperItem: "",
            brand: brand,
            brand_id: brandId,
            tags: tags
        )
    }
    
}
