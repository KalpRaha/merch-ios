//
//  VendorsTableViewCell.swift
//  QuickveeApp
//
//  Created by Pallavi on 28/07/25.
//

import UIKit

class VendorsTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var smallView: UIView!
   
    @IBOutlet weak var vendorName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}
