//
//  Utils.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 30/12/25.
//

import Foundation


enum APIParameter {
    
    case multipart(MultiPartRequestBodyType)
    
    case json(StringTOAnyDict)
    case customBody(Codable)
    case rawBody(Data)
    
}

enum HTTPMethod : String {
    case GET
    case POST
    case PUT
    case DELETE
}
