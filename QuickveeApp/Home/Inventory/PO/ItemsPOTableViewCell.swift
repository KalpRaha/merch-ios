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
    @IBOutlet weak var noteField: UITextField!
    
    @IBOutlet weak var qtyView: UIView!
    @IBOutlet weak var costView: UIView!
    @IBOutlet weak var noteView: UIView!
    
    @IBOutlet weak var qtyAfter: UILabel!
    @IBOutlet weak var total: UILabel!
    
    @IBOutlet weak var deleteBtn: UIButton!
}
