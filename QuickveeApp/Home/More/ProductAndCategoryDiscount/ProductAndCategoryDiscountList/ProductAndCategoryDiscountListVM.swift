//
//  ProductAndCategoryDiscountListVM.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 15/01/26.
//

import Foundation

protocol ProductAndCategoryDiscountListVMProtocol: AnyObject {
    
    func didUpdatedDiscountList()
    
}

extension ProductAndCategoryDiscountListVC {
    
    class ViewModel {
        
        
        var pncdRepository : ProductAndCategoryDiscountAPIRepositoryProtocol
        
        weak var delegate : ProductAndCategoryDiscountListVMProtocol?
        
        
        var discountList : [PNCDDiscountListItem] = [] {
            didSet{
                delegate?.didUpdatedDiscountList()
            }
        }
        
        init(
            pncdRepository: ProductAndCategoryDiscountAPIRepositoryProtocol
        ) {
            self.pncdRepository = pncdRepository
        }
        
        func getDiscountList() {
            
            Task{
                do {
                    
                    let request = GetDiscountListRequest()
                    
                    let data = try await pncdRepository.getDiscountsList(request: request)
                    discountList =  data.data ?? []
                    Logger.log("Found Response : \(discountList)")
                    
                }catch{
                    Logger.log("Found Response Error : \(error)")
                }
                
            }
        }
     
        
        
    }
}

