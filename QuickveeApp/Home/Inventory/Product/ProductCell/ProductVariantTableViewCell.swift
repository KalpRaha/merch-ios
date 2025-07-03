//
//  ProductVariantTableViewCell.swift
//
//
//  Created by Jamaluddin Syed on 10/18/23.
//

import UIKit
import MaterialComponents


protocol ProductVariantCellProtocol: AnyObject {
    func variantFieldDidChange(cell: ProductVariantTableViewCell, fieldName: String, value: String)
}

class ProductVariantTableViewCell: UITableViewCell {
    
    @IBOutlet weak var price: MDCOutlinedTextField!
    @IBOutlet weak var comparePrice: MDCOutlinedTextField!
    @IBOutlet weak var costPerItem: MDCOutlinedTextField!
    @IBOutlet weak var margin: MDCOutlinedTextField!
    @IBOutlet weak var profit: MDCOutlinedTextField!
    @IBOutlet weak var qty: MDCOutlinedTextField!
    @IBOutlet weak var customCode: MDCOutlinedTextField!
    @IBOutlet weak var upcCode: MDCOutlinedTextField!
    @IBOutlet weak var reorderQty: MDCOutlinedTextField!
    @IBOutlet weak var reorderLevel: MDCOutlinedTextField!
    
    @IBOutlet weak var trackQty: UIButton!
    @IBOutlet weak var checkID: UIButton!
    @IBOutlet weak var selling: UIButton!
    @IBOutlet weak var disable: UIButton!
    
    @IBOutlet weak var instantBtn: UIButton!
    
    @IBOutlet weak var salesHistoryBtn: UIButton!
    @IBOutlet weak var costItemInner: UIView!
    
    @IBOutlet weak var salesHeight: NSLayoutConstraint!
    @IBOutlet weak var qtyInner: UIView!
    @IBOutlet weak var scanBtn: UIButton!
    
    @IBOutlet weak var foodstampable: UIButton!
    @IBOutlet weak var plusMain: UIView!
    
    @IBOutlet weak var lineView: UIView!
    
    weak var delegate: ProductVariantCellProtocol?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        costPerItem.addTarget(self, action: #selector(costPerItemChanged), for: .editingChanged)
        price.addTarget(self, action: #selector(priceChanged), for: .editingChanged)
        comparePrice.addTarget(self, action: #selector(comparePriceChanged), for: .editingChanged)
        qty.addTarget(self, action: #selector(qtyChanged), for: .editingChanged)
        reorderQty.addTarget(self, action: #selector(costPerItemChanged), for: .editingChanged)
        reorderLevel.addTarget(self, action: #selector(costPerItemChanged), for: .editingChanged)
        customCode.addTarget(self, action: #selector(costPerItemChanged), for: .editingChanged)

        
        upcCode.addTarget(self, action: #selector(upcChanged), for: .editingChanged)
    }
    
   
    @objc func costPerItemChanged() {
        delegate?.variantFieldDidChange(cell: self, fieldName: "costPerItem", value: price.text ?? "")
    }
    @objc func priceChanged() {
        delegate?.variantFieldDidChange(cell: self, fieldName: "price", value: price.text ?? "")
    }
    
    @objc func comparePriceChanged() {
        delegate?.variantFieldDidChange(cell: self, fieldName: "compare_price", value: comparePrice.text ?? "")
    }
    
    @objc func qtyChanged() {
        delegate?.variantFieldDidChange(cell: self, fieldName: "quantity", value: qty.text ?? "")
    }
    
    @objc func reorderqtyChanged() {
        delegate?.variantFieldDidChange(cell: self, fieldName: "reorderqty", value: qty.text ?? "")
    }
    @objc func reorderlevelChanged() {
        delegate?.variantFieldDidChange(cell: self, fieldName: "reorderlevel", value: qty.text ?? "")
    }
    @objc func customCodeChanged() {
        delegate?.variantFieldDidChange(cell: self, fieldName: "customCode", value: qty.text ?? "")
    }
    
    @objc func upcChanged() {
        delegate?.variantFieldDidChange(cell: self, fieldName: "upc", value: upcCode.text ?? "")
    }
}
