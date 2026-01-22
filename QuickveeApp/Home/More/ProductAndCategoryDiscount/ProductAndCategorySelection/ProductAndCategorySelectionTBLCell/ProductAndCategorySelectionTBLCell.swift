//
//  ProductAndCategorySelectionTBLCell.swift
//  QuickveeApp
//
//  Created by Pallavi on 08/01/26.
//

import UIKit

class ProductAndCategorySelectionTBLCell: UITableViewCell {
    
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var productNameLBL: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var upcLBL: UILabel!
    @IBOutlet weak var stockLBL: UILabel!
    
    @IBOutlet weak var promotionValue: UILabel!
    
    @IBOutlet weak var categoryValue: ManropeBoldLabel!
    
    @IBOutlet weak var grayBgView: UIView!
    @IBOutlet weak var category: ManropeMediumLabel!
    
    var cellData: VariantDataModel! {
        didSet{
            updateUIWithProductData()
        }
    }
    
    var categoryData: CategoryDataModel? {
        didSet{
            updateUIForProductCategoryData()
        }
    }
    
    var mixMatchData: MixnMatchDataModel? {
        didSet{
            updateUIForPromotion()
        }
    }
  
    var bogoData: BogoDataModel? {
        didSet{
            updateUIForPromotion()
        }
    }
    
    var isSelectedCell : Bool = false {
        didSet{
            checkImage.image = isSelectedCell ? .checkInventory : .uncheckInventory
        }
    }
  
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    private func updateUIWithProductData(){
     
        guard let cellData else { return }
        
        if cellData.isVarient {
            grayBgView.layer.cornerRadius = 5
            productNameLBL.text = cellData.variantTitle
            priceLbl.text = cellData.variantPrice
            upcLBL.text = cellData.variantUpc
            setAttributedLabel(
                        label: stockLBL,
                        title: "Available Stock: ",
                        value: "\(cellData.quantity)"
                    )
            
        }else {
            productNameLBL.text = cellData.productTitle
            priceLbl.text = cellData.productPrice
            upcLBL.text = cellData.productUPC
            setAttributedLabel(
                        label: stockLBL,
                        title: "Available Stock: ",
                        value: "\(cellData.quantity)"
                    )
        }
    }
  
    func updateUIForCategoryData(
        title: String,
        productCount: String,
        promotionType: PromotionType
    ) {
        grayBgView.layer.cornerRadius = 5
        productNameLBL.text = title
        priceLbl.isHidden = true
        stockLBL.isHidden = true
        category.isHidden = true
        categoryValue.isHidden = true
        
        setAttributedLabel(
                label: upcLBL,
                title: "Products in category: ",
                value: productCount
            )
    }

    private func updateUIForProductCategoryData(){
        if let categoryData {
            
            categoryValue.text = categoryData.title
        }else{
            categoryValue.text = ""
        }
    }
    
    private func updateUIForPromotion(){
        
        if let mixMatchData   {
            
            promotionValue.text = mixMatchData.dealName
        }
        else {
            promotionValue.text = "-"
        }
        
        if let bogoData {
            promotionValue.text = bogoData.dealName
        }
        else {
            promotionValue.text = "-"
        }
    }
}

extension ProductAndCategorySelectionTBLCell {
    
    enum PromotionType {
        
        case none
        case singlePromotion(String)
        case MultiplePromotion
        
        var title: String {
            switch self {
            case .none: "None"
            case .singlePromotion(let title): title
            case .MultiplePromotion: "Multiple"
            }
        }
    }
}

extension ProductAndCategorySelectionTBLCell {
    func setAttributedLabel(
        label: UILabel,
        title: String,
        value: String,
        titleColor: UIColor = .gray,
        valueColor: UIColor = .black
    ) {

        let attributedString = NSMutableAttributedString(
            string: title,
            attributes: [
                .foregroundColor: titleColor
            ]
        )
        let valueString = NSAttributedString(
            string: value,
            attributes: [
                .foregroundColor: valueColor,
                .font: label.font as Any
            ]
        )
        attributedString.append(valueString)
        label.attributedText = attributedString
    }
}

