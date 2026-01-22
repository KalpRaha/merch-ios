//
//  PNCDDiscountListItem.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 15/01/26.
//

import Foundation


struct GetDiscountListResponse: Decodable {
    
    var status: Bool
    var data: [PNCDDiscountListItem]?
    var totalRows, page, limit: Int?

    
    enum CodingKeys: String, CodingKey {
        case status, data
        case totalRows = "total_rows"
        case page, limit
    }
}


struct PNCDDiscountListItem: Decodable {
    
    var id, merchantID: String?
    var description: String?
    var discount, items: String?
    
    private var _dealName: String?
    private var _discountType: String?
    
    // Flags
    private var _noEndDate: String?
    private var _useWithCoupon: String?
    private var _isDiscountDisable: String?
    private var _useStatus: String?
    private var _fullDay: String?
    
    private var _scheduleType: String?
    private var _type: String?
    
    private var _weeklyDays: String?
    private var monthlyDates: String?
    
    var startDate, endDate: String?
    var startTime, endTime: String?
        
    
    var createdAt, updatedAt, isDeleted, updatedTimestamp: String?

    enum CodingKeys: String, CodingKey {
        case id
        case merchantID = "merchant_id"
        case _dealName = "deal_name"
        case description
        case startDate = "start_date"
        case endDate = "end_date"
        case startTime = "start_time"
        case endTime = "end_time"
        case discount
        case _discountType = "discount_type"
        case items
        case _type = "type"
        case _noEndDate = "no_end_date"
        case _useWithCoupon = "use_with_coupon"
        case _isDiscountDisable = "is_disable"
        case _useStatus = "use_status"
        case _fullDay = "full_day"
        case _scheduleType = "repeat_type"
        case _weeklyDays = "weekly_days"
        case monthlyDates = "monthly_dates"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case isDeleted = "is_deleted"
        case updatedTimestamp = "updated_timestamp"
        // case associatedItems = "associated_items"
    }

}

extension PNCDDiscountListItem {
    
    func getDisplayValue() -> String {
        let amountSymbolStringValue = discountType.stringValue
        let discountValue = discount ?? "0.0"
        return discountType == .amountValue ? "\(amountSymbolStringValue) \(discountValue)" : "\(discountValue) \(amountSymbolStringValue)"
    }
    
}

extension PNCDDiscountListItem {
    
    var discountName : String {
        _dealName ?? "Title"
    }
    
    var type : PNCDType {
        PNCDType.parse(_type) ?? .product
    }
    
    var discountType : DiscountInputValueType {
        DiscountInputValueType.parse(_discountType)
    }
    
    var scheduleType: PNCDScheduleType {
        PNCDScheduleType.parse(_scheduleType)
    }
    
    // Convenience parsed weekly days into UI enum
    var selectedWeekDays: [WeekDayItem] {
        WeekDayItemParser.parse(_weeklyDays)
    }
}

extension PNCDDiscountListItem {
    
    // Discount Enable / Disable Flag
    var isDiscountDisable: Bool {
        (_isDiscountDisable?.isTrue() ?? false) == true
    }
    
    mutating func updateDiscountDisableFlag(_ flag: Bool) {
        _isDiscountDisable = flag.toString()
    }
    
    
    // Discount has End Date Or Not Flag
    var isThisDealHasNoEndDate: Bool {
        // Your toBool() only recognizes "true"/"false"; prefer isTrue() for "1"/"0"
        (_noEndDate?.isTrue() ?? false) == true
    }
    
    var isAllowThisDiscountToStackWithOtherDiscounts: Bool {
        (_useWithCoupon?.isTrue() ?? false) == true
    }
    
    // Expose use_status as Bool
    var isUseStatusEnabled: Bool {
        (_useStatus?.isTrue() ?? false) == true
    }
    
    // Expose full_day as Bool
    var isDealActiveForFullDay: Bool {
        (_fullDay?.isTrue() ?? false) == true
    }
    
}
