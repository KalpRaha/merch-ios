//
//  UIImage+Extension.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 07/01/26.
//

import UIKit

extension UIImage {
    
    static var noDiscountFoundIcon : UIImage = {
        UIImage(named: "noDiscountFoundIcon") ?? UIImage()
    }()
    
    
    static var uncheckInventory : UIImage = {
        UIImage(named: "uncheck inventory") ?? UIImage()
    }()
    
    static var checkInventory : UIImage = {
        UIImage(named: "check inventory") ?? UIImage()
    }()
    
    
    static var clockIcon : UIImage = {
        UIImage(named: "clockIcon") ?? UIImage()
    }()
    
    static var calenderIcon : UIImage = {
        UIImage(named: "calenderIcon") ?? UIImage()
    }()
    
}
