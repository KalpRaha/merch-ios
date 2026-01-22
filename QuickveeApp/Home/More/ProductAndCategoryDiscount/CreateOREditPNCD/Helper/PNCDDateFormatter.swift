//
//  PNCDDateFormatter.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 16/01/26.
//

import Foundation


final class PNCDDateFormatter {
    
    static let shared = PNCDDateFormatter()
    private init() { }
    
    private var displayDateStringFormat: String { "dd/MM/yyyy" }
    private var receiveFromApiDateFormat: String { "yyyy-MM-dd" }
    
    // MARK: - formatters
    
    private lazy var dateFormatter : DateFormatter = {
        let df = DateFormatter()
        df.locale = .enUSPosix
        df.timeZone = .current
        df.dateFormat = receiveFromApiDateFormat
        return df
        
    }()
    
}


extension PNCDDateFormatter {
    
    // MARK: - Internal parsers
    
    func parseFromAPI(_ string : String?) -> Date? {
        guard let s = string, s.isEmpty == false else { return nil }
        dateFormatter.dateFormat = receiveFromApiDateFormat
        return dateFormatter.date(from: s)
    }
    
    
    func getStringToDisplay(_ date: String?) -> String {
        guard let s = date, s.isEmpty == false,
              let date = parseFromAPI(s)
        else { return "NA" }
        return getStringToDisplay(date)
    }
    
    func getStringToDisplay(_ date: Date) -> String {
        dateFormatter.dateFormat = displayDateStringFormat
        return dateFormatter.string(from: date)
    }
    
    
    func getStringToSendInAPI(_ date : Date) -> String {
        dateFormatter.dateFormat = receiveFromApiDateFormat
        return dateFormatter.string(from: date)
    }
    
}
