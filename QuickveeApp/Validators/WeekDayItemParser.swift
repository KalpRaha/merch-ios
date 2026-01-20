//
//  WeekDayItemParser.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 20/01/26.
//

import Foundation


class WeekDayItemParser {
    
    static func parse(_ items: String?) -> [WeekDayItem] {
        // Supports inputs like: "Mon, Wed, Fri" (case-insensitive),
        // and also common variants like "Tues", "Thurs", "Wednesday", etc.
        guard let items, !items.isEmpty else { return [] }
        
        let tokens = items.split(separator: ",")
        
        return tokens.compactMap { token in
            let normalized = token
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .lowercased()
                .filter { $0.isLetter } // drop punctuation like periods
            
            return switch normalized {
            case "m", "mo", "mon", "monday": .mon
            case "t", "tu", "tue", "tues", "tuesday": .tue
            case "w", "we", "wed", "weds", "wednesday": .wed
            case "th", "thu", "thur", "thurs", "thursday": .thu
            case "f", "fr", "fri", "friday": .fri
            case "sa", "sat", "saturday": .sat
            case "su", "sun", "sunday": .sun
            default: nil
            }
        }
    }
    
    static func stringify(_ items: [WeekDayItem]?) -> String {
        // Produces outputs like: "Mon, Wed, Fri"
        guard let items, !items.isEmpty else { return "" }
        return items.map { item in
            let lower = item.title.lowercased() // "mon"
            return lower.prefix(1).uppercased() + lower.dropFirst() // "Mon"
        }
        .joined(separator: ", ")
    }
    
}
