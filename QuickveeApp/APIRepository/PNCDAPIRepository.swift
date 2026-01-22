//
//  PNCDAPIRepository.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 15/01/26.
//

import Foundation


protocol PNCDAPIRepositoryProtocol : AnyObject {
        
    var apiService: APIServiceType { get }

    
    func getDiscountsList(
        request : PNCDListVC.GetDiscountListRequest
    ) async throws ->  GetDiscountListResponse
    
    
    func updatePNCDState(
        request : PNCDListVC.UpdatePNCDStateRequest
    ) async throws -> GenericAPIResponse<PNCDListVC.UpdatePNCDStateResponse>
    
    
    func createOrEditPNCD(
        request : CreatePNCDVC.CreateOrEditPNCDRequest
    ) async throws -> CommonResponse
    
    
}


class PNCDAPIRepository : PNCDAPIRepositoryProtocol{
    
    var apiService: any APIServiceType
    
    init(apiService: any APIServiceType) {
        self.apiService = apiService
    }
    
    func getDiscountsList(
        request : PNCDListVC.GetDiscountListRequest
    ) async throws ->  GetDiscountListResponse {
        
        return try await apiService.getData(
            endpoint: API.PNCDEndpoint.getDiscountList(
                req: request
            ),
            responseType: GetDiscountListResponse.self,
        )
    }
    
    func updatePNCDState(
        request : PNCDListVC.UpdatePNCDStateRequest
    ) async throws -> GenericAPIResponse<PNCDListVC.UpdatePNCDStateResponse>
    
    {
        return try await apiService.getData(
            endpoint: API.PNCDEndpoint.updatePNCDState(req: request),
            responseType: GenericAPIResponse<PNCDListVC.UpdatePNCDStateResponse>.self
        )
    }
    
    
    func createOrEditPNCD(
        request : CreatePNCDVC.CreateOrEditPNCDRequest
    ) async throws -> CommonResponse
    {
        return try await apiService.getData(
            endpoint: API.PNCDEndpoint.addUpdatePNCD(req: request),
            responseType: CommonResponse.self
        )
    }
    
}
