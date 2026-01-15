//
//  MixnMatchListRepository.swift
//  QuickveeApp
//
//  Created by Pallavi on 13/01/26.
//

import Foundation

protocol MixnMatchListRepositoryProtocol : AnyObject {
    
    var apiService: APIServiceType { get }
    func getMixnMatchList() async throws  -> MixnMatchDataModelRes
    
}



class MixnMatchListRepository : MixnMatchListRepositoryProtocol {
    
    typealias MixnMatchListResponse  = MixnMatchDataModelRes
    
    var apiService: any APIServiceType
    
    init(apiService: any APIServiceType) {
        self.apiService = apiService
    }
    
    func getMixnMatchList() async throws -> MixnMatchListResponse {
        return try await apiService.getData(
            endpoint: API.MixnMatchListEndpoint.MixnMatchList(
                reqBody: .init(merchantId: UDHelper.shared.merchantId)
            ),
            responseType: MixnMatchListResponse.self,
        )
    }
    
    
}
