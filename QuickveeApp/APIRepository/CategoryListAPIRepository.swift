//
//  CategoryListAPIRepository.swift
//  QuickveeApp
//
//  Created by Pallavi on 13/01/26.
//

import Foundation

protocol CategoryListAPIRepositoryProtocol : AnyObject {
    
    var apiService: APIServiceType { get }
    func getCategoryList() async throws  -> GenericAPIResponse<[CategoryDataModel]>
    
}



class CategoryListAPIRepository : CategoryListAPIRepositoryProtocol{
    
    typealias CategoryListResponse  = GenericAPIResponse<[CategoryDataModel]>
    
    var apiService: any APIServiceType
    
    init(apiService: any APIServiceType) {
        self.apiService = apiService
    }
    
    func getCategoryList() async throws -> CategoryListResponse {
        return try await apiService.getData(
            endpoint: API.CategoryListEndpoint.categoryList(
                reqBody: .init(merchantId: UDHelper.shared.merchantId)
            ),
            responseType: CategoryListResponse.self,
        )
    }
    
    
}
