//
//  FontFamily.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 31/12/25.
//

import UIKit


enum FontFamily : String {
    
    case ManropeThin = "Manrope-Thin"
    case ManropeLight = "Manrope-Light"
    case ManropeRegular = "Manrope-Regular"
    case ManropeMedium = "Manrope-Medium"
    case ManropeSemiBold = "Manrope-SemiBold"
    case ManropeBold = "Manrope-Bold"
    case ManropeExtraBold = "Manrope-ExtraBold"

    
    func size(_ size : CGFloat) -> UIFont {
        UIFont(name: self.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func printFonts() {
        for family in UIFont.familyNames {
            print("\(family)")

            for name in UIFont.fontNames(forFamilyName: family) {
                print("   \(name)")
            }
        }
    }
    
}
