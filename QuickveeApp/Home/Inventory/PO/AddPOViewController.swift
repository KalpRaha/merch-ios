//
//  AddPOViewController.swift
//  QuickveeApp
//
//  Created by Kalpesh on 31/07/25.
//

import UIKit
import MaterialComponents

protocol PODelegate: AnyObject {
    
    func getPOVendor(vendor: [VendorsPO])
}

class AddPOViewController: UIViewController {

    @IBOutlet weak var vendorName: MDCOutlinedTextField!
    @IBOutlet weak var issueDate: MDCOutlinedTextField!
    @IBOutlet weak var stockDate: MDCOutlinedTextField!
    @IBOutlet weak var referenceDate: MDCOutlinedTextField!
    @IBOutlet weak var vendorEmail: MDCOutlinedTextField!
    
    @IBOutlet weak var addVendorBtn: UIButton!
    
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    var selectArray = [VendorsPO]()
    var mode = ""
    var vendadd: VendorPO?
    
    var addPODetails: PODetails?
    
    var activeTextField = UITextField()
    
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
        
        innerView.backgroundColor = .clear
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(openVendor))
        innerView.addGestureRecognizer(tap)
        tap.numberOfTapsRequired = 1
        innerView.isUserInteractionEnabled = true
        
        let date = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM/dd/yyyy"
        
        issueDate.text = dateFormat.string(from: date)
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
        
        issueDate.delegate = self
        stockDate.delegate = self
        
        let issuedDateImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        issuedDateImage.image = UIImage(named: "date_picker")
        issueDate.trailingView = issuedDateImage
        issueDate.trailingViewMode = .always
        
        let stockDateImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        stockDateImage.image = UIImage(named: "date_picker")
        stockDate.trailingView = stockDateImage
        stockDate.trailingViewMode = .always
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if mode == "add" {
        }
        else {
        
            vendorName.text = addPODetails?.vendor_name
            issueDate.text = addPODetails?.issued_date
            stockDate.text = addPODetails?.stock_date
            referenceDate.text = addPODetails?.reference
            vendorEmail.text = addPODetails?.email
            
            vendorName.isEnabled = false
        }
    }
    
    @objc func openVendor() {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "filtercategory") as! FilterCategoryViewController
        vc.catMode = "AddPOVc"
        vc.delegateVendorSelected = self
        vc.selectVendors = selectArray
        vc.apiMode = "vendor"
        
        present(vc, animated: true)
    }
    
    
    @IBAction func backBtnClick(_ sender: UIButton) {
        
        if mode == "add" {
            navigationController?.popViewController(animated: true)
        }
        else {
            dismiss(animated: true)
        }
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
        
        guard let vname = vendorName.text, vname != "" else {
            vendorName.isError(numberOfShakes: 3, revert: true)
            ToastClass.sharedToast.showToast(message: "Please Enter Vendor Name", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            return
        }
        
        guard let vemail = vendorEmail.text, vemail != "" else {
            vendorEmail.isError(numberOfShakes: 3, revert: true)
            ToastClass.sharedToast.showToast(message: "Please Enter Vendor Email", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            return
        }
        
        let v_id = selectArray[0].vendor_id
        let v_issue = issueDate.text ?? ""
        let v_stock = stockDate.text ?? ""
        let v_reference = referenceDate.text ?? ""
        
        vendadd = VendorPO(id: v_id, name: vname, issue_date: v_issue, stock_date: v_stock, reference: v_reference, vendor_email: vemail)
        mode = "add"
        performSegue(withIdentifier: "toSelectPO", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination as! POSelectViewController
        vc.mode = mode
        vc.vendor = vendadd
    }
}

extension AddPOViewController: PODelegate {
    
    func getPOVendor(vendor: [VendorsPO]) {
        selectArray = vendor
        if vendor.count > 0 {
            let vend = vendor[0]
            vendorName.text = vend.name
            vendorEmail.text = vend.email
        }
        else {
            vendorName.text = ""
            vendorEmail.text = ""
        }
        createCustomTextField(textField: vendorName)
        createCustomTextField(textField: vendorEmail)
    }
}

extension AddPOViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == issueDate || textField == stockDate {
            activeTextField = textField
            openDatePicker(textField: activeTextField)
        }
    }
}

extension AddPOViewController {
    
    func createCustomTextField(textField: MDCOutlinedTextField) {
        
        textField.font = UIFont(name: "Manrope-Medium", size: 14.0)
        textField.setOutlineColor(UIColor(hexString: "#C6CFDB"), for: .normal)
        textField.setOutlineColor(UIColor(hexString: "#C6CFDB"), for: .editing)
        textField.setNormalLabelColor(UIColor(hexString: "#7E7E7E"), for: .normal)
        textField.setNormalLabelColor(UIColor(hexString: "#7E7E7E"), for: .editing)
        textField.setFloatingLabelColor(UIColor(hexString: "#7E7E7E"), for: .normal)
        textField.setFloatingLabelColor(UIColor(hexString: "#7E7E7E"), for: .editing)
    }
    func openDatePicker(textField: UITextField) {
        
        let datePicker = UIDatePicker()
        var doneBtn = UIBarButtonItem()
        
        datePicker.datePickerMode = .date
        doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dateDoneBtn))
        
        datePicker.addTarget(self, action: #selector(datePickerHandler(datePicker:)), for: .valueChanged)
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        textField.inputView = datePicker
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        let cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
        let flexibleBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.setItems([cancelBtn, doneBtn, flexibleBtn], animated: false)
        textField.inputAccessoryView = toolbar
    }
    
    @objc func dateDoneBtn() {
        
        if let datePicker = activeTextField.inputView as? UIDatePicker{
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "MM/dd/yyyy"
            datePicker.minimumDate = Date()
            
            let starttime = dateFormat.string(from: datePicker.date)
            activeTextField.text = starttime
            activeTextField.resignFirstResponder()
        }
    }
    
    @objc func cancelClick(textfield: UITextField) {
        activeTextField.resignFirstResponder()
    }
    
    @objc func datePickerHandler(datePicker: UIDatePicker) {
    }
}
