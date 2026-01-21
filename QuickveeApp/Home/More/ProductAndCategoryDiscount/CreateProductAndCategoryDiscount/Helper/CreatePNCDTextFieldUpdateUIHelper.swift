//
//  CreatePNCDTextFieldUpdateUIHelper.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 21/01/26.
//

import UIKit

extension CreateProductAndCategoryDiscountVC {
    
    func setupUIForDiscountTextFields(){
        // Discount Name
        txtDiscountName.attributedPlaceholder = getAttributedPlaceHolderText(for: "Enter Discount Name")
        
        txtDiscountName.delegate = self
        txtDiscountName.borderStyle = .none
        txtDiscountName.returnKeyType = .next
        txtDiscountName.superview?.applyBorder(
            borderWidth: 1,
            borderColor: .E4E8EF,
            borderOpacity: 1
        )
        txtDiscountName.superview?.applyCornerRadius(cornerRadius: 8)
        
        // Discount Per Item
        txtDiscountPerItem.attributedPlaceholder = getAttributedPlaceHolderText(for: "$0.00")
        txtDiscountPerItem.borderStyle = .none
        txtDiscountPerItem.superview?.applyBorder(
            borderWidth: 1,
            borderColor: .E4E8EF,
            borderOpacity: 1
        )
        txtDiscountPerItem.superview?.applyCornerRadius(cornerRadius: 8)
        
        txtDiscountPerItem.keyboardType = .numberPad
        txtDiscountPerItem.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
    }
    
    
    @objc func updateTextField(textField: UITextField) {
        textField.text = DiscountPerItemDiscountTextFormatter.format(
            textField.text ?? "",
            type: viewModel.flagsPropertyManager.discountInputValueType
        )
        
    }
    
    func updateUIForDiscountInputValueTypeChange(){
        let isPercent = viewModel.flagsPropertyManager.discountInputValueType == .percentValue
        
        lblDiscountPerItem.text = isPercent ? "Discount per item (%)" : "Discount per item ($)"
        txtDiscountPerItem.text = nil
        txtDiscountPerItem.attributedPlaceholder = getAttributedPlaceHolderText(for: isPercent ? "0.00%" : "$0.00")
        
    }
    
    private func getAttributedPlaceHolderText(for text: String) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: FontFamily.ManropeMedium.size(14),
            .foregroundColor: UIColor._878787
        ]
        
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    
}
