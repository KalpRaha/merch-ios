//
//  CategoryDataModel.swift
//  QuickveeApp
//
//  Created by Pallavi on 13/01/26.
//

import Foundation

struct CategoryDataModel: Codable {

    var id: String

    var title: String?
    var description: String?
    var categoryBanner: String?

    var showOnline: String?
    var showStatus: String?
    var catShowStatus: String?

    var isLottery: String?
    var alternateName: String?
    var merchantId: String?
    var isDeleted: String?
    var userId: String?

    var createdOn: String?
    var updatedOn: String?
    var adminId: String?

    var usePoint: String?
    var earnPoint: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case categoryBanner = "categoryBanner"

        case showOnline = "show_online"
        case showStatus = "show_status"
        case catShowStatus = "cat_show_status"

        case isLottery = "is_lottery"
        case alternateName = "alternateName"
        case merchantId = "merchant_id"
        case isDeleted = "is_deleted"
        case userId = "user_id"

        case createdOn = "created_on"
        case updatedOn = "updated_on"
        case adminId = "admin_id"

        case usePoint = "use_point"
        case earnPoint = "earn_point"
    }
}
