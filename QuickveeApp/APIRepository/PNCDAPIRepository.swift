//
//  PNCDAPIRepository.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 15/01/26.
//

import Foundation


protocol PNCDAPIRepositoryProtocol : AnyObject {
        
    var dataEnvironment: DataEnvironment { get }
    var apiService: APIServiceType { get }
    var mockDataService: PNCDListMockData { get }
    
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
    
    var dataEnvironment : DataEnvironment
    var apiService: any APIServiceType
    
    var mockDataService: PNCDListMockData
    
    init(
        dataEnvironment : DataEnvironment,
        apiService: any APIServiceType,
        mockDataService: PNCDListMockData
    ) {
        self.dataEnvironment = dataEnvironment
        self.apiService = apiService
        self.mockDataService = mockDataService
    }
    
    func getDiscountsList(
        request : PNCDListVC.GetDiscountListRequest
    ) async throws ->  GetDiscountListResponse {
        
        if dataEnvironment == .live {
            return try await apiService.getData(
                endpoint: API.PNCDEndpoint.getDiscountList(
                    req: request
                ),
                responseType: GetDiscountListResponse.self,
            )
            
        }else{
            return try mockDataService.fetch()
        }
        
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
