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
    @IBOutlet weak var categoryValue: UILabel!
    
    var cellData: InventoryVariant! {
        didSet{
           updateUIWithData()
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

    
    private func updateUIWithData(){
        
        if cellData.isvarient == "0" {
            
            productNameLBL.text = cellData.title
            priceLbl.text = cellData.price
            upcLBL.text = cellData.upc
            stockLBL.text = "Avaiable Stock:\(cellData.quantity)"
            
        }
        else {
            productNameLBL.text = cellData.variant
            priceLbl.text = cellData.var_price
            upcLBL.text = cellData.var_upc
            stockLBL.text = "Avaiable Stock:\(cellData.quantity)"
        }
        
        
      //  guard let cellData else { return }
        
//        if cellData.isVarient {
//            
//            productNameLBL.text = cellData.productTitle
//            priceLbl.text = cellData.productPrice
//            upcLBL.text = cellData.productUPC
//        }else {
//            
//            productNameLBL.text = cellData.variantTitle
//            priceLbl.text = cellData.variantPrice
//            upcLBL.text = cellData.variantUpc
//            
//        }
        
        
    }
    
}

