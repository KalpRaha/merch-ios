//
//  CreateProductAndCategoryDiscountVC.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 07/01/26.
//

import UIKit


class CreateProductAndCategoryDiscountVCFactory {
    
    static func make() -> CreateProductAndCategoryDiscountVC {
    
        let vc = CreateProductAndCategoryDiscountVC.instantiate()
        vc.viewModel = CreateProductAndCategoryDiscountVC.ViewModel()
        vc.viewModel?.delegate = vc
        
        return vc
    }
}


final class CreateProductAndCategoryDiscountVC: UIViewController, Navigatable {

    static var storyboard: UIStoryboard { .productAndCategoryDiscount }
    
    
    @IBOutlet private weak var vwNavigationHeader: CustomNavigationHeaderView!
    
    
    // Discount Type Selection View
    @IBOutlet private weak var vwProductDiscountTypeSelectionView: UIView!
    @IBOutlet private weak var lblProductDiscountTypeSelectionViewTitle: UILabel!
    @IBOutlet private weak var lblProductDiscountTypeSelectionViewSubTitle: UILabel!
    
    @IBOutlet private weak var vwCategoryDiscountTypeSelectionView: UIView!
    @IBOutlet private weak var lblCategoryDiscountTypeSelectionViewTitle: UILabel!
    @IBOutlet private weak var lblCategoryDiscountTypeSelectionViewSubTitle: UILabel!

    
    // DiscountDetails
    
    @IBOutlet private weak var swtAllowDiscountStackWithOtherDiscounts: CustomSwitch!
    
    
    @IBOutlet private weak var lblDiscountName: UILabel!
    @IBOutlet private weak var txtDiscountName: UITextField!
    
    @IBOutlet private weak var lblDiscountPerItem: UILabel!
    @IBOutlet private weak var txtDiscountPerItem: UITextField!
    
    
    // Bottom Buttons
    @IBOutlet private weak var btnCancel: GenericButton!
    @IBOutlet private weak var btnSave: GenericButton!
    
    
    var viewModel : ViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: { [weak self] in
            guard let self else { return }
            updateUIForDiscountTypeSelectionValueChange()
        })
        
        updateUIForDiscountPerItemDiscountTypeValueChange()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    private func updateUI(){
        vwNavigationHeader.delegate = self
        setupUIForDiscountTextFields()
    }
    
    private func setupUIForDiscountTextFields(){
        txtDiscountName.attributedPlaceholder = getAttributedPlaceHolderText(for: "Enter Discount Name")
        
        txtDiscountName.borderStyle = .none
        txtDiscountName.superview?.applyBorder(
            borderWidth: 1,
            borderColor: .E4E8EF,
            borderOpacity: 1
        )
        txtDiscountName.superview?.applyCornerRadius(cornerRadius: 8)
        
        
        txtDiscountPerItem.attributedPlaceholder = getAttributedPlaceHolderText(for: "$0.00")
        txtDiscountPerItem.borderStyle = .none
        txtDiscountPerItem.superview?.applyBorder(
            borderWidth: 1,
            borderColor: .E4E8EF,
            borderOpacity: 1
        )
        txtDiscountPerItem.superview?.applyCornerRadius(cornerRadius: 8)
    }


    @IBAction private func onClickBtnCancel(_ sender: GenericButton) {
        
        Logger.log(#function)
    }
    
    
    @IBAction private func onClickBtnSave(_ sender: GenericButton) {
        if btnSave.isLoading {
            btnSave.hideLoader()
        }else{
            btnSave.showLoader()
        }
        Logger.log(#function)
    }
    
    
}

extension CreateProductAndCategoryDiscountVC : CustomNavigationHeaderViewDelegate{
    
    func onClickBack() {
        popVC()
    }
    
    func setHeaderTitle() -> String {
        "Product or Category Discount"
    }
    
}


extension CreateProductAndCategoryDiscountVC {
    
    @IBAction private func onClickDiscountTypeSelection(_ sender : UIButton) {
        
        let discountType : ProductAndCategoryDiscountType = (sender.tag == 0) ? .product : .category
        
        if self.viewModel.productOrCategoryDiscountType != discountType {
            self.viewModel.productOrCategoryDiscountType = discountType
        }
        updateUIForDiscountTypeSelectionValueChange()
        Logger.log(#function)
    }
    
    private func updateUIForDiscountTypeSelectionValueChange(){
        let isProduct = viewModel.productOrCategoryDiscountType == .product
        
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
    }
}


extension CreateProductAndCategoryDiscountVC {
    
    private func getAttributedPlaceHolderText(for text: String) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: FontFamily.ManropeMedium.size(14),
            .foregroundColor: UIColor._878787
        ]
        
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    private func updateUIForDiscountPerItemDiscountTypeValueChange(){
        let isPercent = viewModel.discountPerItemDiscountType == .percentage
        
        lblDiscountPerItem.text = isPercent ? "Discount per item (%)" : "Discount per item ($)"
        txtDiscountPerItem.attributedPlaceholder = getAttributedPlaceHolderText(for: isPercent ? "0.00%" : "$0.00")
        
    }
}


extension CreateProductAndCategoryDiscountVC : CreateProductAndCategoryDiscountVMDelegate {
    
    func didUpdateProductOrCategoryDiscountType() {
        updateUIForDiscountTypeSelectionValueChange()
    }
    
    func didUpdateIsAllowDiscountToStackWithOtherDiscounts() {
        swtAllowDiscountStackWithOtherDiscounts.isOn = viewModel.isAllowDiscountToStackWithOtherDiscounts
    }
    
    func didUpdateDiscountPerItemDiscountType() {
        updateUIForDiscountPerItemDiscountTypeValueChange()
    }
    
    
}

