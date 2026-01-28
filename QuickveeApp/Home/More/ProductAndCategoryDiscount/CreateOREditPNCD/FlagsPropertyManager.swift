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
    
    func didUpdatedSelectedWeekDates()
    
    func didUpdateIsDealIsActiveForFullDay()
    func didUpdatedIncludedProductORVariants()
    func didUpdatedIncludedCategories()
    
    func didUpdateIsThisDealHasNoEndDateFlag()
    
    
}

extension CreatePNCDVC {
    
    class FlagsPropertyManager {
        
        weak var delegate: CreateOREditPNCDFlagsPropertyManagerDelegate?
        
        //MARK: - Discount Type
        
        var pncdType : PNCDType = .product {
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
        
        var selectedDates: [WeekDayItem] = [.sun]{
            didSet{
                delegate?.didUpdatedSelectedWeekDates()
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
        var includedProductOrVariants: [VariantDataModel] = [] {
            didSet{
                delegate?.didUpdatedIncludedProductORVariants()
            }
        }
        
        var includedCategories: [CategoryDataModel] = [] {
            didSet{
                delegate?.didUpdatedIncludedCategories()
            }
        }
        
    }
    
}
