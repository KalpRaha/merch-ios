//
//  CreateOREditPNCDUpdateUIHelperForFlags.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 23/01/26.
//

extension CreatePNCDVC {
    
    /// Updates the UI to reflect the "Allow discount to stack with other discounts" flag.
    ///
    /// Mirrors `viewModel.flagsPropertyManager.isAllowDiscountToStackWithOtherDiscounts`
    /// into the corresponding switch control.
    func updateUIForIsAllowDiscountToStackWithOtherDiscountsFlagChange() {
        let isAllow = viewModel.flagsPropertyManager.isAllowDiscountToStackWithOtherDiscounts
        swtAllowDiscountStackWithOtherDiscounts.updateIsOnFlag(isAllow)
    }
    
    /// Updates date-related UI when the "This deal has no end date" flag changes.
    ///
    /// - Ensures the start date is always set (from existing item if available).
    /// - Clears or restores the end date depending on the flag.
    /// - Enables/disables the end date picker accordingly.
    /// - Syncs the "no end date" switch with the current flag value.
    func updateUIForIsPNCDHasNoEndDateFlagChange(){
        let isThisDealHasNoEndDate = viewModel.flagsPropertyManager.isThisDealHasNoEndDate
        
        // Start Date must always be updated to reflect existing model if present.
        if let editableDiscountItem = viewModel.editableDiscountItem {
            dtPickerDealStartDate.setSelectedDate(
                date: editableDiscountItem.startDate,
                time: editableDiscountItem.startTime
            )
        } else {
            dtPickerDealStartDate.setSelectedDate(nil)
        }
        
        // End date handling depends on "no end date" flag.
        if isThisDealHasNoEndDate {
            // Clear end date/time and disable control.
            dtPickerDealEndDate.setSelectedDate(nil)
        } else {
            // If we have an existing item and no end date picked yet, restore it from the model.
            if dtPickerDealEndDate.selectedDate == nil,
               let endDate = viewModel.editableDiscountItem?.endDate,
               let endTime = viewModel.editableDiscountItem?.endTime
            {
                dtPickerDealEndDate.setSelectedDate(
                    date: endDate,
                    time: endTime
                )
            }
        }
        
        // Enable end date picker only if the deal does have an end date.
        dtPickerDealEndDate.setEnabled(isThisDealHasNoEndDate ? false : true)
        swtDealHasNoEndDate.updateIsOnFlag(isThisDealHasNoEndDate)
    }
    
    
    /// Updates time-related UI when the "Deal is active for full day" flag changes.
    ///
    /// - Clears time pickers if full-day is enabled.
    /// - Otherwise, restores start/end times from the existing item (if needed).
    /// - Syncs the switch with the current flag value.
    /// - Shows/hides the time picker row based on schedule type and full-day flag.
    func updateUIForIsPNCDActiveForFullDayFlagChange(){
        let isDealIsActiveForFullDay = viewModel.flagsPropertyManager.isDealIsActiveForFullDay
        
        if isDealIsActiveForFullDay {
            // Full-day: no explicit times.
            dtPickerDealStartTime.setSelectedDate(nil)
            dtPickerDealEndTime.setSelectedDate(nil)
            
        } else {
            // Not full-day: ensure time pickers reflect data if available.
            if let editableDiscountItem = viewModel.editableDiscountItem {
                
                if dtPickerDealStartTime.selectedDate == nil {
                    dtPickerDealStartTime.setSelectedDate(
                        date: editableDiscountItem.startDate,
                        time: editableDiscountItem.startTime
                    )
                }
                
                if dtPickerDealEndTime.selectedDate == nil {
                    dtPickerDealEndTime.setSelectedDate(
                        date: editableDiscountItem.endDate,
                        time: editableDiscountItem.endTime
                    )
                }
                
            } else {
                // No existing item: keep them clear.
                dtPickerDealStartTime.setSelectedDate(nil)
                dtPickerDealEndTime.setSelectedDate(nil)
            }
        }
        
        // Reflect the flag in the switch UI.
        swtDealIsActiveForFullDay.updateIsOnFlag(isDealIsActiveForFullDay)
        
        // Time pickers are only shown when:
        // - schedule is "repeats on schedule"
        // - and not full-day
        let isShowTimePicker = (
            (viewModel.flagsPropertyManager.scheduleType == .repeatsOnSchedule) && (isDealIsActiveForFullDay == false)
        )
        dtPickerDealStartTime.superview?.isHidden = isShowTimePicker ? false : true
    }
    
}
