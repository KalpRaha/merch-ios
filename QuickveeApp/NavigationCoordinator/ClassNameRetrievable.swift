//
//  ClassNameRetrievable.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 30/12/25.
//

import Foundation

protocol ClassNameRetrievable {
    
    var className : String { get }
    static var className: String { get }
    
}

extension NSObject : ClassNameRetrievable {
    
    var className: String {
        return String(describing: type(of: self))
    }
    
    static var className: String {
        return String(describing: self)
    }
}
