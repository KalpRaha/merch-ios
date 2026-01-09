//
//  ProductAndCategoryDiscountEndpoint.swift
//  QuickveeApp
//
//  Created by Pallavi on 09/01/26.
//

import Foundation

extension  API {
    
    enum ProductAndCategoryDiscountEndpoint {
        
        
    }
    
    
}

extension API.ProductAndCategoryDiscountEndpoint: APIEndpointEnumType {
    
    var baseURL: String {
        APIConstant.baseURL
    }
    
    var versionURL: String {
        ""
    }
    
    func getEndpoint() -> any APIEndpointType {
        switch self {
        
        }
    }

}
