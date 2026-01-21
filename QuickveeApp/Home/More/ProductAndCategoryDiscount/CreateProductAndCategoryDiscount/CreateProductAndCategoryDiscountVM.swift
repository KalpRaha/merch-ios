//
//  CreateProductAndCategoryDiscountVM.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 08/01/26.
//

import Foundation



extension CreateProductAndCategoryDiscountVC {
    
    class ViewModel {
        
        
        init(
            editableDiscountItem: PNCDDiscountListItem?,
            builder: CreateProductAndCategoryDiscountVC.AddUpdatePNCDRequestBuilder?
        ) {
            self.editableDiscountItem = editableDiscountItem
            self.builder = builder
            
            self.dateNTimeHelper = DateNTimeHelper()
            self.flagsPropertyManager = FlagsPropertyManager()
        }
        
        var editableDiscountItem: PNCDDiscountListItem? {
            didSet{
                configureBuilder()
            }
        }
        var builder: CreateProductAndCategoryDiscountVC.AddUpdatePNCDRequestBuilder?
        
       
        
        
        // StartDate / End Date
        var dateNTimeHelper : DateNTimeHelper
        var flagsPropertyManager: FlagsPropertyManager
        
        
       
        
        private func configureBuilder() {
            
            dateNTimeHelper.startDate = DateFormatHelper.shared.getFormattedDate(editableDiscountItem?.startDate)
            dateNTimeHelper.endDate = DateFormatHelper.shared.getFormattedDate(editableDiscountItem?.endDate)
            
            dateNTimeHelper.startTime = TimeFormatHelper.shared.getFormattedTime(editableDiscountItem?.startTime)
            dateNTimeHelper.endTime = TimeFormatHelper.shared.getFormattedTime(editableDiscountItem?.endTime)
            
        }
        
        func configureInitialValuesFromExistingData(){
            guard let editableDiscountItem else { return }
            
            flagsPropertyManager.productOrCategoryDiscountType = editableDiscountItem.type
            flagsPropertyManager.isAllowDiscountToStackWithOtherDiscounts = editableDiscountItem.isAllowThisDiscountToStackWithOtherDiscounts
            
            flagsPropertyManager.discountInputValueType = editableDiscountItem.discountType
            
            flagsPropertyManager.scheduleType = editableDiscountItem.scheduleType
            flagsPropertyManager.isThisDealHasNoEndDate = editableDiscountItem.isThisDealHasNoEndDate
            
            
            
            dateNTimeHelper.startDate = DateFormatHelper.shared.getFormattedDate(editableDiscountItem.startDate)
            dateNTimeHelper.endDate = DateFormatHelper.shared.getFormattedDate(editableDiscountItem.endDate)
            
            dateNTimeHelper.startTime = TimeFormatHelper.shared.getFormattedTime(editableDiscountItem.startTime)
            dateNTimeHelper.endTime = TimeFormatHelper.shared.getFormattedTime(editableDiscountItem.endTime)
            
            
        }
        
        
    }
    
}
