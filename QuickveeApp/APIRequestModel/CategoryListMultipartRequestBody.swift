//
//  CategoryListMultipartRequestBody.swift
//  QuickveeApp
//
//  Created by Pallavi on 13/01/26.
//

import Foundation


struct CategoryListMultipartRequestBody: MultiPartRequestBodyType {

    var merchantId: String
    let boundary: String = UUID().uuidString
    
    init(
        merchantId: String
    ) {
        self.merchantId = merchantId
    }
    

    func buildMultiPartBodyBuilder() -> MultipartFormDataBodyBuilder {

        let entries: [MultipartFormDataEntry] = [
            .string(paramName: "merchant_id", value: merchantId)
        ]

        return MultipartFormDataBodyBuilder(
            boundary: boundary,
            entries: entries
        )
    }
}
