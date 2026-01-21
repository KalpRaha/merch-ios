//
//  FlagsPropertyManager.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 16/01/26.
//

import Foundation


protocol CreateOREditPNCDFlagsPropertyManagerDelegate : AnyObject {
    
    func didUpdateProductOrCategoryDiscountType()
    func didUpdateIsAllowDiscountToStackWithOtherDiscounts()
    func didUpdateDiscountInputValueType()
    func didUpdateScheduleType()
    
    func didUpdateIsDealIsActiveForFullDay()
    func didUpdatedIncludedProductORCategories()
    
    func didUpdateIsThisDealHasNoEndDateFlag()
    
    
}

extension CreatePNCDVC {
    
    class FlagsPropertyManager {
        
        weak var delegate: CreateOREditPNCDFlagsPropertyManagerDelegate?
        
        //MARK: - Discount Type
        
        var productOrCategoryDiscountType : PNCDType = .product {
            didSet{
                delegate?.didUpdateProductOrCategoryDiscountType()
            }
        }
        
        //MARK: -  Discount Per Item Discount Type
        
        var discountPerItemDiscountTypeSegments: [DiscountInputValueType] = [
            .amountValue,
            .percentValue
        ]
        
        var discountInputValueType: DiscountInputValueType = .amountValue {
            didSet{
                delegate?.didUpdateDiscountInputValueType()
            }
        }
        

        //MARK: - Schedule / Repeat Type
        var scheduleTypeSegments: [PNCDScheduleType] = [
            .oneTime,
            .repeatsOnSchedule
        ]
        
        var scheduleType : PNCDScheduleType = .oneTime {
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
        var includedProductOrCategories: [VariantDataModel] = [] {
            didSet{
                delegate?.didUpdatedIncludedProductORCategories()
            }
        }
        
    }
    
}
