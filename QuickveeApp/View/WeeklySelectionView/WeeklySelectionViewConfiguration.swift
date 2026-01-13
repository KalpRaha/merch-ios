//
//  WeeklySelectionViewConfiguration.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 13/01/26.
//

import UIKit

extension WeeklySelectionView {

    struct WeeklyContainerConfig {
        var backgroundColor: UIColor
        var stackTopPadding: CGFloat
        var stackSpacing: CGFloat
        
        
        init(
            backgroundColor: UIColor = .clear,
            stackTopPadding: CGFloat = 10,
            stackSpacing: CGFloat = 5
        ) {
            self.backgroundColor = backgroundColor
            self.stackTopPadding = stackTopPadding
            self.stackSpacing = stackSpacing
        }
        
    }
    
    struct DayItemUIConfig {
        
        var backgroundColor: UIColor
        var borderColor: UIColor
        var borderWidth: CGFloat
        var cornerRadius: CGFloat
        var textColor: UIColor
        var font: UIFont
        
        init(
            backgroundColor: UIColor = .white,
            borderColor: UIColor = .clear,
            borderWidth: CGFloat = 0,
            cornerRadius: CGFloat = 8,
            textColor: UIColor = .black,
            font: UIFont = FontFamily.ManropeMedium.size(13)
        ) {
            self.backgroundColor = backgroundColor
            self.borderColor = borderColor
            self.borderWidth = borderWidth
            self.cornerRadius = cornerRadius
            self.textColor = textColor
            self.font = font
        }
        
    }
    
    enum WeekDayItem {
        
        case mon
        case tue
        case wed
        case thu
        case fri
        case sat
        case sun
        
        var title : String {
            switch self {
            case .mon: "Mon"
            case .tue: "Tue"
            case .wed: "WED"
            case .thu: "THU"
            case .fri: "FRI"
            case .sat: "SAT"
            case .sun: "SUN"
            }
        }
        
        static var dataSource : [Self] = [
            .sun, .mon, .tue, .wed, .thu, .fri, .sat
        ]
    }
    
}

