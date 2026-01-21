//
//  BogoDataModel.swift
//  QuickveeApp
//
//  Created by Pallavi on 13/01/26.
//

import Foundation

struct BogoDataModelRes : Decodable {
    
    let status : Bool?
    let message : String?
    let result : [BogoDataModel]
    
    enum CodingKeys: String, CodingKey {
        case status
        case message = "msg"
        case result = "bogo_list"
    }
    
}



struct BogoDataModel: Codable {

    let id: String

    let merchantId: String?
    let startDate: String?
    let endDate: String?
    let dealName: String?
    let desc: String?
    let noEndDate: String?
    let useWithCoupon: String?

    let buyQty: String?
    let freeQty: String?

    let discount: String?
    let discountType: String?

    let isDisable: String?
    
    let useStatus: String?

    let fullDay: String?
    let startTime: String?
    let endTime: String?

    let repeatType: String?
    let weeklyDays: String?
    let monthlyDates: String?

    let createdAt: String?
    let updatedAt: String?
    let isDeleted: String?
    
    
    private let _items: String?
    var items: [String] {
        PNCDItemIDExtractor.extract(from: _items ?? "")
    }

    enum CodingKeys: String, CodingKey {
        case id

        case merchantId = "merchant_id"
        case startDate = "start_date"
        case endDate = "end_date"
        case dealName = "deal_name"
        case desc

        case noEndDate = "no_end_date"
        case useWithCoupon = "use_with_coupon"

        case buyQty = "buy_qty"
        case freeQty = "free_qty"

        case discount
        case discountType = "discount_type"

        case isDisable = "is_disable"
        case _items = "items"
        case useStatus = "use_status"

        case fullDay = "full_day"
        case startTime = "start_time"
        case endTime = "end_time"

        case repeatType = "repeat_type"
        case weeklyDays = "weekly_days"
        case monthlyDates = "monthly_dates"

        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case isDeleted = "is_deleted"
    }
}

