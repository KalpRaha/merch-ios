//
//  CreatePNCDTypeSwitchUIHelper.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 16/01/26.
//

import UIKit

extension CreatePNCDVC {
    
    class CreatePNCDTypeSwitchUIHelper: NSObject {
        // Mirror UI fields
        
        weak var vc : CreateProductAndCategoryDiscountVC!
        
        
        // Update UI based on selected type
        func update(for discountType: ProductAndCategoryDiscountType) {
            
            let isProduct = (discountType == .product)
            
            // Product View UI Update
            vc.vwProductDiscountTypeSelectionView.applyBorder(
                borderWidth: 1,
                borderColor: isProduct ? ._0A64F9 : .E4E4E4,
                borderOpacity: 1
            )
            vc.vwProductDiscountTypeSelectionView.applyShadow(
                shadowColor: isProduct ? ._0A64F9 : .clear,
                shadowOpacity: isProduct ? 0.25 : 0,
                shadowXOffset: 0,
                shadowYOffset: 7,
                shadowBlur: isProduct ? 18 : 0,
                shadowSpread: 0
            )
            vc.lblProductDiscountTypeSelectionViewTitle.textColor = isProduct ? ._0A64F9 : ._636363
            vc.lblProductDiscountTypeSelectionViewSubTitle.textColor = isProduct ? .black : ._8F8F8F
            
            // Category View UI Update
            vc.vwCategoryDiscountTypeSelectionView.applyBorder(
                borderWidth: 1,
                borderColor: !isProduct ? ._0A64F9 : .E4E4E4,
                borderOpacity: 1
            )
            vc.vwCategoryDiscountTypeSelectionView.applyShadow(
                shadowColor: !isProduct ? ._0A64F9 : .clear,
                shadowOpacity: !isProduct ? 0.25 : 0,
                shadowXOffset: 0,
                shadowYOffset: 7,
                shadowBlur: !isProduct ? 18 : 0,
                shadowSpread: 0
            )
            vc.lblCategoryDiscountTypeSelectionViewTitle.textColor = !isProduct ? ._0A64F9 : ._636363
            vc.lblCategoryDiscountTypeSelectionViewSubTitle.textColor = !isProduct ? .black : ._8F8F8F
            
            // Labels and button titles
            vc.lblAddProductORCategoryBtn.text = isProduct ? "Products Included In Offer" : "Categories Included In This Discount"
            vc.btnAddProductORCategory.title = isProduct ? "Add products to discount" : "Add Categories to discount"
            vc.lblEditProductORCategoryBtn.text = isProduct ? "Products Included In This Discount" : "Categories Included In This Discount"
        }
    }
    
}
