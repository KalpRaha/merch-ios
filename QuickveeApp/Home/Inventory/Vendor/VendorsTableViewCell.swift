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
    @IBOutlet weak var payCount: UILabel!
    @IBOutlet weak var paymentDateTime: UILabel!
    @IBOutlet weak var payAmount: UILabel!
   
    @IBOutlet weak var disabledBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.disabledBtn.layer.borderWidth = 1
        self.disabledBtn.layer.borderColor = UIColor(hexString: "#F55353").cgColor
        self.disabledBtn.layer.cornerRadius = 5
    }

}
