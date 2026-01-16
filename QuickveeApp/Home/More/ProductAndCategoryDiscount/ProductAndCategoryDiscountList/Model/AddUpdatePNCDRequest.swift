//
//  AddUpdatePNCDRequest.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 15/01/26.
//

import Foundation


extension ProductAndCategoryDiscountListVC {
    
    struct AddUpdatePNCDRequest : Codable {
        var merchantId : String
    }
    
}


extension ProductAndCategoryDiscountListVC.AddUpdatePNCDRequest : MultiPartRequestBodyType{
    
    var boundary: String { UUID().uuidString }
    
    func buildMultiPartBodyBuilder() -> MultipartFormDataBodyBuilder {
        var entries: [MultipartFormDataEntry] = [
            .string(paramName: "merchant_id", value: merchantId)
        ]

        return MultipartFormDataBodyBuilder(
            boundary: boundary,
            entries: entries
        )
    }
    
    
    
}
