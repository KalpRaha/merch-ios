//
//  CreateOREditPNCDUpdateUIHelperForInitialData.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 23/01/26.
//

import UIKit

extension CreateOREditPNCDVC {
    
    /// Entry point to seed the UI with data.
    ///
    /// - If `viewModel.editableDiscountItem` exists (editing flow), we populate the UI with the
    ///   existing item data once (guarded by `isExisitngPropertiesUpdatedOnUI`).
    /// - Otherwise (create flow), we initialize the UI with sensible defaults.
    func feedExistingDataInUI(){
        if viewModel.editableDiscountItem != nil {
            
            // Avoid re-applying values multiple times when view re-appears.
            if !isExisitngPropertiesUpdatedOnUI {
                updateUIWithExitingValues()
            }
            
        } else {
            updateUIWithDefaultInitialValues()
        }
    }
    
    /// Populates UI controls and state with values from an existing discount item.
    ///
    /// This method:
    /// - Copies existing values into the flags property manager (via `configureInitialValuesFromExistingData()`).
    /// - Updates text fields (name and per-item discount).
    /// - Formats the discount value with `DiscountPerItemDiscountTextFormatter` based on the selected input type.
    /// - Triggers a minimal async delay to ensure segmented controls and dependent UI are updated consistently.
    /// - Marks `isExisitngPropertiesUpdatedOnUI` to prevent re-seeding on subsequent appearances.
    private func updateUIWithExitingValues(){
        guard let editableDiscountItem = viewModel.editableDiscountItem else { return }
        
        // Sync flags/state from the model before touching UI elements.
        configureInitialValuesFromExistingData()
        
        // Basic fields
        txtDiscountName.text = editableDiscountItem.discountName
        txtDiscountInputValueType.text = editableDiscountItem.discount ?? "0"
        
        // Format discount text based on the input type (amount vs percent).
        txtDiscountInputValueType.text = DiscountPerItemDiscountTextFormatter.format(
            editableDiscountItem.discount ?? "",
            type: viewModel.flagsPropertyManager.discountInputValueType
        )
        
        // Dispatching to the next run loop tick to allow segmented controls and dependent UI
        // to reflect the flags that were just set above.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: { [weak self] in
            guard let self else { return }
            updateUIForPNCDSelectionType()
        })
        
        // Ensure we don't re-apply these initial values when the view appears again.
        isExisitngPropertiesUpdatedOnUI = true
    }
    
    /// Copies relevant properties from the editable discount item into the flags property manager.
    ///
    /// This ensures that all UI components driven by `flagsPropertyManager` reflect the current
    /// persisted state (discount type, stacking behavior, date/time schedule, etc.).
    private func configureInitialValuesFromExistingData(){
        guard let editableDiscountItem = viewModel.editableDiscountItem else { return }
        
        // Product vs Category discount type
        viewModel.flagsPropertyManager.productOrCategoryDiscountType = editableDiscountItem.type
        
        // Whether this discount can stack with other discounts
        viewModel.flagsPropertyManager.isAllowDiscountToStackWithOtherDiscounts = editableDiscountItem.isAllowThisDiscountToStackWithOtherDiscounts
        
        // Whether the deal has no end date (affects end date UI)
        viewModel.flagsPropertyManager.isThisDealHasNoEndDate = editableDiscountItem.isThisDealHasNoEndDate
        
        // Discount input type (amount vs percent) and schedule type (one-time vs weekly, etc.)
        viewModel.flagsPropertyManager.discountInputValueType = editableDiscountItem.discountType
        viewModel.flagsPropertyManager.scheduleType = editableDiscountItem.scheduleType
        
        // Full-day flag (affects time picker UI)
        viewModel.flagsPropertyManager.isDealIsActiveForFullDay = editableDiscountItem.isDealActiveForFullDay
        
        // Weekly selected days used for recurring schedules
        viewModel.flagsPropertyManager.selectedDates = editableDiscountItem.selectedWeekDays
    }
    
    /// Initializes the UI for the "create" flow (no existing item provided).
    ///
    /// Sets default flags and updates the UI accordingly:
    /// - Schedules a short async update to ensure selection-type-dependent UI is laid out.
    /// - Syncs UI for default discount input value type and schedule type.
    /// - Establishes default flags (amount input, stacking allowed, has end date, not full-day).
    /// - Clears any previously included product/category selections.
    private func updateUIWithDefaultInitialValues(){
        // Defer selection-type UI update slightly to allow initial layout/segmented control setup.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: { [weak self] in
            guard let self else { return }
            updateUIForPNCDSelectionType()
        })
        
        // Reflect current flags in UI (segmented controls, switches, etc.)
        updateUIForDiscountInputValueTypeChange()
        updateUIForScheduleTypeValueChange()
        
        // Defaults for a new discount
        viewModel.flagsPropertyManager.discountInputValueType = .amountValue
        viewModel.flagsPropertyManager.isAllowDiscountToStackWithOtherDiscounts = true
        viewModel.flagsPropertyManager.isThisDealHasNoEndDate = false
        viewModel.flagsPropertyManager.isDealIsActiveForFullDay = false
        
        // Start with no included items
        viewModel.flagsPropertyManager.includedProductOrCategories.removeAll()
    }
    
}
