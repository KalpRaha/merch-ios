//
//  AddPOViewController.swift
//  QuickveeApp
//
//  Created by Kalpesh on 31/07/25.
//

import UIKit
import MaterialComponents

class AddPOViewController: UIViewController {

    @IBOutlet weak var vendorName: MDCOutlinedTextField!
    @IBOutlet weak var issueDate: MDCOutlinedTextField!
    @IBOutlet weak var stockDate: MDCOutlinedTextField!
    @IBOutlet weak var referenceDate: MDCOutlinedTextField!
    @IBOutlet weak var vendorEmail: MDCOutlinedTextField!
    
    @IBOutlet weak var addVendorBtn: UIButton!
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupFields()
        topView.addBottomShadow()
        
        addVendorBtn.backgroundColor = UIColor(named: "SelectCat")
        addVendorBtn.layer.cornerRadius = 5
        cancelBtn.layer.cornerRadius = 10
        nextBtn.layer.cornerRadius = 10
        
        cancelBtn.layer.borderColor = UIColor.black.cgColor
        cancelBtn.layer.borderWidth = 1
    }
    
    func setupFields() {
        
        createCustomTextField(textField: vendorName)
        createCustomTextField(textField: issueDate)
        createCustomTextField(textField: stockDate)
        createCustomTextField(textField: referenceDate)
        createCustomTextField(textField: vendorEmail)
        
        vendorName.label.text = "Select Vendor"
        issueDate.label.text = "Issued Date"
        stockDate.label.text = "Stock Date"
        referenceDate.label.text = "Reference"
        vendorEmail.label.text = "Vendor Email"
    }
    
    
    @IBAction func backBtnClick(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func homeBtnClick(_ sender: UIButton) {
        
        var destiny = 0
        
        let viewcontrollerArray = navigationController?.viewControllers
        
        if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is HomeViewController }) {
            destiny = destinationIndex
        }
        
        navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
    }
    
    
    @IBAction func addVendorBtnClick(_ sender: UIButton) {
    }
    
    
    @IBAction func nextBtnClick(_ sender: UIButton) {
        
        performSegue(withIdentifier: "toSelectPO", sender: nil)
    }
}

extension AddPOViewController {
    
    func createCustomTextField(textField: MDCOutlinedTextField) {
        
        textField.font = UIFont(name: "Manrope-Medium", size: 14.0)
        textField.setOutlineColor(UIColor(hexString: "#C6CFDB"), for: .normal)
        textField.setOutlineColor(UIColor(hexString: "#C6CFDB"), for: .editing)
        textField.setNormalLabelColor(UIColor(hexString: "#7E7E7E"), for: .normal)
        textField.setFloatingLabelColor(UIColor(hexString: "#7E7E7E"), for: .editing)
        
    }
    
    
    
}
