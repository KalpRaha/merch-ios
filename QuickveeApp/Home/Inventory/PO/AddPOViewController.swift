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

protocol VendorNameEmailDelegate: AnyObject {
    func getNameEmail(name: String, email: String)
}

class AddPOViewController: UIViewController {

    @IBOutlet weak var vendorName: MDCOutlinedTextField!
    @IBOutlet weak var issueDate: MDCOutlinedTextField!
    @IBOutlet weak var stockDate: MDCOutlinedTextField!
    @IBOutlet weak var referenceDate: MDCOutlinedTextField!
    @IBOutlet weak var vendorEmail: MDCOutlinedTextField!
    
    @IBOutlet weak var addVendorBtn: UIButton!
    @IBOutlet weak var addVendorBtnWidth: NSLayoutConstraint!
    @IBOutlet weak var addVendorBtnTrail: NSLayoutConstraint!
    
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var autoPOBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    var selectArray = [VendorsPO]()
    var mode = ""
    var vendadd: VendorPO?
    
    var addPODetails: VendorPO?
    
    var activeTextField = UITextField()
    
    var vendorSelectMode = ""
    var newVendorId = ""
    
    var isAuto = false
    var autoList = [POVendorProduct]()
    
    weak var delegate: ChangeVendorDelegate?
    
    let loadIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFields()
        topView.addBottomShadow()
        
        addVendorBtn.backgroundColor = UIColor(named: "SelectCat")
        addVendorBtn.layer.cornerRadius = 5
        autoPOBtn.layer.cornerRadius = 10
        nextBtn.layer.cornerRadius = 10
        
        autoPOBtn.layer.borderColor = UIColor.black.cgColor
        autoPOBtn.layer.borderWidth = 1
        
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
        
        setupUI()
        
