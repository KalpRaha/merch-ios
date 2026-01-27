//
//  PNCDDateTimeCombiner.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 23/01/26.
//

import Foundation

class PNCDDateTimeCombiner {
    
    static func combine(
        date : String?,
        time: String?,
        timeZone: TimeZone = .current,
        locale: Locale = .current
        
    ) -> Date? {
        
        // Use local calendar and time zone (device's current time zone)
        let calendar = Calendar.current

        guard
            let date = PNCDDateFormatter.shared.parseFromAPI(date),
            let timeDate = PNCDTimeFormatter.shared.parseFromAPI(time)
        else {
            return nil
        }
        
        // Extract date components (year, month, day)
        var components = calendar.dateComponents([.year, .month, .day], from: date)
        
        // Extract time components (hour, minute, second)
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: timeDate)
        
        // Combine them
        components.hour = timeComponents.hour
        components.minute = timeComponents.minute
        components.second = timeComponents.second
        
        // Create the final Date in local time zone
        guard let combinedDate = calendar.date(from: components) else { return nil }
        print("Combined Date: \(combinedDate)")  // For debugging: e.g., "Jan 22, 2026 at 10:30:00 AM"
        
        printDate(date: combinedDate, timeZone: timeZone, locale: locale)
        
        return combinedDate
    }
    
    
    private static func printDate(
        date: Date,
        timeZone: TimeZone,
        locale: Locale
    ) {
        let displayFormatter = DateFormatter()
        displayFormatter.dateStyle = .medium
        displayFormatter.timeStyle = .medium
        displayFormatter.timeZone = timeZone
        displayFormatter.locale = locale
        
        Logger.log("✅ Local: \(displayFormatter.string(from: date ))")
        Logger.log("📊 UTC: \(date)")
    }
    
}
