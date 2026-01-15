//
//  BogoListAPIRepository.swift
//  QuickveeApp
//
//  Created by Pallavi on 13/01/26.
//

import Foundation

protocol BogoListAPIRepositoryProtocol : AnyObject {
    
    var apiService: APIServiceType { get }
    func getBogoList() async throws  -> BogoDataModelRes
    
}



class BogoListAPIRepository : BogoListAPIRepositoryProtocol {
    
    typealias BogoListResponse  = BogoDataModelRes
    
    var apiService: any APIServiceType
    
    init(apiService: any APIServiceType) {
        self.apiService = apiService
    }
    
    func getBogoList() async throws -> BogoListResponse {
        return try await apiService.getData(
            endpoint: API.BogoListEndpoint.bogoList(
                reqBody: .init(merchantId: UDHelper.shared.merchantId)
            ),
            responseType: BogoListResponse.self,
        )
    }
    
    
}

