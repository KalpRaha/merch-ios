//
//  APIRequestMaker.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 30/12/25.
//

import Foundation

class APIRequestMaker {
    
    let encoder : JSONEncoder
    
    init(encoder: JSONEncoder) {
        self.encoder = encoder
    }
    
    func make(endpoint : APIEndpointType) throws -> URLRequest{
        
        let path = endpoint.baseURL + endpoint.versionURL + endpoint.path
        Logger.log("URL : \(path)")
        
        guard let url = URL(string: path) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        Logger.log("HTTPMethod : \(endpoint.method.rawValue)")
        
        for (k, v) in endpoint.headers {
            request.setValue(v, forHTTPHeaderField: k)
        }
        Logger.log("Header : \(endpoint.headers)")
        
        if let param = endpoint.parameter {
            request.httpBody = getBody(parameter: param)
        }
     
        return request
    }
    
    private func getBody(parameter : APIParameter) -> Data? {
        
        switch parameter {
        case .json(let stringTOAnyDict):
            Logger.log("ParamBody [JSON] : \(stringTOAnyDict)")
            if let jsonData = try? JSONSerialization.data(withJSONObject: stringTOAnyDict, options: []) {
                return jsonData
            }
            
        case .customBody(let codable):
            Logger.log("ParamBody [CustomBody] : \(codable)")
            if let codableData = try? encoder.encode(codable) {
                return codableData
            }
            
        case .rawBody(let data):
            Logger.log("ParamBody [Raw Data] : \(data)")
            return data
        }
        
        return nil
    }
    
    
}
