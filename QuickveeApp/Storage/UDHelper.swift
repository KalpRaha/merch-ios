//
//  UDHelper.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 31/12/25.
//

import Foundation

/*
    // make sure if you are, Using this Helper class then the specified key for UD must replace all the existing code of UserDefaults
 
    UserDefaults.standard.set(false, forKey: "LoggedIn")
    // replace the above line of code with
 
    UDHelper.isLoggedIn = false // where the key is set as isLoggedIn = "LoggedIn"
 
 */

class UDHelper {
    
    static var shared = UDHelper()
    private init() { }
    
    
    @Storage(key: .isLoggedIn, defaultValue: false)
    var isLoggedIn: Bool
    
    @Storage(key: .merchantId, defaultValue: "-111")
    var merchantId: String
    
    
    @Storage(key: .categoryListData, defaultValue: [])
    var categoryListData: [InventoryCategory]
    
    
    

    
}

extension UDHelper {
    
    
    enum Keys : String{
        
        case isLoggedIn = "LoggedIn"
        case merchantId = "merchant_id"
        
        case categoryListData
        
        
    }
    
}
