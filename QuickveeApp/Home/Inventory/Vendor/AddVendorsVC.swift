//
//  AddVendorsVC.swift
//  QuickveeApp
//
//  Created by Pallavi on 28/07/25.
//

import UIKit

import DropDown
import MaterialComponents

class AddVendorsVC: UIViewController {

    @IBOutlet weak var topView: UIView!
   
   
    @IBOutlet weak var vendorName: UITextField!

    @IBOutlet weak var addTitle: UILabel!
    @IBOutlet weak var state: MDCOutlinedTextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var zip: UITextField!
   
    @IBOutlet weak var disableBtn: UIButton!
    
    @IBOutlet weak var cancelBtn: UIButton!
    
    
   
    @IBOutlet weak var stateDropDownBtn: UIButton!
    @IBOutlet weak var addVenderBtn: UIButton!
   
    
    var vendorArray = [VendorModel]()
    var activeTextField = UITextField()
    var vendorObj: VendorModel?
    var mode = ""
    var vendorId = ""
    
    weak var delegate: VendorNameEmailDelegate?
    
    let menu = DropDown()
    
    let states = ["AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "FL", "GA",
                  "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD",
                  "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ",
                  "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC",
                  "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY"]
    
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.white], lineWidth: 3)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
   // let border = UIColor(red: 188.0/255.0, green: 188.0/255.0, blue: 188.0/255.0, alpha: 1.0)
    
    let border = UIColor(hexString: "#E4E8EF")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topView.addBottomShadow()
        setUI()
        setupMenu()
        vendorName.addTarget(self, action: #selector(updateText), for: .editingChanged)
        phone.addTarget(self, action: #selector(updateText), for: .editingChanged)
        zip.addTarget(self, action: #selector(updateText), for: .editingChanged)
        
        createCustomTextField(textField: state)
        
        vendorName.delegate = self
        phone.delegate = self
        state.delegate = self
        zip.delegate = self
        phone.keyboardType = .numberPad
        email.keyboardType = .emailAddress

       
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        imageView.image = UIImage(named: "down")
        state.trailingView = imageView
        state.trailingViewMode = .always
        
        vendorId = vendorObj?.vendor_id ?? ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print(vendorId)
        setMode()
    }
    
    
    
    func setUI() {
    
        cancelBtn.layer.borderWidth = 1
        cancelBtn.layer.borderColor = UIColor.black.cgColor
        cancelBtn.layer.cornerRadius = 5
        
        addVenderBtn.layer.cornerRadius = 5
       
    }
    
    func setMode(){
        if mode == "add" || mode == "poadd"{
            addTitle.text = "Add Vendor"
            disableBtn.isHidden = true
            
        }
        else {
            
            addTitle.text = "Edit Vendor"
            disableBtn.isHidden = false
            addVenderBtn.setTitle("Update", for: .normal)
            vendorName.text = vendorObj?.name
            phone.text = vendorObj?.phone
            email.text = vendorObj?.email
            if vendorObj?.enabled == "1" {
                disableBtn.setTitle( "Disable", for: .normal)
            }
            else {
                disableBtn.setTitle( "Enable", for: .normal)
            }
            
            
            
            if vendorObj?.full_address == "" || vendorObj?.full_address ==  "null" {
                
            }
            else {
                address.text = vendorObj?.full_address
            }

            if vendorObj?.city == "" || vendorObj?.city ==  "null" {
                
            }
            else {
                city.text = vendorObj?.city
            }
            
            if vendorObj?.zip_code == "" || vendorObj?.zip_code ==  "null" {
                
            }
            else {
                zip.text = vendorObj?.zip_code
            }
           
            if vendorObj?.state == "" || vendorObj?.state ==  "null" {
                
            }
            else{
                state.text = vendorObj?.state
            }
 
        }
    }
    
    
    func setupMenu() {
        
        menu.dataSource = states
        menu.backgroundColor = .white
        menu.anchorView = stateDropDownBtn
        menu.separatorColor = .black
        menu.layer.cornerRadius = 10.0
        menu.selectionAction = { index, title in
            self.state.text = title
            self.menu.deselectRow(at: index)
        }
        
    }
    
    func emailCheckAPiCall() {
        
        if mode == "edit" {
                
            addVendorApiCall(enabled: "1", vendorId: vendorId)
            }
        
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        guard let name = vendorName.text, name != "" else {
            vendorName.isErrorView(numberOfShakes: 3, revert: true)
            ToastClass.sharedToast.showToast(message: "Enter Vendor Name", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            return
        }
        
        guard let phonenNumber = phone.text, phonenNumber != "",phonenNumber.count == 10  else {
            phone.isErrorView(numberOfShakes: 3, revert: true)
            ToastClass.sharedToast.showToast(message: "Enter Phone Number ", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            return
        }
        
        guard let emailId = email.text, emailId != "" else {
            email.isErrorView(numberOfShakes: 3, revert: true)
            ToastClass.sharedToast.showToast(message: "Enter valid Email address ", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            return
        }
        
        loadingIndicator.isAnimating = true
        
        ApiCalls.sharedCall.emailCheckApi(merchant_id: id, email: emailId, token_id: "", login_type: "merchant") { isSuccess ,responseData in
            
            if isSuccess {
                print(responseData)
                guard let list = responseData["msg"] else {
                    return
                }
                if self.mode == "edit" {
                    
                }
                else {
                    self.getEmailString(response: list)
                }
            }
            else {
                print("Api Error")
            }
            
        }
        
    }
    
       
        func getEmailString(response: Any) {
           
            let responsevalues = response as! String
           
            print(responsevalues)
            if responsevalues == "New email." {
               
                addVendorApiCall(enabled: "1", vendorId: "")
            }
            else {
                ToastClass.sharedToast.showToast(message: responsevalues, font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                    self.loadingIndicator.isAnimating = false
            }
        }
    
    
    func addVendorApiCall(enabled: String, vendorId: String) {
        
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        guard let name = vendorName.text, name != "" else {
            vendorName.isErrorView(numberOfShakes: 3, revert: true)
            ToastClass.sharedToast.showToast(message: "Enter Vendor Name", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            return
        }
        
        guard let phonenNumber = phone.text, phonenNumber != "",phonenNumber.count == 10  else {
            phone.isErrorView(numberOfShakes: 3, revert: true)
            ToastClass.sharedToast.showToast(message: "Enter Phone Number ", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            return
        }
        
        guard let emailId = email.text, emailId != "" else {
            email.isErrorView(numberOfShakes: 3, revert: true)
            ToastClass.sharedToast.showToast(message: "Enter valid Email address ", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            return
        }
        
        let address = address.text ?? ""
        let city = city.text ?? ""
        let state = state.text ?? ""
        let zipCode = zip.text ?? ""
       
        let now = Date()

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentDate = formatter.string(from: now)
        
        var vendorid = ""
        
       
        loadingIndicator.isAnimating = true
        
        ApiCalls.sharedCall.addVendorAPi(merchant_id: id, name:name , phone: phonenNumber, email: emailId, created_at: currentDate, updated_at: "", enabled: enabled, vendor_id:vendorId , full_address: address, city: city, state: state, zip_code: zipCode) { isSuccess, responseData in
            
            
            if isSuccess {
                
                let list = responseData["message"] as! String
                ToastClass.sharedToast.showToast(message: list, font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                self.loadingIndicator.isAnimating = false
                print(list)
                if list == "Vendor Created Successfully." || list == "Vendor Updated Successfully." {
                    if self.mode == "poadd" {
                        self.dismiss(animated: true) {
                            self.delegate?.getNameEmail(name: name, email: emailId)
                        }
                    }
                    else {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
            else {
                print("Api Error")
            }
        }
    }
    
 


    
    @IBAction func disableBtnClick(_ sender: UIButton) {
        
        
        if sender.currentTitle == "Disable" {
            
            let alertController = UIAlertController(title: "Alert", message: "Are you sure you want to Disabled Vendor ?",
                                                    preferredStyle: .alert)
            
            let cancel = UIAlertAction(title: "No", style: .default) { (action:UIAlertAction!) in
                print("Ok button tapped")
            }
            
            let okAction = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction!) in
                
                print("Ok button tapped")
                print(self.vendorId)
                self.addVendorApiCall(enabled: "0", vendorId: self.vendorId)
               // self.loadIndicator.isAnimating = false
             
            }
            
            alertController.addAction(cancel)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion:nil)
        }
        else {
            
            let alertController = UIAlertController(title: "Alert", message: "Are you sure you want to Enabled Vendor ?",
                                                    preferredStyle: .alert)
            
            
            let cancel = UIAlertAction(title: "No", style: .default) { (action:UIAlertAction!) in
                print("Ok button tapped")
            }
            
            let okAction = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction!) in
                print("Ok button tapped")
                self.addVendorApiCall(enabled: "1", vendorId: self.vendorId)
                //self.loadIndicator.isAnimating = false
                
            }
            
            alertController.addAction(cancel)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion:nil)
        }
    }
    
    @IBAction func selectStateBtnClick(_ sender: UIButton) {
        view.endEditing(true)
        menu.show()
    }
    
    @IBAction func backBtnClick(_ sender: UIButton) {
        if mode == "poadd" {
            dismiss(animated: true)
        }
        else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func homeBtnClick(_ sender: UIButton) {
        
        if mode == "poadd" {
            dismiss(animated: true)
        }
        else {
            let viewcontrollerArray = navigationController?.viewControllers
            var destiny = 0
            if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is HomeViewController }) {
                destiny = destinationIndex
            }
            navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
        }
        
    }
    
    @IBAction func cancelBtnClick(_ sender: UIButton) {
        if mode == "poadd" {
            dismiss(animated: true)
        }
        else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    
    @IBAction func addVendorBtnClick(_ sender: Any) {
     
        emailCheckAPiCall()
      
    }
    
   
   
    func createCustomTextField(textField: MDCOutlinedTextField) {
        
        textField.font = UIFont(name: "Manrope-SemiBold", size: 17.0)
        textField.setOutlineColor(border, for: .normal)
        textField.setOutlineColor(border, for: .editing)
        textField.label.text = nil
        textField.placeholder = "Select State"
        
        textField.setTextColor(.black, for: .normal)
        textField.setTextColor(.black, for: .editing)
    }
    
    private func setupUI() {
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        addVenderBtn.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor
                .constraint(equalTo: addVenderBtn.centerXAnchor, constant: 40),
            loadingIndicator.centerYAnchor
                .constraint(equalTo: addVenderBtn.centerYAnchor),
            loadingIndicator.widthAnchor
                .constraint(equalToConstant: 15),
            loadingIndicator.heightAnchor
                .constraint(equalTo: self.loadingIndicator.widthAnchor)
        ])
        
    }
}

extension AddVendorsVC: UITextFieldDelegate {
    
    
    @objc func updateText(textField: UITextField) {
        var updatetext = textField.text ?? ""
        
        if textField == vendorName {
           
            if updatetext.count > 50 {
                updatetext = String(updatetext.prefix(50))
            }
            
           
            if let last = updatetext.last, [",", "~", "/", "-", "\\"].contains(last) {
                updatetext = String(updatetext.dropLast())
            }
        } else if textField == phone {
          
            if updatetext.count > 10 {
                updatetext = String(updatetext.prefix(10))
            }
        }
        else if textField == zip {
            if updatetext.count > 5 {
                updatetext = String(updatetext.prefix(5))
            }
        }
        
       
        textField.text = updatetext
    }
}
