//
//  DateNTimeHelper.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 16/01/26.
//

import Foundation


protocol CreatePNCDDateAndTimeUIUpdateDelegate : AnyObject{
    
    func didUpdatedStartDate()
    func didUpdatedEndDate()
    
    func didUpdatedStartTime()
    func didUpdatedEndTime()
    
}

extension CreatePNCDVC {
    
    class DateNTimeHelper {
        
        weak var timeUIUpdateDelegate: CreatePNCDDateAndTimeUIUpdateDelegate?
        
        var startDate : Date? {
            didSet{
                timeUIUpdateDelegate?.didUpdatedStartDate()
            }
        }
        var endDate : Date? {
            didSet{
                timeUIUpdateDelegate?.didUpdatedEndDate()
            }
        }
        
        var startTime : Date? {
            didSet{
                timeUIUpdateDelegate?.didUpdatedStartTime()
            }
        }
        var endTime : Date? {
            didSet{
                timeUIUpdateDelegate?.didUpdatedEndTime()
            }
        }
        
    }
    
}
