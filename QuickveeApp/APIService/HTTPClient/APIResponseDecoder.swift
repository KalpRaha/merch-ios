//
//  APIResponseDecoder.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 30/12/25.
//

import Foundation


class APIResponseDecoder {
    
    let jsonDecoder : JSONDecoder
    
    init(jsonDecoder: JSONDecoder) {
        self.jsonDecoder = jsonDecoder
    }
    
    func decode<T:Decodable>(type : T.Type, from data: Data) throws -> T{
        try jsonDecoder.decode(T.self, from: data)
    }
    
}
