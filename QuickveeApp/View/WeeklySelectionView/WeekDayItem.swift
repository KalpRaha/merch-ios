//
//  WeekDayItem.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 20/01/26.
//

import Foundation

enum WeekDayItem {
    
    case mon
    case tue
    case wed
    case thu
    case fri
    case sat
    case sun
    
    var title : String {
        switch self {
        case .mon: "MON"
        case .tue: "TUE"
        case .wed: "WED"
        case .thu: "THU"
        case .fri: "FRI"
        case .sat: "SAT"
        case .sun: "SUN"
        }
    }
    
    static var dataSource : [Self] = [
        .sun, .mon, .tue, .wed, .thu, .fri, .sat
    ]
    
}

extension WeekDayItem {
    
    static func getItemFromIndex(_ index : Int) -> Self {
        return switch index {
             
         case 0 : .sun
         case 1 : .mon
         case 2 : .tue
         case 3 : .wed
         case 4 : .thu
         case 5 : .fri
         case 6 : .sat
             
         default : .sun
         }
    }
    
    func getIndex() -> Int{
        
        return switch self {
        case .sun: 0
        case .mon: 1
        case .tue: 2
        case .wed: 3
        case .thu: 4
        case .fri: 5
        case .sat: 6

        }
        
    }
}

