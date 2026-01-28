//
//  CreateOREditPNCDRequestBuilder.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 16/01/26.
//

import Foundation


extension CreateOREditPNCDVC {

    final class CreateOREditPNCDRequestBuilder {
        
        private var merchantId: String
        private var pNCDId: String?
        
        private var pncdType: PNCDType?
        
        private var isDisable: Bool?
        private var isAllowThisDiscountToStackWithOtherDiscounts: Bool?
        private var isThisDiscountHasNoEndDate: Bool?
        private var isThisDiscountIsActiveForFullDay: Bool?
        
        private var discountName: String?
        private var discountValue: String?
        private var discountType: DiscountInputValueType?
        
        private var scheduleType : PNCDScheduleType?
        
        // Time
        private var startDate: Date?
        private var startTime: Date?
        
        private var endDate: Date?
        private var endTime: Date?
        
        private var selectedWeekDays: [WeekDayItem] = []
        
        

        init(
            merchantId: String,
            pncdId: String? = nil
        ) {
            self.merchantId = merchantId
            self.pNCDId = pncdId
        }

        func setMerchantId(_ value: String) -> Self {
            merchantId = value
            return self
        }
        
        func setPNCDId(_ id : String?) -> Self {
            pNCDId = id
            return self
        }
        
        func setPNCDType( _ type : PNCDType) -> Self {
            self.pncdType = type
            return self
        }
        
        
        func setIsDisable(_ value : Bool?) -> Self {
            isDisable = value
            return self
        }
        
        func setIsAllowThisDiscountToStackWithOtherDiscounts(_ value : Bool) -> Self {
            isAllowThisDiscountToStackWithOtherDiscounts = value
            return self
        }
        
        func setIsThisDiscountHasNoEndDate(_ value: Bool) -> Self {
            self.isThisDiscountHasNoEndDate = value
            return self
        }
        
        func setIsThisDiscountIsActiveForFullDay(_ value: Bool) -> Self {
            self.isThisDiscountIsActiveForFullDay = value
            return self
        }
        
        
        func setDiscountName(_ value: String?) -> Self {
            discountName = value
            return self
        }
        
        func setDiscountValue(_ value: String?) -> Self {
            discountValue = value
            return self
        }
        
        func setDiscountInputValueType(_ value: DiscountInputValueType?) -> Self {
            discountType = value
            return self
        }
        
        func setDiscountScheduleType(_ value: PNCDScheduleType?) -> Self {
            self.scheduleType = value
            return self
        }
        
        
        // Date And Time
        func setStartDate(_ date : Date?) -> Self {
            self.startDate = date
            return self
        }
        
        func setStartTime(_ date : Date?) -> Self {
            self.startTime = date
            return self
        }
        
        func setEndDate(_ date : Date?) -> Self {
            self.endDate = date
            return self
        }
        
        func setEndTime(_ date : Date?) -> Self {
            self.endTime = date
            return self
        }
        
        
        func setSelectedWeekDays(_ value: [WeekDayItem]) -> Self {
            self.selectedWeekDays = value
            return self
        }
        
        
        func setProductVariantIds(_ value: [String]) -> Self {
            return self
        }
        
        func setCategoryIds(_ value : [String]) -> Self {
            return self
        }
  
    }
    
}

