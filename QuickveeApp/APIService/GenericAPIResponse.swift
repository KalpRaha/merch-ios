//
//  GenericAPIResponse.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 30/12/25.
//

import Foundation


struct GenericAPIResponse<T: Decodable> : Decodable {
    
    let status : Bool
    let message : String
    let result : T?
    
    enum CodingKeys: String, CodingKey {
        case status
        case message = "msg"
        case result
    }
    
}
