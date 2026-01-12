//
//  MultiPartRequestBodyType.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 12/01/26.
//

import Foundation


public protocol MultiPartRequestBodyType: Encodable {
    
    var boundary: String { get }
    func buildMultiPartBodyBuilder() -> MultipartFormDataBodyBuilder
    
}
