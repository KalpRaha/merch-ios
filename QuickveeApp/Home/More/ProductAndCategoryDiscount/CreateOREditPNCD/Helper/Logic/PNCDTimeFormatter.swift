//
//  PNCDTimeFormatter.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 16/01/26.
//

import Foundation


final class PNCDTimeFormatter {
    
    static let shared = PNCDTimeFormatter()
    private init() { }
    
    // Single format for both display and API
    private var receiveFromApiTimeFormat: String { "HH:mm:ss" }
    private var displayTimeFormat: String { "hh:mm a"}
    
    
    // MARK: - formatters
    
    private lazy var timeFormatter: DateFormatter = {
        let df = DateFormatter()
        df.locale = .enUSPosix
        df.timeZone = .current
        df.dateFormat = receiveFromApiTimeFormat
        return df
    }()
    
}


extension PNCDTimeFormatter {
    
    // MARK: - Internal parsers
    
    func parseFromAPI(_ string : String?) -> Date? {
        guard let s = string, s.isEmpty == false else { return nil }
        timeFormatter.dateFormat = receiveFromApiTimeFormat
        return timeFormatter.date(from: s)
    }
    
    
    func getStringToDisplay(_ date : String?) -> String {
        guard let s = date, s.isEmpty == false,
              let date = parseFromAPI(s)
        else { return "N/A" }
        return getStringToDisplay(date)
    }
    
    func getStringToDisplay(_ date : Date) -> String {
        timeFormatter.dateFormat = displayTimeFormat
        return timeFormatter.string(from: date)
    }
    
    
    func getStringToSendInAPI(_ date : Date?) -> String? {
        guard let date else { return nil }
        timeFormatter.dateFormat = receiveFromApiTimeFormat
        return timeFormatter.string(from: date)
    }
    
}