        if mode == "add" {
            addVendorBtnWidth.constant = 54
            addVendorBtnTrail.constant = 10
        }
        else {
        
            vendorName.text = addPODetails?.name
            issueDate.text = addPODetails?.issue_date
            stockDate.text = addPODetails?.stock_date
            referenceDate.text = addPODetails?.reference
            vendorEmail.text = addPODetails?.vendor_email
            addVendorBtnWidth.constant = 0
            addVendorBtnTrail.constant = 0
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
        isAuto = false
        
        present(vc, animated: true)
    }
    
    
    @IBAction func autoBtnClick(_ sender: UIButton) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "filtercategory") as! FilterCategoryViewController
        vc.catMode = "AddPOVc"
        vc.delegateVendorSelected = self
        vc.selectVendors = selectArray
        vc.apiMode = "vendor"
        isAuto = true
        
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
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "addinventvendor") as! AddVendorsVC
        vc.mode = "poadd"
        vc.delegate = self
        present(vc, animated: true)
    }
    
    
    @IBAction func nextBtnClick(_ sender: UIButton) {
        isAuto = false
        nextClick()
    }
    
    func nextClick() {
        
        guard let vname = vendorName.text, vname != "" else {
            vendorName.isError(numberOfShakes: 3, revert: true)
            ToastClass.sharedToast.showToast(message: "Please Enter Vendor Name", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            return
        }
        
        let vemail = vendorEmail.text ?? ""
        
        var v_id = ""
        if vendorSelectMode == "old" {
            v_id = selectArray[0].vendor_id
        }
        else {
            v_id = newVendorId
        }
        let v_issue = issueDate.text ?? ""
        let v_stock = stockDate.text ?? ""
        let v_reference = referenceDate.text ?? ""
        
        vendadd = VendorPO(id: v_id, name: vname, issue_date: v_issue, stock_date: v_stock, reference: v_reference, vendor_email: vemail)
        
        if mode == "add" {
            performSegue(withIdentifier: "toSelectPO", sender: nil)
        }
        else {
            dismiss(animated: true) {
                self.delegate?.didChangeVendor(vendor: self.vendadd!)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination as! POSelectViewController
        vc.mode = mode
        vc.vendor = vendadd
        if isAuto {
            vc.autoSelectedVariants = autoList
        }
        else {
            vc.autoSelectedVariants = []
        }
    }
    
    func vendorCheck(name: String, email: String) {
        
        let m_id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        loadIndicator.isAnimating = true
        
        ApiCalls.sharedCall.getVendorList(merchant_id: m_id) { isSuccess, responseData in
            
            if isSuccess {
                
                guard let list = responseData["result"] else {
                    self.loadIndicator.isAnimating = false
                    return
                }
                self.getResponseValues(list: list, name: name, email: email)
            }
            else {
                self.loadIndicator.isAnimating = false
            }
        }
    }
    
    func getResponseValues(list: Any, name: String, email: String) {
        
        let response = list as! [[String: Any]]
                
        for res in response {
            
            let vendor = VendorModel(vendor_id: "\(res["vendor_id"] ?? "")",
                                     name: "\(res["name"] ?? "")",
                                     phone:"\(res["phone"] ?? "")" ,
                                     email: "\(res["email"] ?? "")",
                                     city: "\(res["city"] ?? "")",
                                     state: "\(res["state"] ?? "")",
                                     zip_code: "\(res["zip_code"] ?? "")",
                                     full_address: "\(res["full_address"] ?? "")",
                                     pay_count: "\(res["pay_count"] ?? "")",
                                     total_pay: "\(res["total_pay"] ?? "")",
                                     recent_pay_amount: "\(res["recent_pay_amount"] ?? "")",
                                     recent_payment_datetime: "\(res["recent_payment_datetime"] ?? "")",
                                     enabled: "\(res["enabled"] ?? "")")
            
            if vendor.email == email {
                vendorName.text = vendor.name
                vendorEmail.text = vendor.email
                newVendorId = vendor.vendor_id
                loadIndicator.isAnimating = false
                break
            }
            else {
                loadIndicator.isAnimating = false
            }
        }
    }
}

extension AddPOViewController: PODelegate {
    
    func getPOVendor(vendor: [VendorsPO]) {
        selectArray = vendor
        if vendor.count > 0 {
            let vend = vendor[0]
            vendorSelectMode = "old"
            vendorName.text = vend.name
            vendorEmail.text = vend.email
            
            let v_id = vendor[0].vendor_id
            
            if isAuto {
                
                nextBtn.isEnabled = false
                loadIndicator.isAnimating = true
                
                let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
                
                ApiCalls.sharedCall.autoPOList(merchant_id: id, admin_id: id, vendor_id: v_id) { isSuccess, responseData in
                    
                    if isSuccess {
                        
                        guard let list = responseData["result"] else {
                            ToastClass.sharedToast.showToast(message: "No Products List Found", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                            self.nextBtn.isEnabled = true
                            self.loadIndicator.isAnimating = false
                            return
                        }
                        
                        self.getResponseValues(products: list)
                    }
                    else {
                        
                    }
                }
            }
        }
        else {
            vendorName.text = ""
            vendorEmail.text = ""
        }
        createCustomTextField(textField: vendorName)
        createCustomTextField(textField: vendorEmail)
    }
    
    func getResponseValues(products: Any) {
        
        let response = products as! [[String:Any]]
        var small = [POVendorProduct]()
        
        for res in response {
            
            let variant = POVendorProduct(assigned_vendors: "\(res["assigned_vendors"] ?? "")", costperItem: "\(res["costperItem"] ?? "")",
                                          item_qty: "\(res["item_qty"] ?? "")", preferd_vendor_cost: "\(res["preferd_vendor_cost"] ?? "")",
                                          prefferd_vendor: "\(res["prefferd_vendor"] ?? "")", product_id: "\(res["product_id"] ?? "")",
                                          product_title: "\(res["product_title"] ?? "")", reorder_level: "\(res["reorder_level"] ?? "")",
                                          reorder_qty: "\(res["reorder_qty"] ?? "")", upc: "\(res["upc"] ?? "")",
                                          variant_id: "\(res["variant_id"] ?? "")", variant_title: "\(res["variant_title"] ?? "")")
            
            small.append(variant)
        }
        
        autoList = small
        
        loadIndicator.isAnimating = false
        nextBtn.isEnabled = true
        isAuto = true
        nextClick()
    }
}

extension AddPOViewController: VendorNameEmailDelegate {
    
    func getNameEmail(name: String, email: String) {
        vendorSelectMode = "new"
        vendorCheck(name: name, email: email)
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
    
    private func setupUI() {
        
        if #available(iOS 13.0, *) {
            
            overrideUserInterfaceStyle = .light
        }
        
        view.addSubview(loadIndicator)
        
        NSLayoutConstraint.activate([
            loadIndicator.centerXAnchor
                .constraint(equalTo: view.centerXAnchor, constant: 0),
            loadIndicator.centerYAnchor
                .constraint(equalTo: view.centerYAnchor),
            loadIndicator.widthAnchor
                .constraint(equalToConstant: 40),
            loadIndicator.heightAnchor
                .constraint(equalTo: self.loadIndicator.widthAnchor)
        ])
    }
    
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
