//
//  APIEndpointType.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 30/12/25.
//

import Foundation


protocol APIEndpointType {
    
    var baseURL : String { get }
    var versionURL : String { get }
    var path : String { get }
    var method : HTTPMethod { get }
    var parameter : APIParameter? { get }
    var headers: [String: String] { get }
    
}


struct APIEndpoint : APIEndpointType {
    var baseURL: String
    var versionURL: String
    var path: String
    var method: HTTPMethod
    var parameter: APIParameter?
    var headers: [String : String]
}
