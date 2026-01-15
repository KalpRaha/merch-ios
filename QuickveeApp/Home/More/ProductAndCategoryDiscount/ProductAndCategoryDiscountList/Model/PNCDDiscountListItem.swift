//
//  PNCDDiscountListItem.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 15/01/26.
//

import Foundation


struct GetDiscountListResponse: Decodable {
    
    var status: Bool?
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
    var dealName, description: String?
    var discount, discountType, items: String?
    
    // Flags
    private var _noEndDate: String?
    private var _useWithCoupon: String?
    private var _isDiscountDisable: String?
    private var _useStatus: String?
    private var _fullDay: String?
    
    var repeatType: ScheduleType?
    var type: String?
    
    var startDate, endDate: String?
    var startTime, endTime: String?
        
    private var _weeklyDays: String?
    private var monthlyDates: String?
    
    
    var createdAt, updatedAt, isDeleted, updatedTimestamp: String?

    
    enum CodingKeys: String, CodingKey {
        
        case id
        case merchantID = "merchant_id"

        case dealName = "deal_name"
        case description
        
        case startDate = "start_date"
        case endDate = "end_date"
        case startTime = "start_time"
        case endTime = "end_time"
        
        case discount
        case discountType = "discount_type"
        case items
        case type
        
        case _noEndDate = "no_end_date"
        case _useWithCoupon = "use_with_coupon"
        case _isDiscountDisable = "is_disable"
        case _useStatus = "use_status"
        case _fullDay = "full_day"
        
        case repeatType = "repeat_type"
        case _weeklyDays = "weekly_days"
        case monthlyDates = "monthly_dates"
        
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case isDeleted = "is_deleted"
        case updatedTimestamp = "updated_timestamp"
//        case associatedItems = "associated_items"
    }
    
    
}

extension PNCDDiscountListItem {
    
    var isThisDealHasNoEndDate : Bool {
        (_noEndDate?.toBool() ?? false) == true
    }
    
    var isUseWithCoupon: Bool {
        (_useWithCoupon?.toBool() ?? false) == true
    }
    
    
    var isDiscountDisable: Bool {
        (_isDiscountDisable?.toBool() ?? false) == true
    }
    
    // New: expose use_status as Bool
    var isUseStatusEnabled: Bool {
        (_useStatus?.toBool() ?? false) == true
    }
    
    // New: expose full_day as Bool
    var isDealActiveForFullDay: Bool {
        (_fullDay?.toBool() ?? false) == true
    }
    
    // New: expose weekly_days raw string
    var weeklyDaysRaw: String? {
        _weeklyDays
    }
    
    // New: convenience parsed weekly days into UI enum
    var weeklyDays: [WeeklySelectionView.WeekDayItem] {
        guard let raw = _weeklyDays, raw.isEmpty == false else { return [] }
        
        // Accept comma-separated day codes or indices. Examples:
        // "SUN,MON,TUE" or "0,1,2"
        let parts = raw
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines).uppercased() }
        
        func mapToken(_ token: String) -> WeeklySelectionView.WeekDayItem? {
            switch token {
            case "SUN", "0": return .sun
            case "MON", "1": return .mon
            case "TUE", "2": return .tue
            case "WED", "3": return .wed
            case "THU", "4": return .thu
            case "FRI", "5": return .fri
            case "SAT", "6": return .sat
            default: return nil
            }
        }
        
        return parts.compactMap { mapToken($0) }
    }
}

