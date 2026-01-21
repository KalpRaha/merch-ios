//
//  PNCDEndpoint.swift
//  QuickveeApp
//
//  Created by Pallavi on 09/01/26.
//

import Foundation

extension API {
    
    enum PNCDEndpoint {
        
        case getDiscountList(req : PNCDListVC.GetDiscountListRequest)
        case updateDiscountEnableDisableStatus(req : PNCDListVC.UpdateDiscountEnableDisableStateRequest)
        case addUpdatePNCD(req: CreatePNCDVC.AddUpdatePNCDRequest)
        
    }
    
    
}

extension API.PNCDEndpoint: APIEndpointEnumType {
    
    var baseURL: String {
        APIConstant.baseURL
    }
    
    var versionURL: String {
        ""
    }
    
    func getEndpoint() -> any APIEndpointType {
        
        switch self {
            
        case .getDiscountList(let req):
            APIEndpoint(
                baseURL: baseURL,
                versionURL: versionURL,
                path: "Product_category_discount/get_discounts_list",
                method: .POST,
                parameter: .multipart(req),
                headers: defaultHeaders
            )
            
        case .updateDiscountEnableDisableStatus(let req):
            APIEndpoint(
                baseURL: baseURL,
                versionURL: versionURL,
                path: "Product_category_discount/deal_status",
                method: .POST,
                parameter: .multipart(req),
                headers: defaultHeaders
            )
   
        case .addUpdatePNCD(let req):
            APIEndpoint(
                baseURL: baseURL,
                versionURL: versionURL,
                path: "Product_category_discount/add_update_discount",
                method: .POST,
                parameter: .multipart(req),
                headers: defaultHeaders
            )
            
        }
        
    }
    
}
