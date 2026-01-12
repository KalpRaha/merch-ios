//
//  ScheduleType.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 12/01/26.
//

import Foundation


enum ScheduleType : String, CaseIterable {
    
    case oneTime
    case repeatsOnSchedule
    
    var stringValue : String {
        switch self {
        case .oneTime: "One-Time Date Range"
        case .repeatsOnSchedule: "Repeats on a Schedule"
        }
    }
}
