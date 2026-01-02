//
//  BuildConstants.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 02/01/26.
//

import Foundation


enum APIConstant {
    
    static var baseURL: String {
        do {
            return try BuildConfiguration.value(for: "BASE_URL")
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
}
