//
//  VariantListAPIRepository.swift
//  QuickveeApp
//
//  Created by Pallavi on 09/01/26.
//

import Foundation

protocol VariantListAPIRepositoryProtocol : AnyObject {
    
    var apiService: APIServiceType { get }
    func getVariantList() async throws  -> GenericAPIResponse<[VariantDataModel]>
}


class VariantListAPIRepository : VariantListAPIRepositoryProtocol{
    
    var apiService: any APIServiceType
    
    init(apiService: any APIServiceType) {
        self.apiService = apiService
    }
    
    func getVariantList() async throws ->  GenericAPIResponse<[VariantDataModel]> {
        return try await apiService.getData(
            endpoint: API.VariantListEndpoint.variantList(
                reqBody: .init(merchantId: UDHelper.shared.merchantId)
            ),
            responseType: GenericAPIResponse<[VariantDataModel]>.self,
        )
    }
    
    
}
