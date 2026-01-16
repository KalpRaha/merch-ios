//
//  UpdateDiscountEnableDisableStateRequest.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 15/01/26.
//

import Foundation


extension ProductAndCategoryDiscountListVC {
    
    struct UpdateDiscountEnableDisableStateRequest{
        
        var merchantId : String
        var pncdID : String
        var status : String
        var enableAll : Bool
        
        init(
            merchantId: String,
            pncdID: String,
            status: String,
            enableAll: Bool = false
        ) {
            self.merchantId = merchantId
            self.pncdID = pncdID
            self.status = status
            self.enableAll = enableAll
        }
        
    }
    
}

extension ProductAndCategoryDiscountListVC.UpdateDiscountEnableDisableStateRequest : MultiPartRequestBodyType {
    
    var boundary: String { UUID().uuidString }
    
    func buildMultiPartBodyBuilder() -> MultipartFormDataBodyBuilder {
        var entries: [MultipartFormDataEntry] = [
            .string(paramName: "merchant_id", value: merchantId),
            .string(paramName: "id", value: pncdID),
            .string(paramName: "status", value: status),
            .string(paramName: "enableAll", value: enableAll.toString())
            
        ]
        return MultipartFormDataBodyBuilder(
            boundary: boundary,
            entries: entries
        )
    }
    
}
