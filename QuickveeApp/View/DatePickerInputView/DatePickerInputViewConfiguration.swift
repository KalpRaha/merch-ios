//
//  DatePickerInputView+Configuration.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 13/01/26.
//

import UIKit


// MARK: - Public configuration API

extension DatePickerInputView {
    
    struct Configuration {

        var titleText : String
        var titleTextColor: UIColor
        var titleTextFont: UIFont
        var titleBottomPadding: CGFloat
        var textFieldContentInset: UIEdgeInsets
        
        var containerViewConfig : ViewConfiguration
        var textFieldViewConfig : ViewConfiguration
        
        
        init(
            titleText: String,
            titleTextColor: UIColor = .black,
            titleTextFont: UIFont = FontFamily.ManropeMedium.size(14),
            titleBottomPadding: CGFloat = 10,
            textFieldContentInset: UIEdgeInsets = .init(top: 0,left: 15,bottom: 0,right: 15),
            containerViewConfig: ViewConfiguration = .init(
                backgroundColor: .clear,
                
                borderColor: .clear,
                borderWidth: 0,
                borderOpacity: 0,
                
                cornerRadius: 0,
                
                shadowColor: .clear,
                shadowOpacity: 0,
                shadowXOffset: 0,
                shadowYOffset: 0,
                shadowBlur: 0,
                shadowSpread: 0,
            ),
            txtViewConfig: ViewConfiguration = .init(
                backgroundColor: .white,
                
                borderColor: .lightGray,
                borderWidth: 1,
                borderOpacity: 1,
                
                cornerRadius: 8,
                
                shadowColor: .clear,
                shadowOpacity: 0,
                shadowXOffset: 0,
                shadowYOffset: 0,
                shadowBlur: 0,
                shadowSpread: 0,
            )
        ) {
            
            self.titleText = titleText
            self.titleTextColor = titleTextColor
            self.titleTextFont = titleTextFont
            self.titleBottomPadding = titleBottomPadding
            self.textFieldContentInset = textFieldContentInset
            
            self.containerViewConfig = containerViewConfig
            self.textFieldViewConfig = txtViewConfig
        }
    }

}

extension DatePickerInputView {
   
    struct ViewConfiguration {

        var backgroundColor: UIColor = .white

        var borderColor: UIColor = .clear
        var borderWidth: CGFloat = 0
        var borderOpacity: CGFloat = 1

        var cornerRadius: CGFloat = 0

        var shadowColor: UIColor = .clear
        var shadowOpacity: Float = 0
        var shadowXOffset: CGFloat = 0
        var shadowYOffset: CGFloat = 0
        var shadowBlur: CGFloat = 0
        var shadowSpread: CGFloat = 0
    }
    
}


extension DatePickerInputView.ViewConfiguration {
    
    func apply(in view : UIView) {
        
        view.backgroundColor = backgroundColor
        view.applyBorder(
            borderWidth: borderWidth,
            borderColor: borderColor,
            borderOpacity: borderOpacity
        )
        
        view.applyCornerRadius(cornerRadius: cornerRadius)
        
        view.applyShadow(
            shadowColor: shadowColor,
            shadowOpacity: shadowOpacity,
            shadowXOffset: shadowXOffset,
            shadowYOffset: shadowYOffset,
            shadowBlur: shadowBlur,
            shadowSpread: shadowSpread
        )

    }
    
}
