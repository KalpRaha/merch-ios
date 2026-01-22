//
//  OtherExtension.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 15/01/26.
//

import Foundation

extension Bool {
    
    func toString() -> String{
        self ? "1" : "0"
    }
}

extension String {
    
    func toBool() -> Bool{
        Bool(self) ?? false
    }
    
    func isTrue() -> Bool{
        self == "1"
    }
}

extension Int {
    
    func toString() -> String{
        "\(self)"
    }
    
}
