//
//  APIService.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 30/12/25.
//

import Foundation


class APIService : APIServiceType{
    
    var session : URLSession
    var requestMaker : APIRequestMaker
    var responseDecoder : APIResponseDecoder
    
    init(
        session: URLSession = .shared,
        requestMaker : APIRequestMaker,
        responseDecoder : APIResponseDecoder
    ) {
        self.session = session
        self.requestMaker = requestMaker
        self.responseDecoder = responseDecoder
    }
    
    func getData<T:Decodable>(
        endpoint: APIEndpointEnumType,
        responseType : T.Type
        
    ) async throws -> T{
        
        let endpointConfig = endpoint.getEndpoint()
        let request = try requestMaker.make(endpoint: endpointConfig)
        
        let (data, response) = try await session.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw APIError.invalidServerResponse
        }
        
        guard 200...299 ~= response.statusCode else {
            throw APIError.errorFromServer(
                statusCode: response.statusCode,
                data: data
            )
        }
        
        do {
            return try responseDecoder.decode(type: T.self, from: data)
            
        }catch let error {
            throw APIError.errorWhileDecoding(error)
        }
        
    }
    
    func cancelRequest() {
        session.invalidateAndCancel()
    }
    
}
