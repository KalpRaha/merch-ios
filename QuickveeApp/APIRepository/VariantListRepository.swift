//
//  VariantListRepository.swift
//  QuickveeApp
//
//  Created by Pallavi on 09/01/26.
//

import Foundation

protocol VariantListRepositoryProtocol : AnyObject {
    
    var apiService: APIServiceType { get }
    func getVariantList() async throws  -> GenericAPIResponse<[InventoryVariant]>
}


class VariantListRepository : VariantListRepositoryProtocol{
    
    var apiService: any APIServiceType
    
    init(apiService: any APIServiceType) {
        self.apiService = apiService
    }
    
    func getVariantList() async throws ->  GenericAPIResponse<[InventoryVariant]> {
        return try await apiService.getData(
            endpoint: API.VariantListEndpoint.variantList,
            responseType: GenericAPIResponse<[InventoryVariant]>.self
        )
    }
    
    
}
