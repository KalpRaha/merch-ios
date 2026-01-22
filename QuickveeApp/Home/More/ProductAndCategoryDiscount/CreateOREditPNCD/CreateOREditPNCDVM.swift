//
//  CreateOREditPNCDVM.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 08/01/26.
//

import Foundation



extension CreateOREditPNCDVC {
    
    class ViewModel {
        
        
        init(
            editableDiscountItem: PNCDDiscountListItem?,
            builder: CreateOREditPNCDVC.AddUpdatePNCDRequestBuilder?
        ) {
            self.editableDiscountItem = editableDiscountItem
            self.builder = builder
            
            self.flagsPropertyManager = FlagsPropertyManager()
        }
        
        var editableDiscountItem: PNCDDiscountListItem? {
            didSet{
                configureBuilder()
            }
        }
        var builder: CreateOREditPNCDVC.AddUpdatePNCDRequestBuilder?
        
       
        
        
        var flagsPropertyManager: FlagsPropertyManager
        
        
       
        
        private func configureBuilder() {
            
        }
        
        func configureInitialValuesFromExistingData(){
            guard let editableDiscountItem else { return }
            
            flagsPropertyManager.productOrCategoryDiscountType = editableDiscountItem.type
            flagsPropertyManager.isAllowDiscountToStackWithOtherDiscounts = editableDiscountItem.isAllowThisDiscountToStackWithOtherDiscounts
            
            flagsPropertyManager.discountInputValueType = editableDiscountItem.discountType
            
            flagsPropertyManager.scheduleType = editableDiscountItem.scheduleType
            flagsPropertyManager.isThisDealHasNoEndDate = editableDiscountItem.isThisDealHasNoEndDate
            
        }
        
        
    }
    
}
