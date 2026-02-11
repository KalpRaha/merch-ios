//
//  POTableViewCell.swift
//  QuickveeApp
//
//  Created by Kalpesh on 25/07/25.
//

import UIKit

class POTableViewCell: UITableViewCell {

    
    @IBOutlet weak var poName: UILabel!
    @IBOutlet weak var poStatus: UILabel!
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var qtyValue: UILabel!
    @IBOutlet weak var costValue: UILabel!
    @IBOutlet weak var dueDateValue: UILabel!
    @IBOutlet weak var updatedValue: UILabel!
    @IBOutlet weak var receivedValue: UILabel!
}
