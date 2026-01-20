//
//  ScheduleType.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 12/01/26.
//

import Foundation


enum ScheduleType : String, CaseIterable {
    
    case oneTime = "0"
    case repeatsOnSchedule = "1"
    
    var stringValue : String {
        switch self {
        case .oneTime: "One-Time Date Range"
        case .repeatsOnSchedule: "Repeats on a Schedule"
        }
    }
}

extension ScheduleType : Decodable {
    
    enum CodingKeys: String, CodingKey {
        case oneTime = "0"
        case repeatsOnSchedule = "1"
    }

    static func parse(_ type : String?) -> Self {
        return switch type {
        case "0": .oneTime
        case "1": .repeatsOnSchedule
        default: .oneTime
        }
    }
    
    func apiValue() -> String {
        switch self {
        case .oneTime: "0"
        case .repeatsOnSchedule: "1"
        }
    }
    
}
