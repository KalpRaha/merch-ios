//
//  CommonResponse.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 16/01/26.
//

import Foundation

struct CommonResponse : Decodable {
    
    var status : Bool
    var message : String
    
    enum CodingKeys : String, CodingKey {
        case status
        case message = "msg"
    }
    
}
