//
//  CategoryListRepository.swift
//  QuickveeApp
//
//  Created by Pallavi on 13/01/26.
//

import Foundation

protocol CategoryListRepositoryProtocol : AnyObject {
    
    var apiService: APIServiceType { get }
    func getCategoryList() async throws  -> GenericAPIResponse<[CategoryDataModel]>
    
}



class CategoryListRepository : CategoryListRepositoryProtocol{
    
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
