//
//  ProductAndCategoryDiscountListVC.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 07/01/26.
//

import UIKit

final class ProductAndCategoryDiscountListVC: UIViewController, Navigatable {

    static var storyboard: UIStoryboard { .productAndCategoryDiscount }
    
    
    @IBOutlet private weak var vwNavigationHeader: CustomNavigationHeaderView!
    
    
    
    @IBOutlet private weak var vwNoDiscountView: UIView!
    @IBOutlet private weak var btnCreateDiscount: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    private func updateUI(){
        vwNavigationHeader.delegate = self
        
        btnCreateDiscount.backgroundColor = ._0A64F9
        btnCreateDiscount.titleLabel?.font = FontFamily.ManropeMedium.size(15)
        btnCreateDiscount.applyCornerRadius(cornerRadius: 8)
    }


    @IBAction private func onClickBtnCreateDiscount(_ sender: UIButton) {
        
        print(#function)
    }
    
    
}

extension ProductAndCategoryDiscountListVC : CustomNavigationHeaderViewDelegate{
    
    
    func onClickBack() {
//        popVC()
    }
    
    func setHeaderTitle() -> String {
        "Product or Category Discount"
    }
 
    
}



