//
//  TimeFormatHelper.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 16/01/26.
//

import Foundation


// MARK: - Time Helper

extension CreatePNCDVC {
    
    final class TimeFormatHelper {
        
        static let shared = TimeFormatHelper()
        private init() { }
        
        // Single format for both display and API
        private var timeFormat: String { "hh:mm a" }
        
        // MARK: - Cached formatter (thread-confined to this class)
        
        private lazy var timeFormatter: DateFormatter = {
            let df = DateFormatter()
            df.locale = Locale(identifier: "en_US_POSIX")
            df.timeZone = TimeZone.current
            df.dateFormat = timeFormat
            return df
        }()
        
        // MARK: - Public formatting (String input)
        
        // Since display and API share the same format, these are equivalent
        func formatTimeForDisplay(_ string: String?) -> String? {
            guard let date = parseTime(string) else { return nil }
            timeFormatter.timeZone = TimeZone.current
            timeFormatter.dateFormat = timeFormat
            return timeFormatter.string(from: date)
        }
        
        func formatTimeForDisplay(_ date: Date) -> String {
            timeFormatter.timeZone = TimeZone.current
            timeFormatter.dateFormat = timeFormat
            return timeFormatter.string(from: date)
        }
        func getFormattedTime(_ string: String?) -> Date {
            guard let dateString = formatTimeForDisplay(string) else { return .now() }
            return timeFormatter.date(from: dateString) ?? .now()
        }
        
        
        
        func formatTimeForAPI(_ string: String?) -> String? {
            guard let date = parseTime(string) else { return nil }
            timeFormatter.timeZone = TimeZone.current
            timeFormatter.dateFormat = timeFormat
            return timeFormatter.string(from: date)
        }

        func formatTimeForAPI(_ date: Date) -> String {
            timeFormatter.timeZone = TimeZone.current
            timeFormatter.dateFormat = timeFormat
            return timeFormatter.string(from: date)
        }
        
        // MARK: - Internal parser
        
        private func parseTime(_ string: String?) -> Date? {
            guard let s = string, s.isEmpty == false else { return nil }
            timeFormatter.timeZone = TimeZone.current
            timeFormatter.dateFormat = timeFormat
            return timeFormatter.date(from: s)
        }
    }

    
}
