//
//  UpdatePNCDStateRequest.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 15/01/26.
//

import Foundation


extension PNCDListVC {
    
    struct UpdatePNCDStateRequest{
        
        var boundary: String = UUID().uuidString
        
        var merchantId : String
        var pncdID : String
        var status : Bool
        var enableAll : Bool
        
        
        init(
            merchantId: String = UDHelper.shared.merchantId,
            pncdID: String,
            status: Bool,
            enableAll: Bool = false
        ) {
            self.merchantId = merchantId
            self.pncdID = pncdID
            self.status = status
            self.enableAll = enableAll
        }
        
    }
    
}

extension PNCDListVC.UpdatePNCDStateRequest : MultiPartRequestBodyType {
    
    func buildMultiPartBodyBuilder() -> MultipartFormDataBodyBuilder {
        let entries: [MultipartFormDataEntry] = [
            .string(paramName: "merchant_id", value: merchantId),
            .string(paramName: "id", value: pncdID),
            .string(paramName: "status", value: status.toString()),
            .string(paramName: "enableAll", value: enableAll.toString())
            
        ]
        return MultipartFormDataBodyBuilder(
            boundary: boundary,
            entries: entries
        )
    }
    
}
