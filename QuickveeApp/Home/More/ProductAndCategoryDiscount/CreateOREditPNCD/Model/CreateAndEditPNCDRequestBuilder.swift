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
        
        
        func setIsAllowThisDiscountToStackWithOtherDiscounts(_ flag : Bool) -> Self {
            isAllowThisDiscountToStackWithOtherDiscounts = flag
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
        
        if (isThisDiscountHasNoEndDate == false), endTime == nil{
            throw ValidationError.missingEndDate
        }
        
        if selectedWeekDays.isEmpty {
            throw ValidationError.missingSelectedDays
        }
        
        // Unwrap the flag isThisDiscountIsActiveForFullDay
        guard let isThisDiscountIsActiveForFullDay else {
            throw ValidationError.missingIsThisDiscountIsActiveForFullDayFlag
        }
        
        if (isThisDiscountIsActiveForFullDay == false ) {
            
            if startTime == nil {
                throw ValidationError.missingStartDate
            }
            
            if endTime == nil {
                throw ValidationError.missingEndTime
            }
            
            if (startTime ?? .now() ) <= ( endTime ?? .now() ) {
                throw ValidationError.endTimeMustBegraterThanStartTime
            }
            
        }
        
        // Build a minimal request object from available fields.
        // Convert simple values to API strings where needed.
        let request = CreateOREditPNCDVC.CreateOrEditPNCDRequest(
            merchantId: merchantId,
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
        
    }
    
}
