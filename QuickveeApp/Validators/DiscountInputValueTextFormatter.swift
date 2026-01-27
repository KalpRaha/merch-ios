//
//  DiscountInputValueTextFormatter.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 09/01/26.
//

import Foundation


class DiscountInputValueTextFormatter {
    
    static func format(
        _ inputText : String,
        type : DiscountInputValueType
        
    ) -> String {
       
        var cleanedAmount = ""
        
        for character in inputText{
            if character.isNumber {
                cleanedAmount.append(character)
            }
        }
        
//        if type == .percentValue {
//            cleanedAmount = String(cleanedAmount.dropLast())
//        }
        
        if Double(cleanedAmount) ?? 0 > 99999999 {
            cleanedAmount = String(cleanedAmount.dropLast())
        }
        
        if type == .amountValue {
            if Double(cleanedAmount) ?? 00000 > 99999999 {
                cleanedAmount = String(cleanedAmount.dropLast())
            }
        }
        else {
            if Double(cleanedAmount) ?? 0.00 > 10000 {
                cleanedAmount = String(cleanedAmount.dropLast())
            }
        }
        
        let amount = Double(cleanedAmount) ?? 0.0
        let amountAsDouble = (amount / 100.0)
        var amountAsString = String(amountAsDouble)
        if cleanedAmount.last == "0" {
            amountAsString.append("0")
        }
        
        var returnableAmount = amountAsString

        if returnableAmount == "000" {
            return ""
        }
        
        return returnableAmount
    }
    
}
