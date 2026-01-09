//
//  ViewModel.swift
//  QuickveeApp
//
//  Created by Pallavi on 09/01/26.
//

import Foundation


protocol ProductAndCategorySelectionViewModelDelegate: AnyObject {
    
    func getVariasntList()
    
}

extension ProductAndCategorySelectionVC {

    class ViewModel {
        
        var repository: VariantListRepositoryProtocol
        weak var delegate: ProductAndCategorySelectionViewModelDelegate?
        
        var variantList: [ProductVariantData] = [] {
            didSet {
                delegate?.getVariasntList()
            }
        }
        
        
        init(repository: VariantListRepositoryProtocol) {
            self.repository = repository
        }
      
        
        func getData(){
            Task{
                
                do{
                    let data = try await repository.getVariantList()
                    variantList = data.result ?? []
                    
                }catch{
                    
                    print("error:\(error)")
                    
                }
            }
        }
        
    }
}
