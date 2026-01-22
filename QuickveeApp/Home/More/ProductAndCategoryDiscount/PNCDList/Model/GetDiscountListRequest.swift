//
//  GetDiscountListRequest.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 15/01/26.
//

import Foundation


extension PNCDListVC {
    
    struct GetDiscountListRequest {
        
        var boundary: String = UUID().uuidString
        
        var merchantId : String
        var searchQuery : String?
        var page : String?
        var limit : String?
        
        init(
            merchantId: String = UDHelper.shared.merchantId,
            searchQuery: String? = nil,
            page: String? = nil,
            limit: String? = nil
        ) {
            self.merchantId = merchantId
            self.searchQuery = searchQuery
            self.page = page
            self.limit = limit
        }
        
    }

}


extension PNCDListVC.GetDiscountListRequest : MultiPartRequestBodyType{

    func buildMultiPartBodyBuilder() -> MultipartFormDataBodyBuilder {
        var entries: [MultipartFormDataEntry] = [
            .string(paramName: "merchant_id", value: merchantId)
        ]

        if let searchQuery {
            entries.append(.string(paramName: "search_term", value: searchQuery))
        }
        
        if let page{
            entries.append(.string(paramName: "page", value: page))
        }
        
        if let limit{
            entries.append(.string(paramName: "limit", value: limit))
        }
        
        return MultipartFormDataBodyBuilder(
            boundary: boundary,
            entries: entries
        )
    }
    
}

