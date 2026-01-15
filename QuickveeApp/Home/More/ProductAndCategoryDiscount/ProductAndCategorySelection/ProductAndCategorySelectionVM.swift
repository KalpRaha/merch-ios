//
//  ViewModel.swift
//  QuickveeApp
//
//  Created by Pallavi on 09/01/26.
//

import Foundation


protocol ProductAndCategorySelectionViewModelDelegate: AnyObject {
    
    func didUpdatedVariantListData()
}

extension ProductAndCategorySelectionVC {

    class ViewModel {
        
        var repository: VariantListAPIRepositoryProtocol
        var categoryRepository:  CategoryListAPIRepositoryProtocol
        var bogoRepository:  BogoListAPIRepositoryProtocol
        var minMatchRepository:   MixnMatchListAPIRepositoryProtocol
        
        
        weak var delegate: ProductAndCategorySelectionViewModelDelegate?
        
        var variantList: [VariantDataModel] = [] {
            didSet {
                delegate?.didUpdatedVariantListData()
            }
        }
        
        
        var categoryList: [CategoryDataModel] = []
        var bogoList: [BogoDataModel] = []
        var mixMatchList: [MixnMatchDataModel] = []

        var selectedIndexPath : [IndexPath] = []
        
  
        init(
            repository: VariantListAPIRepositoryProtocol,
            categoryRepository: CategoryListAPIRepositoryProtocol,
            bogoRepository: BogoListAPIRepositoryProtocol,
            minMatchRepository: MixnMatchListAPIRepositoryProtocol
        ) {
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

                    let (variantData, categoryData , bogoData, mixmatchData) = try await (variantResponse,categoryResponse,bogoResponse,mixMatchResponse )

                    // UI update (MainActor)
                    await MainActor.run {
                        self.categoryList = categoryData.result ?? []
                        self.bogoList = bogoData.result
                        self.mixMatchList = mixmatchData.result
                        
                        self.variantList = variantData.result ?? []
                        
                    }

                } catch {
                    Logger.log("Error loading data: \(error)")
                }
            }
        }
        
        func getCategoryData(_ index : Int) -> CategoryDataModel? {
            categoryList.first(where: { $0.id == variantList[index].category })
        }
        
        func getMixNMatchData(_ index : Int) -> MixnMatchDataModel? {
            let itemId = variantList[index].isVarient ? variantList[index].variantId : variantList[index].id
            
            return mixMatchList.filter({ $0.itemIds.contains(where:{$0 == itemId} ) }).first
        }
        
        func getBogoData(_ index : Int) -> BogoDataModel? {
            let itemId = variantList[index].isVarient ? variantList[index].variantId : variantList[index].id
            
            return bogoList.filter({ $0.items.contains(where:{$0 == itemId} ) }).first
        }

    }
}


