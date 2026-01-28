//
//  CreateOrEditPNCDRequest.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 15/01/26.
//

import Foundation

extension CreateOREditPNCDVC {

    struct CreateOrEditPNCDRequest: Codable {
        
        var boundary: String = UUID().uuidString
        
        
        var merchantId: String
        var pNCDId: String?
        var isDisable: Bool
        
        var pncdType: PNCDType
        var isAllowThisDiscountToStackWithOtherDiscounts: Bool
        var isThisDiscountHasNoEndDate: Bool
        var isThisDiscountIsActiveForFullDay: Bool
        
        var discountName: String
        var discount: String
        var discountType: DiscountInputValueType
        
        var scheduleType : PNCDScheduleType
        
        var startDate: String?
        var endDate: String?

        var selectedWeekDays: String

        var startTime: String?
        var endTime: String?

        
        init(
            merchantId: String,
            pNCDId: String? = nil,
            isDisable: Bool,
            pncdType: PNCDType,
            isAllowThisDiscountToStackWithOtherDiscounts: Bool,
            isThisDiscountHasNoEndDate: Bool,
            isThisDiscountIsActiveForFullDay: Bool,
            discountName: String,
            discount: String,
            discountType: DiscountInputValueType,
            scheduleType: PNCDScheduleType,
            startDate: String? = nil,
            endDate: String? = nil,
            selectedWeekDays: String,
            startTime: String? = nil,
            endTime: String? = nil
        ) {
            self.merchantId = merchantId
            self.pNCDId = pNCDId
            self.isDisable = isDisable
            self.pncdType = pncdType
            self.isAllowThisDiscountToStackWithOtherDiscounts = isAllowThisDiscountToStackWithOtherDiscounts
            self.isThisDiscountHasNoEndDate = isThisDiscountHasNoEndDate
            self.isThisDiscountIsActiveForFullDay = isThisDiscountIsActiveForFullDay
            self.discountName = discountName
            self.discount = discount
            self.discountType = discountType
            self.scheduleType = scheduleType
            self.startDate = startDate
            self.endDate = endDate
            self.selectedWeekDays = selectedWeekDays
            self.startTime = startTime
            self.endTime = endTime
        }
        
    }

}

extension CreateOREditPNCDVC.CreateOrEditPNCDRequest: MultiPartRequestBodyType {
  
    func buildMultiPartBodyBuilder() -> MultipartFormDataBodyBuilder {
        var entries: [MultipartFormDataEntry] = []

        // merchant_id is required (always append even if nil to keep behavior explicit)
        entries.append(.string(paramName: "merchant_id", value: merchantId))
        
        if let pNCDId{
            entries.append(.string(paramName: "id", value: pNCDId))
        }
        
        entries.append(.string(paramName: "type", value: pncdType.apiValue()))
        
        // Flags
        entries.append(.string(
            paramName: "is_disable",
            value: isDisable.toString()
        ))
        
        entries.append(.string(
            paramName: "use_with_coupon",
            value: isAllowThisDiscountToStackWithOtherDiscounts.toString()
        ))
        entries.append(.string(
            paramName: "no_end_date",
            value: isThisDiscountHasNoEndDate.toString()
        ))
        entries.append(.string(
            paramName: "full_day",
            value: ((scheduleType == .oneTime) ? true : isThisDiscountIsActiveForFullDay).toString()
        ))
        
        
        // Discount Name And Value & Type
        entries.append(.string(paramName: "deal_name", value: discountName))
        entries.append(.string(paramName: "discount", value: discount))
        entries.append(.string(paramName: "discount_type", value: discountType.apiValue))
        
        // ScheduleType
        entries.append(.string(paramName: "repeat_type", value: scheduleType.apiValue ))
        
        entries.append(.string(
            paramName: "start_date",
            value: startDate ?? ""
        ))
        
        entries.append(.string(
            paramName: "end_date",
            value: (isThisDiscountHasNoEndDate == false) ? endDate : ""
        ))
        
        entries.append(.string(paramName: "weekly_days", value: selectedWeekDays ))
        
        // Time
        if (isThisDiscountIsActiveForFullDay == false) {
            entries.append(.string(
                paramName: "start_time",
                value: startTime ?? "00:00:00"
            ))
            
            entries.append(.string(
                paramName: "end_time",
                value: endTime ?? "00:00:00"
            ))
        }
        
        
        entries.append(.string(paramName: "items", value: ""))
//        entries.append(.string(paramName: "description", value: ""))
//        entries.append(.string(paramName: "monthly_dates", value: ""))
        

        return MultipartFormDataBodyBuilder(
            boundary: boundary,
            entries: entries
        )
    }
}
