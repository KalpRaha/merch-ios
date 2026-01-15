//
//  CategoryListEndpoint.swift
//  QuickveeApp
//
//  Created by Pallavi on 13/01/26.
//

import Foundation

extension  API {
    
    enum  CategoryListEndpoint{
        
        case categoryList(reqBody : VariantListMultipartRequestBody)
        
    }
  
}


extension API.CategoryListEndpoint: APIEndpointEnumType {
    
    var baseURL: String {
        APIConstant.baseURL
    }
    
    var versionURL: String {
        ""
    }
    
    func getEndpoint() -> any APIEndpointType {
        switch self {
        case .categoryList(let reqBody):
            APIEndpoint(
                baseURL: baseURL,
                versionURL: versionURL,
                path: "Categoryapi/category_list",
                method: .POST,
                parameter: .multipart(reqBody),
                headers: defaultHeaders
            )
        }
    }

    
}




