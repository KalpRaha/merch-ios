//
//  BogoListEndpoint.swift
//  QuickveeApp
//
//  Created by Pallavi on 13/01/26.
//

import Foundation

extension API {
    
    enum BogoListEndpoint{
        
        case bogoList(reqBody : VariantListMultipartRequestBody)
        
    }
    
}


extension API.BogoListEndpoint: APIEndpointEnumType {
    
    var baseURL: String {
        APIConstant.baseURL
    }
    
    var versionURL: String {
        ""
    }
    
    func getEndpoint() -> any APIEndpointType {
        
        switch self {
            
        case .bogoList(let reqBody):
            APIEndpoint(
                baseURL: baseURL,
                versionURL: versionURL,
                path: "Bogoapi/bogo_list",
                method: .POST,
                parameter: .multipart(reqBody),
                headers: defaultHeaders
            )
            
        }
    }
    
    
}
