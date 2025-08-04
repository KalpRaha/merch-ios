//
//  ItemsPOTableViewCell.swift
//  QuickveeApp
//
//  Created by Kalpesh on 31/07/25.
//

import UIKit

class ItemsPOTableViewCell: UITableViewCell {


    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var upc: UILabel!
    
    @IBOutlet weak var qtyTextField: UITextField!
    @IBOutlet weak var costPerTextField: UITextField!
    
    @IBOutlet weak var qtyAfter: UILabel!
    @IBOutlet weak var total: UILabel!
}
