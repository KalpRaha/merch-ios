//
//  JSONContainer.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 31/12/25.
//

import Foundation

struct JSONContainer<T:Codable> : Codable{
    let value : T
}
