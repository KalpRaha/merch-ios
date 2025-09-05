//
//  CustomerMergeTableViewCell.swift
//  QuickveeApp
//
//  Created by Pallavi on 01/09/25.
//

import UIKit

class CustomerMergeTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var initialName: UILabel!
    
    @IBOutlet weak var customerName: UILabel!
   
    @IBOutlet weak var phoneNumber: UILabel!
    
    @IBOutlet weak var email: UILabel!
    
    @IBOutlet weak var radioBtn: UIButton!
   
    @IBOutlet weak var phoneImage: UIImageView!
    
    @IBOutlet weak var emailImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
