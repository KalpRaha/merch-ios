//
//  APIEndpointEnumType.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 30/12/25.
//

import Foundation

typealias StringTOAnyDict = [String:Any]


protocol APIEndpointEnumType {
    
    var baseURL : String { get }
    var versionURL : String { get }

    func getEndpoint() -> APIEndpointType
}


extension APIEndpointEnumType {
    
    var defaultHeaders : [String: String] {
        [
            "Accept":"application/json",
            "Content-Type": "application/json; charset=UTF-8"
        ]
    }
}
