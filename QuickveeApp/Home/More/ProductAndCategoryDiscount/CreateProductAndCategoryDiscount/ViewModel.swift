//
//  ViewModel.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 08/01/26.
//

import Foundation


protocol CreateProductAndCategoryDiscountVMDelegate : AnyObject {
    
    func didUpdateProductOrCategoryDiscountType()
    func didUpdateIsAllowDiscountToStackWithOtherDiscounts()
    func didUpdateDiscountPerItemDiscountType()
}

extension CreateProductAndCategoryDiscountVC {
    
    class ViewModel {
        
        weak var delegate : CreateProductAndCategoryDiscountVMDelegate?
        
        
        var productOrCategoryDiscountType : ProductAndCategoryDiscountType = .product {
            didSet{
                delegate?.didUpdateProductOrCategoryDiscountType()
            }
        }
        
        var isAllowDiscountToStackWithOtherDiscounts: Bool = false {
            didSet{
                delegate?.didUpdateIsAllowDiscountToStackWithOtherDiscounts()
            }
        }
        
        
        var discountPerItemDiscountType: DiscountPerItemDiscountType = .currencyValue {
            didSet{
                delegate?.didUpdateDiscountPerItemDiscountType()
            }
        }
        
        
        
    }
    
}
