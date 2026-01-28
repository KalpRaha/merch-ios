//
//  CreateOREditPNCDValidationUpdateUI.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 27/01/26.
//

import UIKit

/// This file extends CreateOREditPNCDVC with:
/// - Request composition helpers that gather the current UI state and flags into a CreateOREditPNCDRequestBuilder.
/// - A submission flow that builds a request, handles validation failures, and triggers the create API on success.
/// - UI feedback helpers that visually reflect validation errors next to the relevant inputs.
///
/// Responsibilities and flow:
/// 1. updateRequestBuilder() reads values from viewModel.flagsPropertyManager and the UI controls to populate the builder.
/// 2. generateRequest() attempts to build the final request; on success it clears error state and calls createPNCD(req:),
///    on failure it maps ValidationError to user-facing guidance and marks specific fields for error UI.
/// 3. updateUIForValidationError() runs after errorFields change to update borders, animations, and inline error affordances.
///
/// Notes:
/// - Validation is enforced by CreateOREditPNCDRequestBuilder.build(). This extension only maps failures to UI.
/// - Some error UI is conditional (e.g., time pickers only when scheduleType == .repeatsOnSchedule and not full-day).
/// - Toast.show is used to present the ValidationError.recoverySuggestion to the user.
/// - errorFields is the single source of truth for which controls should render an error state.

extension CreateOREditPNCDVC {
    
    /// Collects the current state from UI controls and viewModel flags
    /// and applies them to the request builder. This does not perform validation
    /// or submission; it is a pure "copy values into builder" step.
    ///
    /// Sources:
    /// - viewModel.flagsPropertyManager for logical flags and selected types.
    /// - Text fields (txtDiscountName, txtDiscountInputValueType) for user-entered strings.
    /// - Date/time pickers for start/end dates and times.
    /// - Weekly selection view for selected weekdays.
    ///
    /// Call this before attempting to build the request (e.g., in generateRequest()).
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
    
    /// Attempts to build and submit a Create or Edit PNCD request.
    ///
    /// Behavior:
    /// - Calls updateRequestBuilder() to capture the latest UI and flag state.
    /// - Tries builder.build(), which can throw a ValidationError when required fields are missing/invalid.
    /// - On success: clears viewModel.errorFields and invokes viewModel.createPNCD(req:).
    /// - On failure: maps the ValidationError to UI by calling handleValidationError(error:),
    ///   and logs the error for diagnostics.
    ///
    /// Side effects:
    /// - UI error state is reset on success.
    /// - A toast is shown on validation failure with a recovery suggestion.
    func generateRequest() {
        updateRequestBuilder()
        do {
            
            let req = try viewModel.builder.build()
            
            // If Created then remove all the fields
            viewModel.errorFields.removeAll()
            
            viewModel.createPNCD(req: req)
            
        }catch let error{
            
            if let error = error as? CreateOREditPNCDVC.CreateOREditPNCDRequestBuilder.ValidationError {
                handleValidationError(error: error)
                
            }
            Logger.log("Error While Creating PNCD : \(error)")
        }
        
    }
    
}


fileprivate extension CreateOREditPNCDVC {
    
    /// Maps a ValidationError produced by the builder into:
    /// - A toast with human-readable guidance via error.recoverySuggestion.
    /// - A set of errorFields that the UI layer can use to highlight problematic inputs.
    /// - Hides the save button loader to return control to the user.
    ///
    /// Only errors that correspond to user-editable fields add entries to errorFields.
    /// Flag-related errors (e.g., missing schedule type) present a toast but do not mark a specific field.
    ///
    /// - Parameter error: The validation failure from CreateOREditPNCDRequestBuilder.build().
    func handleValidationError(
        error: CreateOREditPNCDVC.CreateOREditPNCDRequestBuilder.ValidationError
    ) {
        
        btnSave.hideLoader()
        Toast.show(error.recoverySuggestion)
        
        // Fresh start: clear any previously marked error fields.
        viewModel.errorFields.removeAll()
        
        switch error {
            
        case .missingPNCDType: break;
        case .missingIsAllowThisDiscountToStackWithOtherDiscountsFlag: break;
        case .missingIsThisDiscountHasNoEndDateFlag: break;
        case .missingIsThisDiscountIsActiveForFullDayFlag: break;
            
        case .missingDiscountName:
            viewModel.errorFields.append(.discountName)
            
        case .missingDiscountValue:
            viewModel.errorFields.append(.discountValue)
            
        case .missingDiscountType: break;
        case .missingScheduleType: break;
            
        case .missingStartDate:
            viewModel.errorFields.append(.startDate)
            
        case .missingEndDate:
            viewModel.errorFields.append(.endDate)
            
        case .missingSelectedDays:
            viewModel.errorFields.append(.weekDaysSelection)
            
        case .missingStartTime:
            viewModel.errorFields.append(.startTime)
            
        case .missingEndTime:
            viewModel.errorFields.append(.endTime)
            
        case .endTimeMustBegraterThanStartTime:
            viewModel.errorFields.append(.endDate)
            
        }
        
    }
    
}

