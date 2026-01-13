//
//  CustomTextConfiguration.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 13/01/26.
//
import UIKit

struct CustomTextConfiguration {
    var title : String
    var textColor: UIColor
    var font: UIFont
    
    init(
        title: String,
        textColor: UIColor = .black,
        font: UIFont = FontFamily.ManropeMedium.size(14)
    ) {
        self.title = title
        self.textColor = textColor
        self.font = font
    }
}

