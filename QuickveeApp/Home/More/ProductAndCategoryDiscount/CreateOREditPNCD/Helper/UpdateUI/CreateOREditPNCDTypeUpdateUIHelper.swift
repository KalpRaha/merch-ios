//
//  CreateOREditPNCDTypeUpdateUIHelper.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 16/01/26.
//

import UIKit

extension CreatePNCDVC {
    
    // Update UI based on selected type
    func updateUIForPNCDSelectionType() {
        
        let isProduct = (viewModel.flagsPropertyManager.pncdType == .product)
        
        // Product View UI Update
        vwProductDiscountTypeSelectionView.applyBorder(
            borderWidth: 1,
            borderColor: isProduct ? ._0A64F9 : .E4E4E4,
            borderOpacity: 1
        )
        vwProductDiscountTypeSelectionView.applyShadow(
            shadowColor: isProduct ? ._0A64F9 : .clear,
            shadowOpacity: isProduct ? 0.25 : 0,
            shadowXOffset: 0,
            shadowYOffset: 7,
            shadowBlur: isProduct ? 18 : 0,
            shadowSpread: 0
        )
        lblProductDiscountTypeSelectionViewTitle.textColor = isProduct ? ._0A64F9 : ._636363
        lblProductDiscountTypeSelectionViewSubTitle.textColor = isProduct ? .black : ._8F8F8F
        
        // Category View UI Update
        vwCategoryDiscountTypeSelectionView.applyBorder(
            borderWidth: 1,
            borderColor: !isProduct ? ._0A64F9 : .E4E4E4,
            borderOpacity: 1
        )
        vwCategoryDiscountTypeSelectionView.applyShadow(
            shadowColor: !isProduct ? ._0A64F9 : .clear,
            shadowOpacity: !isProduct ? 0.25 : 0,
            shadowXOffset: 0,
            shadowYOffset: 7,
            shadowBlur: !isProduct ? 18 : 0,
            shadowSpread: 0
        )
        lblCategoryDiscountTypeSelectionViewTitle.textColor = !isProduct ? ._0A64F9 : ._636363
        lblCategoryDiscountTypeSelectionViewSubTitle.textColor = !isProduct ? .black : ._8F8F8F
        
        // Labels and button titles
        lblAddProductORCategoryBtn.text = isProduct ? "Products Included In Offer" : "Categories Included In This Discount"
        btnAddProductORCategory.title = isProduct ? "Add products to discount" : "Add Categories to discount"
        lblEditProductORCategoryBtn.text = isProduct ? "Products Included In This Discount" : "Categories Included In This Discount"
    }
    
}
