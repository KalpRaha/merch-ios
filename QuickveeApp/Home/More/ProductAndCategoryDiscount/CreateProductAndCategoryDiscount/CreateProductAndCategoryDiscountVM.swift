//
//  CreateProductAndCategoryDiscountVM.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 08/01/26.
//

import Foundation


protocol CreateProductAndCategoryDiscountVMDelegate : AnyObject {
    
    func didUpdateProductOrCategoryDiscountType()
    func didUpdateIsAllowDiscountToStackWithOtherDiscounts()
    func didUpdateDiscountPerItemDiscountType()
    func didUpdateScheduleType()
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
        
        
        var discountPerItemDiscountTypeSegments: [DiscountPerItemDiscountType] = [
            .amountValue,
            .percentValue
        ]
        
        var discountPerItemDiscountType: DiscountPerItemDiscountType = .amountValue {
            didSet{
                delegate?.didUpdateDiscountPerItemDiscountType()
            }
        }
        

        var scheduleTypeSegments: [ScheduleType] = [
            .oneTime,
            .repeatsOnSchedule
        ]
        
        var scheduleType : ScheduleType = .oneTime {
            didSet{
                delegate?.didUpdateScheduleType()
            }
        }
        
        
    }
    
}

extension CreateProductAndCategoryDiscountVC {
    
    enum DealDateType {
        case startDate
        case endDate
    }
    
}

