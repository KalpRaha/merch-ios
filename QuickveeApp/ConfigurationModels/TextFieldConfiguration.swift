//
//  TextFieldConfiguration.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 13/01/26.
//

import UIKit


struct TextFieldConfiguration {
    
    var placeholderText : String
    var textColor: UIColor
    var font: UIFont
    
    init(
        placeholderText: String,
        textColor: UIColor = ._2B2B2B,
        font: UIFont = FontFamily.ManropeMedium.size(14)
    ) {
        self.placeholderText = placeholderText
        self.textColor = textColor
        self.font = font
    }
}
