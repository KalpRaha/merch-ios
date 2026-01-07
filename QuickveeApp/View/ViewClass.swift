//
//  ViewClass.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 07/01/26.
//

import UIKit


//MARK: - Custom View
class CornerRadiusView: UIView{

    @IBInspectable private var cornerRadius: CGFloat = 0.0
    @IBInspectable private var isCapsuleCircle: Bool = false
    @IBInspectable private var isCylinderCircle: Bool = false
    @IBInspectable private var x0y0 : Bool = false
    @IBInspectable private var x1y0 : Bool = false
    @IBInspectable private var x1y1 : Bool = false
    @IBInspectable private var x0y1 : Bool = false
    
    private func applySpecificCornerRadius(){
        var corners: CACornerMask = []
        
        if x0y0{
            corners.insert(.layerMinXMinYCorner)
        }
        
        if x1y0{
            corners.insert(.layerMaxXMinYCorner)
        }
        
        if x1y1{
            corners.insert(.layerMaxXMaxYCorner)
        }
        
        if x0y1{
            corners.insert(.layerMinXMaxYCorner)
        }
        
        if corners.isEmpty{
            corners = [.layerMinXMinYCorner,
                       .layerMaxXMinYCorner,
                       .layerMaxXMaxYCorner,
                       .layerMinXMaxYCorner]
        }
        applyCornerRadius(cornerRadius: cornerRadius, corners: corners)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if isCapsuleCircle{
            applyCornerRadius(cornerRadius: self.frame.height/2)
            
        }else if isCylinderCircle{
            applyCornerRadius(cornerRadius: self.frame.width/2)
            
        }else{
            self.applySpecificCornerRadius()
        }
    }
}

class CornerRadiusBorderView: CornerRadiusView{
    
    @IBInspectable private var borderWidth: CGFloat = 0.0
    @IBInspectable private var borderColor: UIColor = .clear
    @IBInspectable private var borderOpacity: CGFloat = 1.0

    override func awakeFromNib() {
        super.awakeFromNib()
        applyBorder(borderWidth: borderWidth, borderColor: borderColor, borderOpacity: borderOpacity)
    }
    
}

class CornerRadiusBorderShadowView: CornerRadiusBorderView{
    
    @IBInspectable private var shadowColor: UIColor = .clear
    @IBInspectable private var shadowOpacity: Float = 1.0
    @IBInspectable private var shadowXOffset: CGFloat = 0
    @IBInspectable private var shadowYOffset: CGFloat = 0
    @IBInspectable private var shadowBlur: CGFloat = 0
    @IBInspectable private var shadowSpread: CGFloat = 0
   
    override func layoutSubviews() {
        super.layoutSubviews()
        applyShadow(shadowColor: shadowColor, shadowOpacity: shadowOpacity, shadowXOffset: shadowXOffset, shadowYOffset: shadowYOffset, shadowBlur: shadowBlur, shadowSpread: shadowSpread)
    }
    
}

