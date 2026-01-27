//
//  CreateOREditPNCDValidationUpdateUI.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 27/01/26.
//

import UIKit

extension CreateOREditPNCDVC {
    
    func updateRequestBuilder() {
        let propertyManager = viewModel.flagsPropertyManager
        
        _=viewModel.builder
            .setPNCDId(viewModel.editableDiscountItem?.id)
            .setIsDisable(viewModel.editableDiscountItem?.isDiscountDisable)
            .setPNCDType(propertyManager.pncdType)
            .setIsAllowThisDiscountToStackWithOtherDiscounts(propertyManager.isAllowDiscountToStackWithOtherDiscounts)
            .setDiscountName(txtDiscountName.text)
            .setDiscountValue(txtDiscountInputValueType.text)
            .setDiscountInputValueType(propertyManager.discountInputValueType)
            .setDiscountScheduleType(propertyManager.scheduleType)
            .setIsThisDiscountHasNoEndDate(propertyManager.isThisDealHasNoEndDate)
            .setStartDate(dtPickerDealStartDate.selectedDate)
            .setStartTime(dtPickerDealStartTime.selectedDate)
            .setSelectedWeekDays(vwWeeklySelectionView.selectedItems)
            .setIsThisDiscountIsActiveForFullDay(propertyManager.isDealIsActiveForFullDay)
            .setEndDate(dtPickerDealEndDate.selectedDate)
            .setEndTime(dtPickerDealEndTime.selectedDate)
        
    }
    
    func generateRequest() {
        updateRequestBuilder()
        do {
            let req = try viewModel.builder.build()
            
            viewModel.createPNCD(req: req)
            
        }catch let error{
            
            if let error = error as? CreateOREditPNCDVC.CreateOREditPNCDRequestBuilder.ValidationError {
                handleValidationError(error: error)
                
            }
            Logger.log("Error While Creating PNCD : \(error)")
        }
        
    }
    
    fileprivate func handleValidationError(
        error: CreateOREditPNCDVC.CreateOREditPNCDRequestBuilder.ValidationError
    ) {
        
        if error == .missingDiscountName {
            
            return
        }
        
        
        btnSave.hideLoader()
    }
    
}
