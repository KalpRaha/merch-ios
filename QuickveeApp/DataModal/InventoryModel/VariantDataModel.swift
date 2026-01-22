//
//  VariantDataModel.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 09/01/26.
//

import Foundation

struct VariantDataModel : Decodable, Equatable {
    
    var id: String
    
    var productId: String?
    var productTitle: String?
    var productCostPerItem: String?
    var productUPC: String?
    var productPrice: String?
    
    var category: String?
    var quantity: String
    var customCode: String?
    var brand: String?
    var brandId: String?
    var tags: String?
    
    var variantId : String?
    var variantTitle : String?
    var variantPrice : String?
    var variantUpc : String?
    var variantCostPerItem: String?
    
    
    private var _isVarient: String
    var isLottery: String?
    var isDeleted: String?
    
    enum CodingKeys : String, CodingKey {
        case id

        case productId = "product_id"
        case productTitle = "title"
        case productCostPerItem = "costperItem"
        case productUPC = "upc"
        case productPrice = "price"
        
        case variantTitle = "variant"
        case variantId = "var_id"
        case variantPrice = "var_price"
        case variantUpc = "var_upc"
        case variantCostPerItem = "var_costperItem"

        case category = "cotegory"
        case quantity
        case customCode = "custom_code"
        case brand = "brand"
        case brandId = "brand_id"
        case tags
        
        
        case _isVarient = "isvarient"
        case isLottery = "is_lottery"
        
        case isDeleted = "is_deleted"
        
    }

    
    init(id: String, productId: String, productTitle: String, productCostPerItem: String, productUPC: String, productPrice: String, category: String, quantity: String, customCode: String, brand: String, brandId: String, tags: String, variantId: String? = nil, variantTitle: String? = nil, variantPrice: String? = nil, variantUpc: String? = nil, variantCostPerItem: String? = nil, _isVarient: String, isLottery: String, isDeleted: String) {
        self.id = id
        self.productId = productId
        self.productTitle = productTitle
        self.productCostPerItem = productCostPerItem
        self.productUPC = productUPC
        self.productPrice = productPrice
        self.category = category
        self.quantity = quantity
        self.customCode = customCode
        self.brand = brand
        self.brandId = brandId
        self.tags = tags
        self.variantId = variantId
        self.variantTitle = variantTitle
        self.variantPrice = variantPrice
        self.variantUpc = variantUpc
        self.variantCostPerItem = variantCostPerItem
        self._isVarient = _isVarient
        self.isLottery = isLottery
        self.isDeleted = isDeleted
    }
    
    func toInventoryVariant() -> InventoryVariant {
        InventoryVariant(
            id: id,
            costperItem: productCostPerItem ?? "",
            title: productTitle ?? "",
            isvarient: _isVarient,
            upc: productUPC ?? "",
            cotegory: category ?? "",
            var_id: "",
            var_upc: "",
            quantity: quantity,
            price: productPrice ?? "",
            custom_code: customCode ?? "",
            variant: "",
            var_price: "",
            is_lottery: isLottery ?? "",
            var_costperItem: "",
            brand: brand ?? "",
            brand_id: brandId ?? "",
            tags: tags ?? ""
        )
    }
    
}


extension VariantDataModel {
    
    var isVarient: Bool {
        _isVarient == "1" 
    }
    
    var itemId: String {
        (isVarient ? variantId : productId)  ?? ""
    }
    
}


extension InventoryVariant {
    
    func toVariantDataModel() -> VariantDataModel {
        VariantDataModel(
            id: id,
            
            productId: id,
            productTitle: title,
            productCostPerItem: costperItem,
            productUPC: upc,
            productPrice: price,
            
            category: cotegory,
            quantity: quantity,
            customCode: custom_code,
            brand: brand,
            brandId: brand_id,
            tags: tags,
            
            variantId: var_id.isEmpty ? nil : var_id,
            variantTitle: variant.isEmpty ? nil : variant,
            variantPrice: var_price.isEmpty ? nil : var_price,
            variantUpc: var_upc.isEmpty ? nil : var_upc,
            variantCostPerItem: var_costperItem.isEmpty ? nil : var_costperItem,
            
            _isVarient: isvarient,
            isLottery: is_lottery,
            isDeleted: "0" // default / adjust if you have a value
        )
    }
}

