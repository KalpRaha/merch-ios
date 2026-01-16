//
//  DateFormatHelper.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 16/01/26.
//

import Foundation

extension CreatePNCDVC{
    
    final class DateFormatHelper {
        
        static let shared = DateFormatHelper()
        private init() { }
        
        // Output formats
        private var inputDateFormat: String { "dd/MM/yyyy" }
        private var outputDateFormat: String { "yyyy-MM-dd" }
        
        // MARK: - Cached formatters (thread-confined to this class)
        
        private lazy var dateFormatter : DateFormatter = {
            let df = DateFormatter()
            df.locale = Locale(identifier: "en_US_POSIX")
            df.timeZone = TimeZone(secondsFromGMT: 0)
            df.dateFormat = "yyyy-MM-dd"
            return df
            
        }()
        
        // MARK: - Public formatting (String input)
        
        func formatDateForDisplay(_ string: String? ) -> String? {
            guard let date = parseDate(string) else { return nil }
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = inputDateFormat
            return dateFormatter.string(from: date)
        }
        
        func formatDateForDisplay(_ date: Date) -> String {
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = inputDateFormat
            return dateFormatter.string(from: date)
        }
        
        func getFormattedDate(_ string: String? ) -> Date {
            guard let dateString = formatDateForDisplay(string) else { return .now() }
            return dateFormatter.date(from: dateString) ?? .now()
        }
        
        
        
        // Converts from server/raw date (yyyy-MM-dd) to API-required "yyyy/MM/dd"
        func formatDateForAPI(_ string : String?) -> String? {
            guard let date = parseDate(string) else { return nil }
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            dateFormatter.dateFormat = outputDateFormat
            return dateFormatter.string(from: date)
        }
        
        func formatDateForAPI(_ date: Date) -> String {
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            dateFormatter.dateFormat = outputDateFormat
            return dateFormatter.string(from: date)
        }
        
        // MARK: - Internal parsers
        
        private func parseDate(_ string : String?) -> Date? {
            guard let s = string, s.isEmpty == false else { return nil }
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            dateFormatter.dateFormat = outputDateFormat
            return dateFormatter.date(from: s)
        }
        
    }
}
