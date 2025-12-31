//
//  APIServiceType.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 30/12/25.
//

import Foundation


protocol APIServiceType {
    
    var session : URLSession { get }
    var requestMaker : APIRequestMaker { get }
    var responseDecoder : APIResponseDecoder { get }
    
    func getData<T:Decodable>(
        endpoint: APIEndpointEnumType,
        responseType : T.Type
        
    ) async throws -> T
    
    func cancelRequest()
    
}


class APIServiceFactory {
    
    static func make(
        encoder: JSONEncoder = .init(),
        jsonDecoder: JSONDecoder = .init()
        
    ) -> APIServiceType{
        
        return APIService(
            requestMaker: APIRequestMaker(encoder: encoder),
            responseDecoder: APIResponseDecoder(jsonDecoder: jsonDecoder)
        )
        
    }
    
}