extension CreateOREditPNCDVC {
    
    /// Refreshes error UI for all user-editable fields based on viewModel.errorFields.
    ///
    /// This should be called after handleValidationError sets errorFields, or whenever
    /// errorFields is updated (e.g., via delegate callback).
    ///
    /// It delegates to per-field methods that handle borders, animations, and conditional visibility.
    func updateUIForValidationError() {
        updateUIForDiscountName()
        updateUIForDiscountValue()
        updateUIForStartDateAndEndDate()
        updateUIForStartTimeAndEndTime()
        updateUIForWeekDaySelection()
    }
    
}


fileprivate extension CreateOREditPNCDVC {
    
    /// Updates the visual state for the discount name input based on whether
    /// .discountName is present in viewModel.errorFields.
    ///
    /// Valid: light gray border (.E4E8EF).
    /// Invalid: red border and a brief shake/attention animation.
    func updateUIForDiscountName() {
        let isValid = viewModel.errorFields.contains(.discountName) == false
        
        txtDiscountName.superview?.applyBorder(
            borderWidth: 1,
            borderColor: isValid ? .E4E8EF : .red,
            borderOpacity: 1
        )
        if !isValid {
            txtDiscountName.superview?.showValidationErrorAnimation()
        }
    }
    
    /// Updates the visual state for the discount value input based on whether
    /// .discountValue is present in viewModel.errorFields.
    ///
    /// Valid: light gray border (.E4E8EF).
    /// Invalid: red border and a brief shake/attention animation.
    func updateUIForDiscountValue() {
        let isValid = viewModel.errorFields.contains(.discountValue) == false
        
        txtDiscountInputValueType.superview?.applyBorder(
            borderWidth: 1,
            borderColor: isValid ? .E4E8EF : .red,
            borderOpacity: 1
        )
        if !isValid {
            txtDiscountInputValueType.superview?.showValidationErrorAnimation()
        }
    }
    
    /// Updates error UI for the date pickers.
    ///
    /// - Start date highlights when errorFields contains .startDate.
    /// - End date highlights when errorFields contains .endDate.
    func updateUIForStartDateAndEndDate(){
        let isValidStartDate = viewModel.errorFields.contains(.startDate) == false
        dtPickerDealStartDate.updateUIForValidationError(isValid: isValidStartDate)
        
        let isValidEndDate = viewModel.errorFields.contains(.endDate) == false
        dtPickerDealEndDate.updateUIForValidationError(isValid: isValidEndDate)
        
    }
    
    /// Updates error UI for the time pickers.
    ///
    /// Only applies when:
    /// - scheduleType == .repeatsOnSchedule, and
    /// - isDealIsActiveForFullDay == false
    ///
    /// In that mode:
    /// - Start time highlights when errorFields contains .startTime.
    /// - End time highlights when errorFields contains .endTime.
    func updateUIForStartTimeAndEndTime(){
        guard
            (viewModel.flagsPropertyManager.scheduleType == .repeatsOnSchedule) &&
                (viewModel.flagsPropertyManager.isDealIsActiveForFullDay == false)
        else { return }
        
        let isValidStartDate = viewModel.errorFields.contains(.startTime) == false
        dtPickerDealStartTime.updateUIForValidationError(isValid: isValidStartDate)
        
        let isValidEndDate = viewModel.errorFields.contains(.endTime) == false
        dtPickerDealEndTime.updateUIForValidationError(isValid: isValidEndDate)
        
    }
    
    /// Triggers the weekly selection view to present an error UI if:
    /// - scheduleType == .repeatsOnSchedule, and
    /// - errorFields contains .weekDaysSelection (i.e., no days selected).
    func updateUIForWeekDaySelection(){
        guard
            (viewModel.flagsPropertyManager.scheduleType == .repeatsOnSchedule) &&
                (viewModel.errorFields.contains(.weekDaysSelection))
        else { return }
        
        vwWeeklySelectionView.showValidationErrorUI()
    }
    
}
