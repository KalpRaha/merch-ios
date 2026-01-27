//
//  PNCDScheduleType.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 12/01/26.
//

import Foundation


enum PNCDScheduleType : String, CaseIterable, Codable {
    
    case oneTime = "0"
    case repeatsOnSchedule = "1"
    
    var stringValue : String {
        switch self {
        case .oneTime: "One-Time Date Range"
        case .repeatsOnSchedule: "Repeats on a Schedule"
        }
    }
    
}

extension PNCDScheduleType {
    
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
    
    var apiValue: String {
        switch self {
        case .oneTime: "0"
        case .repeatsOnSchedule: "1"
        }
    }
     
}

extension PNCDScheduleType {
    
    func getIndex() -> Int {
        switch self {
        case .oneTime: 0
        case .repeatsOnSchedule: 1
        }
    }
    
    static func getFromIndex(_ index: Int) -> Self {
        return switch index {
        case 0: .oneTime
        case 1: .repeatsOnSchedule
            
        default: .oneTime
        }
    }
    
}
