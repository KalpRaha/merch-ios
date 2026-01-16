//
//  ProductAndCategoryDiscountListVC.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 07/01/26.
//

import UIKit

typealias PNCDListVC = ProductAndCategoryDiscountListVC

class ProductAndCategoryDiscountListVCFactory {
    
    static func make() -> PNCDListVC {
        let vc = ProductAndCategoryDiscountListVC.instantiate()
        
        vc.viewModel = .init(
            pncdRepository: ProductAndCategoryDiscountAPIRepository(
                apiService: APIServiceFactory.make()
            )
            
        )
        vc.viewModel.delegate = vc
        
        return vc
    }
    
}

final class ProductAndCategoryDiscountListVC: UIViewController, Navigatable {

    static var storyboard: UIStoryboard { .productAndCategoryDiscount }
    
    
    @IBOutlet private weak var vwNavigationHeader: CustomNavigationHeaderView!
    
    // Empty List View // No Discount View
    @IBOutlet private weak var vwNoDiscountView: UIView!
    @IBOutlet private weak var btnCreateDiscount: UIButton!
    
    
    // Discount List Table
    
    
    var viewModel : ViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getDiscountList()
    }
    
    private func updateUI(){
        vwNavigationHeader.delegate = self
        
        btnCreateDiscount.backgroundColor = ._0A64F9
        btnCreateDiscount.titleLabel?.font = FontFamily.ManropeMedium.size(15)
        btnCreateDiscount.applyCornerRadius(cornerRadius: 8)
    }


    @IBAction private func onClickBtnCreateDiscount(_ sender: UIButton) {
        CreateProductAndCategoryDiscountVCFactory.make().push(in: self)
        Logger.log(#function)
    }
    
    
}

extension ProductAndCategoryDiscountListVC : CustomNavigationHeaderViewDelegate{
    
    func onClickBack() {
        popVC()
    }
    
    func setHeaderTitle() -> String {
        "Product or Category Discount"
    }
 
}

extension ProductAndCategoryDiscountListVC : ProductAndCategoryDiscountListVMProtocol {
 
    func didUpdatedDiscountList() {
        DispatchQueue.main.async { [weak self] in
            guard let _ = self else { return }
            
        }
    }
    
}
