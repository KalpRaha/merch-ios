//
//  MixnMatchDataModel.swift
//  QuickveeApp
//
//  Created by Pallavi on 14/01/26.
//

import Foundation

struct MixnMatchDataModelRes : Decodable {
    
    let status : Bool?
    let message : String?
    let result : [MixnMatchDataModel]
    
    enum CodingKeys: String, CodingKey {
        case status
        case message = "msg"
        case result = "data"
    }
    
}
    
struct MixnMatchDataModel: Codable {
    
    let id: String
    let merchantId: String?
    let dealName: String?
    let desc: String?
    let minQty: String?
    let isPercent: String?
    let discount : String?
    let isEnable: String?
    
    
    private let _itemsId: String?
    var itemIds: [String] {
        ProductAndCategoryItemIDExtractor.extract(from: _itemsId ?? "")
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        
        case merchantId = "merchant_id"
        case _itemsId = "items_id"
        case dealName = "deal_name"
        case desc = "desc"
        case  minQty = "min_qty"
        case isPercent = "is_percent"
        case discount = "discount"
        case isEnable = "is_enable"
    }
    
    
}
