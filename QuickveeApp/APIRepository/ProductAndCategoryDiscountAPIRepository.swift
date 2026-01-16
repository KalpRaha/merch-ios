//
//  ProductAndCategoryDiscountAPIRepository.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 15/01/26.
//

import Foundation


protocol ProductAndCategoryDiscountAPIRepositoryProtocol : AnyObject {
        
    var apiService: APIServiceType { get }

    
    func getDiscountsList(
        request : PNCDListVC.GetDiscountListRequest
    ) async throws ->  GetDiscountListResponse
    
    
    func updateDiscountEnableDisableState(
        request : PNCDListVC.UpdateDiscountEnableDisableStateRequest
    ) async throws -> GenericAPIResponse<PNCDListVC.UpdateDiscountEnableDisableStateResponse>
    
    
    func addUpdateDiscount(
        request : CreatePNCDVC.AddUpdatePNCDRequest
    ) async throws -> CommonResponse
    
    
}


class ProductAndCategoryDiscountAPIRepository : ProductAndCategoryDiscountAPIRepositoryProtocol{
    
    var apiService: any APIServiceType
    
    init(apiService: any APIServiceType) {
        self.apiService = apiService
    }
    
    func getDiscountsList(
        request : PNCDListVC.GetDiscountListRequest
    ) async throws ->  GetDiscountListResponse {
        
        return try await apiService.getData(
            endpoint: API.ProductAndCategoryDiscountEndpoint.getDiscountList(
                req: request
            ),
            responseType: GetDiscountListResponse.self,
        )
    }
    
    func updateDiscountEnableDisableState(
        request : PNCDListVC.UpdateDiscountEnableDisableStateRequest
    ) async throws -> GenericAPIResponse<PNCDListVC.UpdateDiscountEnableDisableStateResponse>
    
    {
        return try await apiService.getData(
            endpoint: API.ProductAndCategoryDiscountEndpoint.updateDiscountEnableDisableStatus(req: request),
            responseType: GenericAPIResponse<PNCDListVC.UpdateDiscountEnableDisableStateResponse>.self
        )
    }
    
    
    func addUpdateDiscount(
        request : CreatePNCDVC.AddUpdatePNCDRequest
    ) async throws -> CommonResponse
    {
        return try await apiService.getData(
            endpoint: API.ProductAndCategoryDiscountEndpoint.addUpdatePNCD(req: request),
            responseType: CommonResponse.self
        )
    }
    
}
