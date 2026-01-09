//
//  VariantListEndpoint.swift
//  QuickveeApp
//
//  Created by Pallavi on 09/01/26.
//

import Foundation

extension  API {
    
    enum  VariantListEndpoint{
        
        case variantList
        
    }
    
    
}

extension API.VariantListEndpoint: APIEndpointEnumType {
    
    var baseURL: String {
        APIConstant.baseURL
    }
    
    var versionURL: String {
        ""
    }
    
    func getEndpoint() -> any APIEndpointType {
        switch self {
        case .variantList:
            APIEndpoint(
                baseURL: baseURL,
                versionURL: versionURL,
                path: "Productapi/variant_list",
                method: .POST,
                parameter: .json(["merchant_id": UDHelper.shared.merchantId]),
                headers: defaultHeaders
            )
        }
    }
    
}



