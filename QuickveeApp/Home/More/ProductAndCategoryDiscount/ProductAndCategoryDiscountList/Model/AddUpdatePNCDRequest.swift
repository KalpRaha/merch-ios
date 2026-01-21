//
//  AddUpdatePNCDRequest.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 15/01/26.
//

import Foundation

extension CreateOREditPNCDVC {

    struct AddUpdatePNCDRequest: Codable {
        
        var merchantId: String
        var pNCDId: String?
        var dealName: String?
        var description: String?
        var noEndDate: String?
        var useWithCoupon: String?
        var discount: String?
        var discountType: String?
        var isDisable: String?
        var items: String?
        var startDate: String?
        var endDate: String?
        var fullDay: String?
        var startTime: String?
        var endTime: String?
        var repeatType: String?
        var weeklyDays: String?
        var monthlyDates: String?
        var type: String?

        init(
            merchantId: String,
            pNCDId: String? = nil,
            dealName: String? = nil,
            description: String? = nil,
            noEndDate: String? = nil,
            useWithCoupon: String? = nil,
            discount: String? = nil,
            discountType: String? = nil,
            isDisable: String? = nil,
            items: String? = nil,
            startDate: String? = nil,
            endDate: String? = nil,
            fullDay: String? = nil,
            startTime: String? = nil,
            endTime: String? = nil,
            repeatType: String? = nil,
            weeklyDays: String? = nil,
            monthlyDates: String? = nil,
            type: String? = nil
        ) {
            self.merchantId = merchantId
            self.dealName = dealName
            self.description = description
            self.noEndDate = noEndDate
            self.useWithCoupon = useWithCoupon
            self.discount = discount
            self.discountType = discountType
            self.isDisable = isDisable
            self.items = items
            self.startDate = startDate
            self.endDate = endDate
            self.pNCDId = pNCDId
            self.fullDay = fullDay
            self.startTime = startTime
            self.endTime = endTime
            self.repeatType = repeatType
            self.weeklyDays = weeklyDays
            self.monthlyDates = monthlyDates
            self.type = type
        }
    }

}

extension CreateOREditPNCDVC.AddUpdatePNCDRequest: MultiPartRequestBodyType {
    
    var boundary: String {  UUID().uuidString }

    func buildMultiPartBodyBuilder() -> MultipartFormDataBodyBuilder {
        var entries: [MultipartFormDataEntry] = []

        // merchant_id is required (always append even if nil to keep behavior explicit)
        entries.append(.string(paramName: "merchant_id", value: merchantId))

        if let dealName {
            entries.append(.string(paramName: "deal_name", value: dealName))
        }
        
        if let description {
            entries.append(.string(paramName: "description", value: description))
        }
        
        if let noEndDate {
            entries.append(.string(paramName: "no_end_date", value: noEndDate))
        }
        
        if let useWithCoupon {
            entries.append(.string(paramName: "use_with_coupon", value: useWithCoupon))
        }
        
        if let discount {
            entries.append(.string(paramName: "discount", value: discount))
        }
        
        if let discountType {
            entries.append(.string(paramName: "discount_type", value: discountType))
        }
        
        if let isDisable {
            entries.append(.string(paramName: "is_disable", value: isDisable))
        }
        
        if let items {
            entries.append(.string(paramName: "items", value: items))
        }
        
        if let startDate {
            entries.append(.string(paramName: "start_date", value: startDate))
        }
        
        if let endDate {
            entries.append(.string(paramName: "end_date", value: endDate))
        }
        
        if let pNCDId {
            entries.append(.string(paramName: "id", value: pNCDId))
        }
        
        if let fullDay {
            entries.append(.string(paramName: "full_day", value: fullDay))
        }
        
        if let startTime {
            entries.append(.string(paramName: "start_time", value: startTime))
        }
        
        if let endTime {
            entries.append(.string(paramName: "end_time", value: endTime))
        }
        
        if let repeatType {
            entries.append(.string(paramName: "repeat_type", value: repeatType))
        }
        
        if let weeklyDays {
            entries.append(.string(paramName: "weekly_days", value: weeklyDays))
        }
        
        if let monthlyDates {
            entries.append(.string(paramName: "monthly_dates", value: monthlyDates))
        }
        
        if let type {
            entries.append(.string(paramName: "type", value: type))
        }

        return MultipartFormDataBodyBuilder(
            boundary: boundary,
            entries: entries
        )
    }
}
