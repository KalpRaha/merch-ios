//
//  ConfigurationManager.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 02/01/26.
//


enum ConfigurationManager {
    
    enum Environment {
        case LOCAL
        case DEV
        case PROD
    }
    
    static var environment : Environment {
        
#if LocalTunnel
        Logger.log("Local")
        return .LOCAL
        
#elseif DEBUG
        Logger.log("Debug")
        return .DEV
        
#else
        Logger.log("Production")
        return .PROD
        
#endif
    }
    
    
}