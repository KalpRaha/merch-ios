//
//  VendorDetailCell.swift
//  QuickveeApp
//
//  Created by Pallavi on 30/07/25.
//

import UIKit

class VendorDetailCell: UITableViewCell {

    @IBOutlet weak var dateLbl: UILabel!
    
    @IBOutlet weak var amtLbl: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
