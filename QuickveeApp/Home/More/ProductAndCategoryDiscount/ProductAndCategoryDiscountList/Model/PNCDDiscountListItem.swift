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
    var dealName, description: String?
    var discount, items: String?
    
    var discountType: DiscountPerItemDiscountType?
    
    // Flags
    private var _noEndDate: String?
    private var _useWithCoupon: String?
    private var _isDiscountDisable: String?
    private var _useStatus: String?
    private var _fullDay: String?
    
    var scheduleType: ScheduleType?
    var type: ProductAndCategoryDiscountType? = nil
    
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
        case scheduleType = "repeat_type"
        case _weeklyDays = "weekly_days"
        case monthlyDates = "monthly_dates"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case isDeleted = "is_deleted"
        case updatedTimestamp = "updated_timestamp"
        // case associatedItems = "associated_items"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decodeIfPresent(String.self, forKey: .id)
        merchantID = try container.decodeIfPresent(String.self, forKey: .merchantID)
        
        dealName = try container.decodeIfPresent(String.self, forKey: .dealName)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        
        startDate = try container.decodeIfPresent(String.self, forKey: .startDate)
        endDate = try container.decodeIfPresent(String.self, forKey: .endDate)
        startTime = try container.decodeIfPresent(String.self, forKey: .startTime)
        endTime = try container.decodeIfPresent(String.self, forKey: .endTime)
        
        discount = try container.decodeIfPresent(String.self, forKey: .discount)
        items = try container.decodeIfPresent(String.self, forKey: .items)
        
        // Discount type can be "1"/"2" (string) or 1/2 (int); the enum handles both
        discountType = try container.decodeIfPresent(DiscountPerItemDiscountType.self, forKey: .discountType)
        
        // Flags arrive as "0"/"1" strings; keep raw and compute later
        _noEndDate = try container.decodeIfPresent(String.self, forKey: ._noEndDate)
        _useWithCoupon = try container.decodeIfPresent(String.self, forKey: ._useWithCoupon)
        _isDiscountDisable = try container.decodeIfPresent(String.self, forKey: ._isDiscountDisable)
        _useStatus = try container.decodeIfPresent(String.self, forKey: ._useStatus)
        _fullDay = try container.decodeIfPresent(String.self, forKey: ._fullDay)
        
        // Schedule type "0"/"1" as string; let enum handle it if it supports string values
        scheduleType = try container.decodeIfPresent(ScheduleType.self, forKey: .scheduleType)
        
        // Robustly decode `type`: accept "product"/"category", "1"/"2", empty/"0" => nil
        if let rawTypeString = try container.decodeIfPresent(String.self, forKey: .type) {
            
            type = .parse(rawTypeString)
            
        } else {
            type = nil
        }
        
        _weeklyDays = try container.decodeIfPresent(String.self, forKey: ._weeklyDays)
        monthlyDates = try container.decodeIfPresent(String.self, forKey: .monthlyDates)
        
        createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt)
        isDeleted = try container.decodeIfPresent(String.self, forKey: .isDeleted)
        updatedTimestamp = try container.decodeIfPresent(String.self, forKey: .updatedTimestamp)
    }
}

extension PNCDDiscountListItem {
    
    var isThisDealHasNoEndDate: Bool {
        // Your toBool() only recognizes "true"/"false"; prefer isTrue() for "1"/"0"
        (_noEndDate?.isTrue() ?? false) == true
    }
    
    var isAllowThisDiscountToStackWithOtherDiscounts: Bool {
        (_useWithCoupon?.isTrue() ?? false) == true
    }
    
    var isDiscountDisable: Bool {
        (_isDiscountDisable?.isTrue() ?? false) == true
    }
    
    // Expose use_status as Bool
    var isUseStatusEnabled: Bool {
        (_useStatus?.isTrue() ?? false) == true
    }
    
    // Expose full_day as Bool
    var isDealActiveForFullDay: Bool {
        (_fullDay?.isTrue() ?? false) == true
    }
    
    // Expose weekly_days raw string
    var weeklyDaysRaw: String? {
        _weeklyDays
    }
    
    // Convenience parsed weekly days into UI enum
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
