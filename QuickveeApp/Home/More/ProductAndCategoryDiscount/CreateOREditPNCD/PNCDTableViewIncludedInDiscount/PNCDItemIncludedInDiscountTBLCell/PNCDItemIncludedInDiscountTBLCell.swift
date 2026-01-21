//
//  PNCDItemIncludedInDiscountTBLCell.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 14/01/26.
//

import UIKit

class PNCDItemIncludedInDiscountTBLCell: UITableViewCell {

    @IBOutlet weak var productName: ManropeBoldLabel!
   
    @IBOutlet weak var priceLbl: ManropeMediumLabel!
    @IBOutlet weak var discountPrice: ManropeBoldLabel!
    
    var cellData: VariantDataModel! {
        didSet{
            updateUIWithData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    private func updateUIWithData(){
        guard let cellData else { return }
        
        if cellData.isVarient {
            productName.text = cellData.variantTitle
            priceLbl.text = cellData.variantPrice
            
        }else {
            productName.text = cellData.productTitle
            priceLbl.text = cellData.productPrice
        }
        
    }
    
}
