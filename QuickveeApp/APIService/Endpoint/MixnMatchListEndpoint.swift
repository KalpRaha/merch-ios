//
//  MixnMatchListEndpoint.swift
//  QuickveeApp
//
//  Created by Pallavi on 13/01/26.
//

import Foundation

extension API {
    
    enum MixnMatchListEndpoint {
        
        case MixnMatchList(reqBody : VariantListMultipartRequestBody)
        
    }
    
}


extension API.MixnMatchListEndpoint: APIEndpointEnumType {
    
    var baseURL: String {
        APIConstant.baseURL
    }
    
    var versionURL: String {
        ""
    }
    
    func getEndpoint() -> any APIEndpointType {
        
        switch self {
            
        case .MixnMatchList(let reqBody):
            APIEndpoint(
                baseURL: baseURL,
                versionURL: versionURL,
                path: "Mix_match_pricing_api/mix_match_pricing_list",
                method: .POST,
                parameter: .multipart(reqBody),
                headers: defaultHeaders
            )
            
        }
    }
    
    
}
