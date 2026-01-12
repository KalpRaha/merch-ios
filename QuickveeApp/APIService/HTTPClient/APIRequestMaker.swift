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
        
        
        // Start with provided headers.
        setHeaders(request: &request, endpoint: endpoint)
        
        // Build body if any.
        if let param = endpoint.parameter {
            request.httpBody = getBody(parameter: param)
        }
     
        return request
    }
    
}


fileprivate extension APIRequestMaker {
    
    
    private func setHeaders(
        request: inout URLRequest,
        endpoint: APIEndpointType
    ) {
        for (k, v) in endpoint.headers {
            request.setValue(v, forHTTPHeaderField: k)
        }
        
        if case let .multipart(builder) = endpoint.parameter {
            request.setValue(
                "multipart/form-data; boundary=\(builder.boundary)",
                forHTTPHeaderField: "Content-Type"
            )
        }
        
        Logger.log("Header : \(request.allHTTPHeaderFields ?? [:])")
    }
    
    
    private func getBody(parameter : APIParameter) -> Data? {
        
        switch parameter {
            
        case .multipart(let builder):
            let data = builder.buildMultiPartBodyBuilder().build()
            Logger.log("ParamBody [Multipart] : \(data.count) bytes, boundary=\(builder.boundary)")
            return data
            
            
        case .json(let stringTOAnyDict):
            Logger.log("ParamBody [JSON] : \(stringTOAnyDict)")
            if let jsonData = try? JSONSerialization.data(withJSONObject: stringTOAnyDict) {
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
