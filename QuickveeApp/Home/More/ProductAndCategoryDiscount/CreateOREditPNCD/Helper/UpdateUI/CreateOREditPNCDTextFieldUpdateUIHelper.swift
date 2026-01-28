//
//  CreateOREditPNCDTextFieldUpdateUIHelper.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 21/01/26.
//

import UIKit

extension CreateOREditPNCDVC {
    
    func setupUIForDiscountTextFields(){
        // Discount Name
        txtDiscountName.attributedPlaceholder = getAttributedPlaceHolderText(for: "Enter Discount Name")
        
        txtDiscountName.delegate = self
        txtDiscountName.borderStyle = .none
        txtDiscountName.returnKeyType = .next
        txtDiscountName.superview?.applyCornerRadius(cornerRadius: 8)
        
        // Discount Per Item
        txtDiscountInputValueType.attributedPlaceholder = getAttributedPlaceHolderText(for: "$0.00")
        txtDiscountInputValueType.borderStyle = .none

        txtDiscountInputValueType.superview?.applyCornerRadius(cornerRadius: 8)
        
        txtDiscountInputValueType.keyboardType = .numberPad
        txtDiscountInputValueType.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
    }
    
    
    @objc func updateTextField(textField: UITextField) {
        textField.text = DiscountInputValueTextFormatter.format(
            textField.text ?? "",
            type: viewModel.flagsPropertyManager.discountInputValueType
        )
        
    }
    
    func updateUIForDiscountInputValueTypeChange(){
        let isPercent = viewModel.flagsPropertyManager.discountInputValueType == .percentValue
        
        lblDiscountInputValueTypeTitle.text = isPercent ? "Discount per item (%)" : "Discount per item ($)"
        txtDiscountInputValueType.text = nil
        txtDiscountInputValueType.attributedPlaceholder = getAttributedPlaceHolderText(for: isPercent ? "0.00%" : "$0.00")
        
        segCtrlDiscountInputValueType.select(
            index: viewModel.flagsPropertyManager.discountInputValueType.getIndex()
        )
        
    }
    
    private func getAttributedPlaceHolderText(for text: String) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: FontFamily.ManropeMedium.size(14),
            .foregroundColor: UIColor._878787
        ]
        
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    
}

extension CreateOREditPNCDVC : UITextFieldDelegate {
    
}
