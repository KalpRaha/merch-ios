//
//  ViewModel.swift
//  QuickveeApp
//
//  Created by Pallavi on 09/01/26.
//

import Foundation


protocol ProductAndCategorySelectionViewModelDelegate: AnyObject {
    
    func didUpdatedTableViewData()
    func didUpdateSearchFlag()
    func didUpdateSelectedCategories()
}

extension ProductAndCategorySelectionVC {
    
    class ViewModel {
        
        var repository: VariantListAPIRepositoryProtocol
        var categoryRepository:  CategoryListAPIRepositoryProtocol
        var bogoRepository:  BogoListAPIRepositoryProtocol
        var minMatchRepository:   MixnMatchListAPIRepositoryProtocol
      
        weak var delegate: ProductAndCategorySelectionViewModelDelegate?
    
        var variantList: [VariantDataModel] = []
        var categoryList: [CategoryDataModel] = []
        var bogoList: [BogoDataModel] = []
        var mixMatchList: [MixnMatchDataModel] = []
        
        var selectedIndexPath : [IndexPath] = []
        
        var isSearching = false {
            didSet{
                delegate?.didUpdateSearchFlag()
            }
        }
        var searchQuery: String = "" {
            didSet{
                performSearch()
            }
        }
        
        var tableViewDataSource = [VariantDataModel]() {
            didSet{
                delegate?.didUpdatedTableViewData()
            }
        }
        
        var selectedCategories: [InventoryCategory] = [] {
            didSet {
                filterByCategories()
                delegate?.didUpdateSelectedCategories()
            }
        }
        
        var discounttype : PNCDType =  .product
  
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
                        self.tableViewDataSource = variantList
                    }
                    
                } catch {
                    Logger.log("Error loading data: \(error)")
                }
            }
        }
        
        func getCategoryData(_ index : Int) -> CategoryDataModel? {
            categoryList.first(where: { $0.id == tableViewDataSource[index].category })
        }
        
        func getMixNMatchData(_ index : Int) -> MixnMatchDataModel? {
            let itemId = variantList[index].isVarient ? tableViewDataSource[index].variantId : tableViewDataSource[index].id
         return mixMatchList.filter({ $0.itemIds.contains(where:{$0 == itemId} ) }).first
        }
        
        func getBogoData(_ index : Int) -> BogoDataModel? {
            let itemId = variantList[index].isVarient ? tableViewDataSource[index].variantId : tableViewDataSource[index].id
            return bogoList.filter({ $0.items.contains(where:{$0 == itemId} ) }).first
        }
        
        func filterByCategories() {
            tableViewDataSource = variantList.filter({ variant in
                
                return selectedCategories.first(where: { $0.id ==  variant.category }) != nil
            })
        }
        
        func performSearch() {
            let searchQuery = searchQuery.lowercased()
            tableViewDataSource =  searchQuery.isEmpty ? variantList : variantList.filter { item in
                (item.productTitle?.lowercased() ?? "").contains(searchQuery) ||
                (item.variantUpc?.lowercased() ?? "").contains(searchQuery) ||
                (item.productUPC?.lowercased() ?? "").contains(searchQuery) ||
                (item.customCode?.lowercased() ?? "").contains(searchQuery)
            }
        }
        
        
        func checkSelectedVariantsForDeal() -> Bool {
         
            let checkSelectedVariants: [VariantDataModel]

                if discounttype == .product {
                    checkSelectedVariants = selectedIndexPath.map {
                        variantList[$0.row]
                    }
                } else {
                    checkSelectedVariants = selectedIndexPath.flatMap { indexPath in
                        let category = categoryList[indexPath.row]
                        return variantList.filter { $0.category == category.id }
                    }
                }

                let hasDeal = checkSelectedVariants.contains { variant in
                    mixMatchList.contains { $0.itemIds.contains(variant.itemId) } ||
                    bogoList.contains { $0.items.contains(variant.itemId) }
                }
       
            return hasDeal
        }
        
        func isVariantIncludedInDeal(_ variant: VariantDataModel) -> Bool {
            mixMatchList.contains { $0.itemIds.contains(variant.id) } ||
            bogoList.contains { $0.items.contains(variant.id) }
        }
    
        func isCategoryIncludedInDeal(_ category: CategoryDataModel) -> Bool {
            let categoryVariantIds = variantList
                .filter { $0.category == category.id }
                .map { $0.id }

            return mixMatchList.contains { deal in
                deal.itemIds.contains(where: categoryVariantIds.contains)
            } ||
            bogoList.contains { deal in
                deal.items.contains(where: categoryVariantIds.contains)
            }
        }
        
        
        func resetData() {
            tableViewDataSource = variantList
        }
        
    }
}