extension CreateOREditPNCDVC.CreateOREditPNCDRequestBuilder {
    
    
    func build() throws -> CreateOREditPNCDVC.CreateOrEditPNCDRequest {
        // Simple nil-only checks with specific errors. No complex logic.
        
        // Required Type
        guard let pncdType else {
            throw ValidationError.missingPNCDType
        }

        // Unwrap the Flag isAllowThisDiscountToStackWithOtherDiscounts
        guard let isAllowThisDiscountToStackWithOtherDiscounts else {
            throw ValidationError.missingIsAllowThisDiscountToStackWithOtherDiscountsFlag
        }
        
        // Validate Name Text
        guard let discountName, discountName.isEmpty == false else {
            throw ValidationError.missingDiscountName
        }
        // Validate Discount Value Text
        guard let discountValue, discountValue.isEmpty == false else {
            throw ValidationError.missingDiscountValue
        }
        
        // Unwrap Discount Type
        guard let discountType else {
            throw ValidationError.missingDiscountType
        }
        
        // Unwrap Schedule Type
        guard let scheduleType else {
            throw ValidationError.missingScheduleType
        }
        // Unwrap the Flag isThisDiscountHasNoEndDate
        guard let isThisDiscountHasNoEndDate else {
            throw ValidationError.missingIsThisDiscountHasNoEndDateFlag
        }
        
        guard let startDate else {
            throw ValidationError.missingStartDate
        }
        
        if (isThisDiscountHasNoEndDate == false), endDate == nil{
            throw ValidationError.missingEndDate
        }
        
        if (scheduleType == .repeatsOnSchedule) && selectedWeekDays.isEmpty {
            throw ValidationError.missingSelectedDays
        }
        
        // Unwrap the flag isThisDiscountIsActiveForFullDay
        guard let isThisDiscountIsActiveForFullDay else {
            throw ValidationError.missingIsThisDiscountIsActiveForFullDayFlag
        }
        
        if (scheduleType == .repeatsOnSchedule) && (isThisDiscountIsActiveForFullDay == false ) {
            
            if startTime == nil {
                throw ValidationError.missingStartTime
            }
            
            if endTime == nil {
                throw ValidationError.missingEndTime
            }
            
            if (startTime ?? .now() ) >= ( endTime ?? .now() ) {
                throw ValidationError.endTimeMustBegraterThanStartTime
            }
            
        }
        
        // Build a minimal request object from available fields.
        // Convert simple values to API strings where needed.
        let request = CreateOREditPNCDVC.CreateOrEditPNCDRequest(
            merchantId: merchantId,
            pNCDId: pNCDId,
            isDisable: isDisable ?? false,
            pncdType: pncdType,
            isAllowThisDiscountToStackWithOtherDiscounts: isAllowThisDiscountToStackWithOtherDiscounts,
            isThisDiscountHasNoEndDate: isThisDiscountHasNoEndDate,
            isThisDiscountIsActiveForFullDay: isThisDiscountIsActiveForFullDay,
            discountName: discountName,
            discount: discountValue,
            discountType: discountType,
            scheduleType: scheduleType,
            startDate: PNCDDateFormatter.shared.getStringToSendInAPI(startDate),
            endDate: PNCDDateFormatter.shared.getStringToSendInAPI(endDate),
            selectedWeekDays: WeekDayItemParser.stringify(selectedWeekDays),
            startTime: PNCDTimeFormatter.shared.getStringToSendInAPI(startTime),
            endTime: PNCDTimeFormatter.shared.getStringToSendInAPI(endTime)
        )
        
        return request
    }
    

}


extension CreateOREditPNCDVC.CreateOREditPNCDRequestBuilder {
    
    enum ValidationError: Error {
        
        case missingPNCDType
        
        case missingIsAllowThisDiscountToStackWithOtherDiscountsFlag
        case missingIsThisDiscountHasNoEndDateFlag
        case missingIsThisDiscountIsActiveForFullDayFlag
        
        case missingDiscountName
        case missingDiscountValue
        case missingDiscountType
        case missingScheduleType
        
        case missingStartDate
        case missingEndDate
        
        case missingSelectedDays
        
        case missingStartTime
        case missingEndTime
        case endTimeMustBegraterThanStartTime
        
        var recoverySuggestion: String {
            return switch self {
            case .missingPNCDType:
                "Please choose whether this discount applies to Products or Categories."
                
            case .missingIsAllowThisDiscountToStackWithOtherDiscountsFlag:
                "Please specify if this discount can be combined with other discounts."
                
            case .missingIsThisDiscountHasNoEndDateFlag:
                "Please indicate whether the discount has an end date."
                
            case .missingIsThisDiscountIsActiveForFullDayFlag:
                "Please specify if the discount should be active for the full day."
                
            case .missingDiscountName:
                "Enter a discount name. Example: Weekend Sale."
                
            case .missingDiscountValue:
                "Enter a discount value. Example: 10 or 10%."
                
            case .missingDiscountType:
                "Select a discount type (Amount or Percentage)."
                
            case .missingScheduleType:
                "Choose a schedule type (One Time or Repeats on Schedule)."
                
            case .missingStartDate:
                "Pick a start date to begin the discount."
                
            case .missingEndDate:
                "Pick an end date or enable ‘No End Date’."
                
            case .missingSelectedDays:
                "Select at least one weekday for the repeating schedule."
                
            case .missingStartTime:
                "Choose a start time or enable ‘Active for Full Day’."
                
            case .missingEndTime:
                "Choose an end time that is later than the start time."
                
            case .endTimeMustBegraterThanStartTime:
                "Set the end time to a value later than the start time."
            }
        }
        
    }
    
}
