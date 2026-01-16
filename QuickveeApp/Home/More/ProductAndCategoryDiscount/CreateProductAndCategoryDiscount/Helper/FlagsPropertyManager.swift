//
//  FlagsPropertyManager.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 16/01/26.
//

import Foundation


protocol CreatePNCDFlgsPropertyManagerDelegate : AnyObject {
    
    func didUpdateProductOrCategoryDiscountType()
    func didUpdateIsAllowDiscountToStackWithOtherDiscounts()
    func didUpdateDiscountPerItemDiscountType()
    func didUpdateScheduleType()
    
    func didUpdateIsDealIsActiveForFullDay()
    func didUpdatedIncludedProductORCategories()
    
    func didUpdateIsThisDealHasNoEndDateFlag()
    
    
}

extension CreatePNCDVC {
    
    class FlagsPropertyManager {
        
        weak var delegate: CreatePNCDFlgsPropertyManagerDelegate?
        
        //MARK: - Discount Type
        
        var productOrCategoryDiscountType : ProductAndCategoryDiscountType = .product {
            didSet{
                delegate?.didUpdateProductOrCategoryDiscountType()
            }
        }
        
        //MARK: -  Discount Per Item Discount Type
        
        var discountPerItemDiscountTypeSegments: [DiscountPerItemDiscountType] = [
            .amountValue,
            .percentValue
        ]
        
        var discountPerItemDiscountType: DiscountPerItemDiscountType = .amountValue {
            didSet{
                delegate?.didUpdateDiscountPerItemDiscountType()
            }
        }
        

        //MARK: - Schedule / Repeat Type
        var scheduleTypeSegments: [ScheduleType] = [
            .oneTime,
            .repeatsOnSchedule
        ]
        
        var scheduleType : ScheduleType = .oneTime {
            didSet{
                delegate?.didUpdateScheduleType()
            }
        }
        
        
        //MARK: - Swith / Bool Flags
        
        var isAllowDiscountToStackWithOtherDiscounts: Bool = false {
            didSet{
                delegate?.didUpdateIsAllowDiscountToStackWithOtherDiscounts()
            }
        }
        
        var isThisDealHasNoEndDate: Bool = false {
            didSet{
                delegate?.didUpdateIsThisDealHasNoEndDateFlag()
            }
        }
        
        var isDealIsActiveForFullDay: Bool = false {
            didSet{
                delegate?.didUpdateIsDealIsActiveForFullDay()
            }
        }
        
        
        //MARK: - Products OR Categories ID
        var includedProductOrCategories: [String] = [] {
            didSet{
                delegate?.didUpdatedIncludedProductORCategories()
            }
        }
        
    }
    
}
