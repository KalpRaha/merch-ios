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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
}

