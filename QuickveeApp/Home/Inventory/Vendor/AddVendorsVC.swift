//
//  AddVendorsVC.swift
//  QuickveeApp
//
//  Created by Pallavi on 28/07/25.
//

import UIKit
import MaterialComponents

class AddVendorsVC: UIViewController {

    @IBOutlet weak var topView: UIView!
   
   
    @IBOutlet weak var vendorName: UITextField!
    
    
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var zip: UITextField!
    @IBOutlet weak var State: UITextField!
   
    @IBOutlet weak var cancelBtn: UIButton!
    
    
    @IBOutlet weak var addVenderBtn: UIButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        topView.addBottomShadow()
        setUI()
    }
    
    
    
    
    func setUI() {
    
        cancelBtn.layer.borderWidth = 1
        cancelBtn.layer.borderColor = UIColor.black.cgColor
        cancelBtn.layer.cornerRadius = 5
        
        addVenderBtn.layer.cornerRadius = 5
       
    }
    
    func setMode(){
        
        
    }
    
    func emailCheckAPiCall() {
        
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        ApiCalls.sharedCall.emailCkeckApi(merchant_id: id, email: "", token_id: "", login_type: "merchant") { isSuccess ,responseData in
            
            if isSuccess {
                
                
            }
            else {
                
            }
            
        }
        
    }
    
    
    func addVendorApiCall() {
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        guard let name = vendorName.text, name != "" else {
            vendorName.isErrorView(numberOfShakes: 3, revert: true)
            ToastClass.sharedToast.showToast(message: "Enter Vendor Name", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            return
        }
        
        guard let name = phone.text, name != "" else {
            phone.isErrorView(numberOfShakes: 3, revert: true)
            ToastClass.sharedToast.showToast(message: "Enter Phone Number ", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            return
        }
        
        guard let name = email.text, name != "" else {
            email.isErrorView(numberOfShakes: 3, revert: true)
            ToastClass.sharedToast.showToast(message: "Enter valid Email address ", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            return
        }
        
      
        
        
    }
    
 
    @IBAction func backBtnClick(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func homeBtnClick(_ sender: UIButton) {
        
    }
    @IBAction func cancelBtnClick(_ sender: UIButton) {
        
    }
    
    
    @IBAction func addVendorBtnClick(_ sender: Any) {
        addVendorApiCall()
    }
}
