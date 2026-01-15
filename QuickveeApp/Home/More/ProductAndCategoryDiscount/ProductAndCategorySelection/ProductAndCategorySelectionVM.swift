//
//  ViewModel.swift
//  QuickveeApp
//
//  Created by Pallavi on 09/01/26.
//

import Foundation


protocol ProductAndCategorySelectionViewModelDelegate: AnyObject {
    
    func loadData()
}

extension ProductAndCategorySelectionVC {

    class ViewModel {
        
        var repository: VariantListRepositoryProtocol
        var categoryRepository:  CategoryListRepositoryProtocol
        var bogoRepository:  BogoListRepositoryProtocol
        var minMatchRepository:   MixnMatchListRepositoryProtocol
        
        weak var delegate: ProductAndCategorySelectionViewModelDelegate?
        
        var variantList: [VariantDataModel] = [] {
            didSet {
                delegate?.loadData()
            }
        }
        
        
        var categoryList: [CategoryDataModel] = []
           
        var bogoList: [BogoDataModel] = []
        
        var mixMatchList: [MixnMatchDataModel] = []

        var selectedIndexPath : [IndexPath] = []
        
  
        init(repository: VariantListRepositoryProtocol, categoryRepository: CategoryListRepositoryProtocol, bogoRepository: BogoListRepositoryProtocol, minMatchRepository: MixnMatchListRepositoryProtocol) {
            self.repository = repository
            self.categoryRepository = categoryRepository
            self.bogoRepository = bogoRepository
            self.minMatchRepository = minMatchRepository
            
        }
        
        
        func loadData() {
            
            Task {
                do {
                    async let variantResponse = repository.getVariantList()
                    async let categoryResponse = categoryRepository.getCategoryList()
                    async let bogoResponse = bogoRepository.getBogoList()
                    async let mixMatchResponse = minMatchRepository.getMixnMatchList()

                    let (variantData, categoryData , bogoData,mixmatchData) = try await (variantResponse,categoryResponse,bogoResponse,mixMatchResponse )

                    // UI update (MainActor)
                    await MainActor.run {
                        self.categoryList = categoryData.result ?? []
                        self.bogoList = bogoData.result
                        self.mixMatchList = mixmatchData.result
                        
                        self.variantList = variantData.result ?? []
                        

                    }

                } catch {
                    print("Error loading data: \(error)")
                }
            }
        }

    }
}


