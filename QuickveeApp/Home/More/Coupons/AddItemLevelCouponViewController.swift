//
//  AddItemLevelCouponViewController.swift
//  QuickveeApp
//
//  Created by Pallavi on 24/10/25.
//

import UIKit
import Alamofire
import MaterialComponents

class AddItemLevelCouponViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var universalView: UIView!
    
    @IBOutlet weak var specificItemView: UIView!
    @IBOutlet weak var couponCodeText: MDCOutlinedTextField!
    @IBOutlet weak var descriptionText: MDCOutlinedTextField!
    @IBOutlet weak var discountText: MDCOutlinedTextField!
    @IBOutlet weak var startDate: MDCOutlinedTextField!
    @IBOutlet weak var endDate: MDCOutlinedTextField!
    @IBOutlet weak var percentBtn: UIButton!
    @IBOutlet weak var dollerBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var universalLbl: UILabel!
    @IBOutlet weak var specificLbl: UILabel!
    @IBOutlet weak var addVariantBtn: UIButton!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var scrollHeight: NSLayoutConstraint!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var enableRedemptionSwitch: UISwitch!
    
    @IBOutlet weak var enableRedemptionText: MDCOutlinedTextField!
    
    @IBOutlet weak var maximumDiscText: MDCOutlinedTextField!
    @IBOutlet weak var redemptionHeight: NSLayoutConstraint!
    
    @IBOutlet weak var maxdiscountHeight: NSLayoutConstraint!
    
    @IBOutlet weak var maxDiscountLabel: UILabel!
   
    @IBOutlet weak var maxDiscTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var maxdiscBottom: NSLayoutConstraint!
    
    
    @IBOutlet weak var percentBtnStack: UIStackView!
    
    @IBOutlet weak var discountAmtlbl: UILabel!
    
    var varient_List = [BogoVariantModel]()
    var variantArray = [VariantBogoModel]()
    var subvarArray =  [VariantBogoModel]()
    var selectedAllEditIds = [String]()
    var coupon_exist_ids = [String]()
    
    var couponItemArray :Coupon?
   
    var activeTextField = UITextField()
    
    var itemsEditIds = ""
    var mode = ""
    var coup_type = ""
    var coupon_id = ""
    var setFlag = "1"
    var type = ""
    var dollarAmt = ""
    
    var couponNameArray = [Coupon]()
    
    
    private var isSymbolOnRight = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setUI()
       
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(universalViewClick))
        universalView.addGestureRecognizer(tap1)
        tap1.numberOfTapsRequired = 1
        universalView.isUserInteractionEnabled = true
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(specificItemViewClick))
        specificItemView.addGestureRecognizer(tap2)
        tap2.numberOfTapsRequired = 1
        specificItemView.isUserInteractionEnabled = true
        
        tableview.delegate = self
        tableview.dataSource = self
        
  
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        setMode()
        coup_type = "universal"
        
        if couponItemArray?.type == "2" {
            specificItemViewClick()
            variantListApi()
            subvarArray = []
        }
        else {
            universalViewClick()
        }
    }
    

    
    func setUI(){
        
        type = "1"
        universalView.layer.borderWidth = 1
        universalView.layer.borderColor = UIColor(hexString: "#ECEFF3").cgColor
        specificItemView.layer.borderWidth = 1
        specificItemView.layer.borderColor = UIColor(hexString: "#ECEFF3").cgColor
        cancelBtn.layer.cornerRadius = 5
        cancelBtn.layer.borderWidth = 1
        cancelBtn.layer.borderColor = UIColor.black.cgColor
        addBtn.layer.cornerRadius = 5
        topView.addBottomShadow()
        dollerBtn.layer.cornerRadius = 5
        percentBtn.layer.cornerRadius = 5
        startDate.delegate = self
        endDate.delegate = self
        addVariantBtn.layer.cornerRadius = 10
        universalView.layer.cornerRadius = 5
        specificItemView.layer.cornerRadius = 5
        
        percentBtn.backgroundColor = UIColor.init(hexString: "#EEEEEE")
        percentBtn.setImage(UIImage(named: "PercentSymbol"), for: .normal)
        dollerBtn.backgroundColor = UIColor.init(hexString: "#0A64F9")
        dollerBtn.setImage(UIImage(named: "dolllerSym"), for: .normal)
        
        maximumDiscText.isHidden = true
        maxdiscountHeight.constant = 0
        maxDiscountLabel.isHidden = true
        maxDiscTopConstraint.constant = 0
        maxdiscBottom.constant = 0
       
        percentBtnStack.isHidden = true
        percentBtn.isHidden = true
        dollerBtn.isHidden = true
        addVariantBtn.isHidden = true
        
        createCustomTextField(textField: couponCodeText)
        createCustomTextField(textField: enableRedemptionText)
        createCustomTextField(textField: descriptionText )
        createCustomTextField(textField: discountText)
        createCustomTextField(textField: startDate)
        createCustomTextField(textField: endDate)
        createCustomTextField(textField: maximumDiscText)
        
        couponCodeText.label.text = "Coupon Code"
        descriptionText.label.text = "Description"
        discountText.label.text = "Enter Discount Amount"
        enableRedemptionText.label.text = "Redemption Limit"
        startDate.label.text = "Start Date"
        endDate.label.text = "End Date"
        maximumDiscText.label.text = "Maximum Discount Amount ($)"
     
       // universalView.applySideAndBottomShadow()
        discountText.keyboardType = .numberPad
        maximumDiscText.keyboardType = .numberPad
        
        maximumDiscText.delegate = self
        couponCodeText.delegate = self
        enableRedemptionText.delegate = self
        descriptionText.delegate = self
        discountText.delegate = self
        startDate.delegate = self
        endDate.delegate = self
       
        enableRedemptionSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        enableRedemptionSwitch.addTarget(self, action: #selector(enableRedemption), for: .valueChanged)
        discountText.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        couponCodeText.addTarget(self, action: #selector(updateTextCapsField), for: .editingChanged)
        enableRedemptionText.addTarget(self, action: #selector(updateTextCapsField), for: .editingChanged)
        maximumDiscText.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
    }
    
    
    func setMode(){
        
        if mode == "edit" {
         
            if couponItemArray?.type == "1" {
                couponCodeText.text = couponItemArray?.name
                descriptionText.text = couponItemArray?.description
                discountText.text = couponItemArray?.discount
                enableRedemptionText.text = couponItemArray?.enable_limit
                addVariantBtn.isHidden = true
                
                let start_date = ToastClass.sharedToast.setCouponsDateFormat(dateStr: couponItemArray?.date_valid ?? "")
           
                startDate.text = start_date
              
                let end_date = ToastClass.sharedToast.setCouponsDateFormat(dateStr: couponItemArray?.date_expire ?? "")
              
                endDate.text = end_date
                
                
                if couponItemArray?.enable_limit == "1"  {
                    enableRedemptionText.isHidden = false
                    enableRedemptionSwitch.isOn = true
                    redemptionHeight.constant = 50
                    
                }else {
                    enableRedemptionText.isHidden = true
                    enableRedemptionSwitch.isOn = false
                    redemptionHeight.constant = 0
                }
                
                
            }
            else {
                couponCodeText.text = couponItemArray?.name
                descriptionText.text = couponItemArray?.description
                discountText.text = couponItemArray?.discount
                maximumDiscText.text = couponItemArray?.maximum_discount
                print(couponItemArray?.enable_limit)
                enableRedemptionText.text = couponItemArray?.enable_limit
                addVariantBtn.isHidden = false
                dollarAmt = discountText.text!
                
                let start_date = ToastClass.sharedToast.setCouponsDateFormat(dateStr: couponItemArray?.date_valid ?? "")
                startDate.text = start_date
              
                let end_date = ToastClass.sharedToast.setCouponsDateFormat(dateStr: couponItemArray?.date_expire ?? "")
                endDate.text = end_date
                
                if couponItemArray?.enable_limit == "1"  {
                    enableRedemptionText.isHidden = false
                    enableRedemptionSwitch.isOn = true
                    redemptionHeight.constant = 50
                    
                }else {
                    enableRedemptionText.isHidden = true
                    enableRedemptionSwitch.isOn = false
                    redemptionHeight.constant = 0
                }
                
                if couponItemArray?.flag == "0" {
                    percentBtn.backgroundColor = UIColor.init(hexString: "#0A64F9")
                    percentBtn.setImage(UIImage(named: "PerwhiteIcon"), for: .normal)
                    dollerBtn.backgroundColor = UIColor.init(hexString: "#EEEEEE")
                    dollerBtn.setImage(UIImage(named: "dollerGrey"), for: .normal)
                    maximumDiscText.isHidden = false
                    maxdiscountHeight.constant = 50
                    maxDiscountLabel.isHidden = false
                    maxDiscTopConstraint.constant = 20
                    maxdiscBottom.constant = 10
                }
                else {
                    
                    dollerBtn.backgroundColor = UIColor.init(hexString: "#0A64F9")
                    dollerBtn.setImage(UIImage(named: "dolllerSym"), for: .normal)
                    percentBtn.backgroundColor = UIColor.init(hexString: "#EEEEEE")
                    percentBtn.setImage(UIImage(named: "PercentSymbol"), for: .normal)
                }
            }
            
        }
        else {
            
            enableRedemptionText.isHidden = true
            enableRedemptionSwitch.isOn = false
            redemptionHeight.constant = 0
            
            if coup_type == "coup_type" {
                universalView.applySideOnlyShadow()
            }
            else {
                
            }
        }
    }
  
    func getvarId() -> [[String:[String]]] {
        
        var small = [[String:[String]]]()
        
        for id in 0..<variantArray.count {
            
            if variantArray[id].bogo.isvarient == "1" {
                
                small.append([variantArray[id].bogo.id:[variantArray[id].bogo.var_id]])
            }else{
                small.append([variantArray[id].bogo.product_id:[""]])
            }
            print(small)
        }
        return small
    }
   
    func validateParams() {
        
      
        var redemption = ""
        var dis_percent = ""
        var is_online = ""
        let list_online = ""
        var enable_redemption = ""
        var flag = ""
        var max_disc_amt = ""
        
        
        guard let coupon_code = couponCodeText.text, coupon_code != "",
              checkNameDuplicate(name: coupon_code) else {
            couponCodeText.isError(numberOfShakes: 3, revert: true)
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            button.setImage(UIImage(named: "warning"), for: .normal)
            couponCodeText.trailingView = button
            couponCodeText.trailingViewMode = .always
            button.addTarget(self, action: #selector(checkCouponName), for: .touchUpInside)
            return
        }
       
        guard let desc = descriptionText.text else {
            descriptionText.isError(numberOfShakes: 3, revert: true)
            return
        }
        
        
        enable_redemption = checkRedemption()
        
        if enable_redemption == "1" {
            guard let enable_redeemText = enableRedemptionText.text, enable_redeemText != "" else {
                enableRedemptionText.isError(numberOfShakes: 3, revert: true)
                let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
                button.setImage(UIImage(named: "warning"), for: .normal)
                enableRedemptionText.trailingView = button
                enableRedemptionText.trailingViewMode = .always
                button.addTarget(self, action: #selector(checkRedemLbl), for: .touchUpInside)
                return
            }
            redemption = enable_redeemText
        }
        else {
            redemption = ""
        }
        
        if coup_type == "universal" {
            
            guard let dis_amt = discountText.text, dis_amt != "",  dis_amt != "0.00" else {
                discountText.isError(numberOfShakes: 3, revert: true)
                let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
                button.setImage(UIImage(named: "warning"), for: .normal)
                discountText.trailingView = button
                discountText.trailingViewMode = .always
                button.addTarget(self, action: #selector(checkDiscountPercent), for: .touchUpInside)
                return
            }
            dis_percent = dis_amt
            flag = "1"
        }
        else {
            
            
            flag = checkdiscountSelection()
            
            if flag == "1" { //amt
                
                guard let dis_amt = discountText.text, dis_amt != "",  dis_amt != "0.00" else {
                    discountText.isError(numberOfShakes: 3, revert: true)
                    let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
                    button.setImage(UIImage(named: "warning"), for: .normal)
                    discountText.trailingView = button
                    discountText.trailingViewMode = .always
                    button.addTarget(self, action: #selector(checkDiscountPercent), for: .touchUpInside)
                    return
                }
                dis_percent = dis_amt
            }
            
            else { //percent
                
                guard let dis_per = discountText.text, dis_per != "", dis_per != "0.00" else {
                    discountText.isError(numberOfShakes: 3, revert: true)
                    let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
                    button.setImage(UIImage(named: "warning"), for: .normal)
                    discountText.trailingView = button
                    discountText.trailingViewMode = .always
                    button.addTarget(self, action: #selector(checkDiscountPercent), for: .touchUpInside)
                    return
                }
                dis_percent = dis_per
                
                if dis_per == "100.00" {
                    is_online = "0"
                }
                
            }
            
            if setFlag == "0" {
                if checkMaxDiscount(max: dis_percent) {
                    
                    guard let max_dis = maximumDiscText.text, max_dis != "" else {
                        maximumDiscText.isError(numberOfShakes: 3, revert: true)
                        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
                        button.setImage(UIImage(named: "warning"), for: .normal)
                        maximumDiscText.trailingView = button
                        maximumDiscText.trailingViewMode = .always
                        button.addTarget(self, action: #selector(checkMinAmtLess), for: .touchUpInside)
                        return
                    }
                    max_disc_amt = max_dis
                }
                else {
                    max_disc_amt = "0.00"
                }
                
            }
        }
     
        guard let start_date = startDate.text, start_date != "" else {
            
            startDate.isError(numberOfShakes: 3, revert: true)
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            button.setImage(UIImage(named: "warning"), for: .normal)
            startDate.trailingView = button
            startDate.trailingViewMode = .always
            button.addTarget(self, action: #selector(checkStartDateValid), for: .touchUpInside)
            showAlert(title: "Alert", message: "Please enter valid start date")
            return
        }
        
        guard let end_date = endDate.text, end_date != "" else {
            endDate.isError(numberOfShakes: 3, revert: true)
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            button.setImage(UIImage(named: "warning"), for: .normal)
            endDate.trailingView = button
            endDate.trailingViewMode = .always
            button.addTarget(self, action: #selector(checkEndDateValid), for: .touchUpInside)
            showAlert(title: "Alert", message: "Please enter valid end date")
            return
        }
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        
        if mode == "add" {
            
            if coup_type == "specific" {
                if variantArray.count == 0 {
                    ToastClass.sharedToast.showToast(message: "Please Select At least 1 Product Varient",
                                                     font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                }
                else {
                    
                    let itemsString = setDataMix()
                    
                    let change_start_date = ToastClass.sharedToast.setCouponlistDate(dateStr: start_date)
                    let change_end_date = ToastClass.sharedToast.setCouponlistDate(dateStr: end_date)
                    
                  
                    
                    ApiCalls.sharedCall.addCoupanCall(merchant_id: id, is_online: is_online, coupon_code: coupon_code, description: desc, min_order_amount:dis_percent , enable_redemption_limit: enable_redemption, redemption_limit: redemption, flag: flag, discount: dis_percent, max_discount_amount: max_disc_amt, start_date: change_start_date, end_date: change_end_date, start_time: "", end_time: "", category_id: "", coupon_type: "0", items: itemsString, list_online: list_online, type: type) { isSuccess, responseData in
                        
                        if isSuccess {
                            
                            let msg = responseData["message"] as? String ?? ""
                            
                            // self.loadIndicator.isAnimating = false
                            ToastClass.sharedToast.showToast(message: msg,
                                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                            if msg == "Coupon added successfully."  {
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                        else {
                            print("API Error")
                        }
                    }
                    
                }
            }else if coup_type == "universal"  {
                
                let change_start_date = ToastClass.sharedToast.setCouponlistDate(dateStr: start_date)
                let change_end_date = ToastClass.sharedToast.setCouponlistDate(dateStr: end_date)
                
                
                ApiCalls.sharedCall.addCoupanCall(merchant_id: id, is_online: is_online, coupon_code: coupon_code, description: desc, min_order_amount:dis_percent , enable_redemption_limit: enable_redemption, redemption_limit: redemption, flag: flag, discount: dis_percent, max_discount_amount: max_disc_amt, start_date: change_start_date, end_date: change_end_date, start_time: "", end_time: "", category_id: "", coupon_type: "0", items: "", list_online: list_online, type: type) { isSuccess, responseData in
                    
                    if isSuccess {
                        
                        let msg = responseData["message"] as? String ?? ""
                        
                        // self.loadIndicator.isAnimating = false
                        ToastClass.sharedToast.showToast(message: msg,
                                                         font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                        if msg == "Coupon added successfully."  {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                    else {
                        print("API Error")
                    }
                }
                
            }
        }else {
            
            if coup_type == "specific" {
                if variantArray.count == 0 {
                    ToastClass.sharedToast.showToast(message: "Please Select At least 1 Product Varient",
                                                     font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                }
                else {
                    
                    let itemsString = setDataMix()
                    
                    let change_start_date = ToastClass.sharedToast.setCouponlistDate(dateStr: start_date)
                    let change_end_date = ToastClass.sharedToast.setCouponlistDate(dateStr: end_date)
                    
                   
                    ApiCalls.sharedCall.editCoupanCall(coupon_id: coupon_id, merchant_id:  id, is_online: is_online, coupon_code: coupon_code, description: desc, min_order_amount: dis_percent, enable_redemption_limit: enable_redemption, redemption_limit: redemption, flag: flag, discount: dis_percent, max_discount_amount: max_disc_amt, start_date: change_start_date, end_date: change_end_date, start_time: "", end_time: "", category_id: "", coupon_type: "0", items: itemsString, list_online: list_online, type: type) { isSuccess, responseData in
                        
                        if isSuccess {
                            
                            let msg = responseData["message"] as? String ?? ""
                            
                            // self.loadIndicator.isAnimating = false
                            ToastClass.sharedToast.showToast(message: msg,
                                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                            if msg == "Coupon updated successfully."  {
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                        else {
                            print("API Error")
                        }
                    }
                    
                }
            }else if coup_type == "universal"  {
                
                let change_start_date = ToastClass.sharedToast.setCouponlistDate(dateStr: start_date)
                let change_end_date = ToastClass.sharedToast.setCouponlistDate(dateStr: end_date)
             
                ApiCalls.sharedCall.editCoupanCall(coupon_id: coupon_id, merchant_id:  id, is_online: is_online, coupon_code: coupon_code, description: desc, min_order_amount: dis_percent, enable_redemption_limit: enable_redemption, redemption_limit: redemption, flag: flag, discount: dis_percent, max_discount_amount: max_disc_amt, start_date: change_start_date, end_date: change_end_date, start_time: "", end_time: "", category_id: "", coupon_type: "0", items: "", list_online: list_online, type: type) { isSuccess, responseData in
                    
                    if isSuccess {
                        
                        let msg = responseData["message"] as? String ?? ""
                        
                        // self.loadIndicator.isAnimating = false
                        ToastClass.sharedToast.showToast(message: msg,
                                                         font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                        if msg == "Coupon updated successfully."  {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                    else {
                        print("API Error")
                    }
                }
                
            }
        }
        
    }
    
    
    func setDataMix() -> String {
        
        let varientId = getvarId()
        
        var textstring = [[String:[String]]]()
        var keyarr = [String]()
        var indexKey = 0
        
        for idd in varientId {
            
            for (key,value) in idd {
                
                if keyarr.contains(where: {$0 == key}) {
                    
                    indexKey = keyarr.firstIndex(where: {$0 == key}) ?? 0
                    let val = textstring[indexKey]
                    var varval = val[key]!
                    varval.append(contentsOf: value)
                    textstring[indexKey].updateValue(varval, forKey: key)
                }
                
                else {
                    keyarr.append(key)
                    textstring.append(idd)
                }
            }
        }
        
        var idarr = [[String:Any]]()
        for var_dict in textstring {
            
            for (dict_key, dict_value) in var_dict {
                
                idarr.append([dict_key:dict_value])
                //print(idarr)  //["604169:[\"\"]", "607682:[\"1293014\", \"1293015\", \"1293016\"]"]
            }
        }
        
        var varString = ""
        for vars in 0..<idarr.count {
            
            if vars == idarr.count - 1 {
                let firststr = "\(idarr[vars])".dropFirst()
                let laststr = firststr.dropLast()
                varString += laststr
            }
            
            else {
                let firststr = "\(idarr[vars])".dropFirst()
                let laststr = firststr.dropLast()
                varString += "\(laststr),"
            }
        }
        let emp = "{\(varString)}"
        
      return emp
    }
    
 
    @objc func enableRedemption(enableSwitch: UISwitch) {
        
        if enableSwitch.isOn {
            enableSwitch.isOn = true
            enableRedemptionText.isHidden = false
            redemptionHeight.constant = 52.66
           // scrollHeight.constant += 52.66
        }
        else {
            enableSwitch.isOn = false
            enableRedemptionText.isHidden = true
            redemptionHeight.constant = 0
           // scrollHeight.constant -= 52.66
        }
    }
    
    @objc func universalViewClick() {
        
        universalView.layer.borderWidth = 1
        universalView.layer.borderColor = UIColor(hexString: "#0A64F9").cgColor
        specificItemView.layer.borderWidth = 1
        specificItemView.layer.borderColor = UIColor(hexString: "#ECEFF3").cgColor
        universalLbl.textColor = UIColor(hexString: "#0A64F9")
        specificLbl.textColor = UIColor.black
        tableview.isHidden = true
        coup_type = "universal"
        type = "1"
        percentBtnStack.isHidden = true
        percentBtn.isHidden = true
        dollerBtn.isHidden = true
        addVariantBtn.isHidden = true
        universalView.applySideOnlyShadow()
        specificItemView.removeShadow()
    }
    
    @objc func specificItemViewClick() {
        specificItemView.layer.borderWidth = 1
        specificItemView.layer.borderColor = UIColor(hexString: "#0A64F9").cgColor
        universalView.layer.borderWidth = 1
        universalView.layer.borderColor = UIColor(hexString: "#ECEFF3").cgColor
        specificLbl.textColor = UIColor(hexString: "#0A64F9")
        universalLbl.textColor = UIColor.black
        tableview.isHidden = false
        coup_type = "specific"
        addVariantBtn.isHidden = false
        type = "2"
        percentBtnStack.isHidden = false
        percentBtn.isHidden = false
        dollerBtn.isHidden = false
        addVariantBtn.isHidden = false
        specificItemView.applySideOnlyShadow()
        universalView.removeShadow()
        
        if mode == "edit" {
            variantListApi()
        }
        else {
            
        }
    }
    
    @IBAction func backBtnClick(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func percentBtnClick(_ sender: UIButton) {
        
        if discountText.text == "" || discountText.text == "0.00"  {
            
            percentBtn.backgroundColor = UIColor.init(hexString: "#0A64F9")
            dollerBtn.backgroundColor = UIColor.init(hexString: "#EEEEEE")
            percentBtn.setImage(UIImage(named: "PerwhiteIcon"), for: .normal)
            dollerBtn.setImage(UIImage(named: "dollerGrey"), for: .normal)
            
            discountText.label.text = "Discount Percentage"
            discountAmtlbl.text = "Discount Percentage"
            maximumDiscText.isHidden = false
            maxdiscountHeight.constant = 50
            maxDiscountLabel.isHidden = false
            maxDiscTopConstraint.constant = 20
            maxdiscBottom.constant = 10
            setFlag = "0"
        }
        else {
            ToastClass.sharedToast.showToast(message: "Please clear the Discount Amount first",
                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
        }
    }
    
    
    @IBAction func dollerBtnClick(_ sender: UIButton) {
        
        dollerBtn.backgroundColor = UIColor.init(hexString: "#0A64F9")
        percentBtn.backgroundColor = UIColor.init(hexString: "#EEEEEE")
        percentBtn.setImage(UIImage(named: "PercentSymbol"), for: .normal)
        dollerBtn.setImage(UIImage(named: "dolllerSym"), for: .normal)
        
        discountText.label.text = "Enter Discount Amount"
        discountAmtlbl.text = "Discount Amount"
        maximumDiscText.isHidden = true
        maxdiscountHeight.constant = 0
        maxDiscountLabel.isHidden = true
        maxDiscTopConstraint.constant = 0
        maxdiscBottom.constant = 0
        
        setFlag = "1"
    }
    
    @IBAction func deletBtnClick(_ sender: UIButton) {
       
        if mode == "edit" {
            let del_id = coupon_id
            showDeleteAlert(id: del_id)
        }
        else {
            
        }
    }
    
    @IBAction func cancelBtnClick(_ sender: UIButton) {
        
    }
    
    @IBAction func addBtnClick(_ sender: UIButton) {
        
        validateParams()
    }
    
    @IBAction func closeBtnClick(_ sender: UIButton) {
        let index = sender.tag
        let arr = variantArray[sender.tag]
        removeVarient(arr: arr, index: index)
    }
    
    @IBAction func addVariantBtnClick(_ sender: UIButton) {
     
        guard let disc = discountText.text, disc != "", disc != "0.00" else {
            ToastClass.sharedToast.showToast(message: "Enter Amount",
                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            discountText.isError(numberOfShakes: 3, revert: true)
            return
        }
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "selectBogoVariant") as! SelectBogoVariantViewController
        
        vc.mode_Type = "coupon"
        vc.coupon_exist_ids = coupon_exist_ids
        vc.coupdisc_amt = dollarAmt
        print(variantArray)
        vc.couponSelectedVariants = variantArray
        vc.adddelegate = self
        
        //vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: {
            vc.presentationController?.presentedView?.gestureRecognizers?[0].isEnabled = false
        })
    }
    
    @objc func checkCouponName() {
        
        showAlert(title: "Alert", message: "Please enter valid coupon name")
    }
    
    @objc func checkMinOrder() {
        
        showAlert(title: "Alert", message: "Please enter valid minimum order amount ")
    }
    
    @objc func checkRedemLbl() {
        showAlert(title: "Alert", message: "Please enter a valid redemption amount ")
    }
    
    @objc func checkDiscountPercent() {
        showAlert(title: "Alert", message: "Please enter a valid discount amount")
    }
    
    @objc func checkMinAmtLess() {
        showAlert(title: "Alert", message: "Discount amount cannot be greater than minimum amount")
    }
    
    @objc func checkStartDateValid() {
        showAlert(title: "Alert", message: "Please enter a valid start date")
    }
    
    @objc func checkEndDateValid() {
        showAlert(title: "Alert", message: "Please enter a valid end date")
    }
    
    func checkRedemption() -> String {
        
        if enableRedemptionSwitch.isOn {
            return "1"
        }
        else {
            return "0"
        }
    }
    
    func checkMaxDiscount(max: String) -> Bool {
        
        let max_doub = Double(max) ?? 0.00
        
        if max_doub < 100.00 {
            return true
        }
        return false
    }
    
    func checkdiscountSelection() -> String {
        
        if dollerBtn.backgroundColor == UIColor.init(hexString: "#0A64F9") {
            return "1"
        }
        else {
            return "0"
        }
    }
    
    func showDeleteAlert(id: String) {
        
        let alertController = UIAlertController(title: "Alert", message: "Are you sure you want to delete this coupon?", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "No", style: .default) { (action:UIAlertAction!) in
            
            print("Ok button tapped")
            
        }
        let okAction = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction!) in
            
            print("Ok button tapped")
            
            self.setupDeleteApi(id: id)
            
        }
        
        alertController.addAction(cancel)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion:nil)
        
    }
    
 
    func setupDeleteApi(id: String) {
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        let url = AppURLs.COUPON_DELETE
        
        let parameters: [String:Any] = [
            "merchant_id": id,
            "coupon_id": coupon_id
        ]
        print(parameters)
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseData { (response) in
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(json)
                    
                    self.navigationController?.popViewController(animated: true)
                }
                catch {
                    
                }
                
                break
                
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
    }
    
    func convertStringToDictionary(text: String) -> [String:Any] {
       
        if let data = text.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String:Any]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return [:]
    }
    
    func checkNameDuplicate(name: String) -> Bool {
        
        if couponNameArray.count == 0 {
            return true
        }
        
        else {
            
            if mode == "add" {
                for i in 0...couponNameArray.count - 1 {
                    if couponNameArray[i].name.lowercased() == name.lowercased() {
                        return false
                    }
                }
                return true
            }
            else {
                for i in 0...couponNameArray.count - 1 {
                    
                    if couponNameArray[i].name.lowercased() == name.lowercased() {
                        
                        if couponNameArray[i].id == coupon_id {
                            return true
                        }
                        return false
                    }
                }
                return true
            }
        }
    }
    
    func variantListApi() {
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        ApiCalls.sharedCall.variantListCall(merchant_id: id) { isSuccess, responseData in
            
            if isSuccess {
                
                guard let list = responseData["result"] else {
                    return
                }
                self.getResponseValues(varient: list)
                
            }else{
                print("Api Error")
            }
        }
    }
    
    func getResponseValues(varient: Any) {
        
        let response = varient as! [[String: Any]]
        var small = [BogoVariantModel]()
        for res in response {
            
            let variant = BogoVariantModel(id: "\(res["id"] ?? "")",
                                           title: "\(res["title"] ?? "")",
                                           isvarient: "\(res["isvarient"] ?? "")",
                                           upc: "\(res["upc"] ?? "")",
                                           cotegory: "\(res["cotegory"] ?? "")",
                                           var_id: "\(res["var_id"] ?? "")",
                                           var_upc: "\(res["var_upc"] ?? "")",
                                           quantity: "\(res["quantity"] ?? "")",
                                           price: "\(res["price"] ?? "")",
                                           custom_code: "\(res["custom_code"] ?? "")",
                                           variant: "\(res["variant"] ?? "")",
                                           var_price: "\(res["var_price"] ?? "")",
                                           product_id: "\(res["product_id"] ?? "")",
                                           costperItem: "\(res["costperItem"] ?? "")",
                                           is_lottery: "\(res["is_lottery"] ?? "")",
                                           var_costperItem: "\(res["var_costperItem"] ?? "")")
            
            
            if variant.is_lottery == "0" {
                small.append(variant)
            }
        }
        varient_List = small
        print(varient_List)
       
        if varient_List.count == 0 {
            
        }
        else {
            getEditItemsIds()
            getEditVarients(list: varient_List)
        }
    }
    
    
    func getEditItemsIds() {
        
        selectedAllEditIds.removeAll()
        
        var small = [String]()
        var keyArr = [String]()
        var valuesArr = [String]()
        
       
        
        let items = convertStringToDictionary(text: itemsEditIds)
        
        for (key, value) in items {
            keyArr.append(key)
            
            let valueId = value as? [String] ?? []
            for val in valueId {
                if val.count == 0 {
                    
                }else {
                    valuesArr.append(val)
                }
            }
            small = keyArr + valuesArr
            selectedAllEditIds = small
        }
    }
    
    
    
    func getEditVarients(list: [BogoVariantModel]) {
        
        variantArray.removeAll()
        subvarArray.removeAll()
        
        for variant in list {
            
            if variant.isvarient == "1" {
                
                if selectedAllEditIds.contains(where: { $0 == variant.var_id})  {
                    variantArray.append(VariantBogoModel(bogo: variant, isSelect: true))
                }
            }
            else {
                if selectedAllEditIds.contains(where: { $0 == variant.product_id})  {
                    
                    variantArray.append(VariantBogoModel(bogo: variant, isSelect: true))
                }
            }
        }
        
        
        subvarArray = variantArray
        print(subvarArray)
        
        DispatchQueue.main.async {
            self.tableview.reloadData()
            self.tableHeight.constant = CGFloat(100 * self.variantArray.count)
            let table = self.tableHeight.constant
            
            self.scrollHeight.constant = table + 700
        }
    }
    
    func removeVarient(arr: VariantBogoModel, index: Int) {
        
        variantArray.remove(at: index)
        if arr.bogo.isvarient == "1" {
            subvarArray.removeAll(where: {$0.bogo.var_id == arr.bogo.var_id})
            coupon_exist_ids.removeAll(where: {$0 == arr.bogo.product_id})
        }
        else {
            subvarArray.removeAll(where: {$0.bogo.product_id == arr.bogo.product_id})
            coupon_exist_ids.removeAll(where: {$0 == arr.bogo.product_id})
        }
        tableview.reloadData()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        
        if activeTextField == startDate || activeTextField == endDate {
            openDatePicker(textField: activeTextField, tag: activeTextField.tag)
        }
        else if activeTextField == discountText {
            print("yes")
        }
    }
    
    
    func showAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
    
    func checkPrice(varamt: String, textAmt: String) -> Bool {
        
        let v_amt = Double(varamt) ?? 0.00
        let textAmt = Double(textAmt) ?? 0.00
        
        if v_amt > textAmt {
            return false
        }
        return true
    }
    
}

extension AddItemLevelCouponViewController {

    @objc func updateTextField(textField: MDCOutlinedTextField) {
        
        var cleanedAmount = ""
        
        for character in textField.text ?? "" {
            if character.isNumber {
                cleanedAmount.append(character)
            }
        }
        
        if isSymbolOnRight {
            cleanedAmount = String(cleanedAmount.dropLast())
        }
        //Format the number based on number of decimal digits
        //ie. USD
        
        //        if Double(cleanedAmount) ?? 0.00 {
        
         if textField == maximumDiscText {
            if Double(cleanedAmount) ?? 0.00 > 99999999 {
                cleanedAmount = String(cleanedAmount.dropLast())
            }
        }
        else if textField == discountText {
            if couponItemArray?.type == "1" || coup_type == "universal"{
                if Double(cleanedAmount) ?? 00000 > 99999 {
                    cleanedAmount = String(cleanedAmount.dropLast())
                }
            }
            else {
                print(setFlag)
                if setFlag == "1" {
                    if Double(cleanedAmount) ?? 00000 > 99999999 {
                        cleanedAmount = String(cleanedAmount.dropLast())
                    }
                }
                else {
//                    if Double(cleanedAmount) ?? 00000 > 9999 {
//                        cleanedAmount = String(cleanedAmount.dropLast())
//                    }
                    if Double(cleanedAmount) ?? 0.00 > 10000 {
                        cleanedAmount = String(cleanedAmount.dropLast())
                    }
                }
            }
        }
        let amount = Double(cleanedAmount) ?? 0.0
        let amountAsDouble = (amount / 100.0)
        var amountAsString = String(amountAsDouble)
        if cleanedAmount.last == "0" {
            amountAsString.append("0")
        }
        textField.text = amountAsString
        
        //        if textField.text == "0.00" {
        //            textField.text = "0.00"
        //        }
    }
    
    
    
    func getlessAmtVarient() {
        
        var small = [VariantBogoModel]()
        
        let amt = discountText.text ?? ""
        
        print(amt)
        
        for i in 0..<variantArray.count {
            
            if variantArray[i].bogo.isvarient == "1" {
                let checkless = checkPrice(varamt: variantArray[i].bogo.var_price, textAmt: amt)
                if checkless {
                    
                }
                else {
                    small.append(variantArray[i])
                }
            }
            else {
                
                let checkless = checkPrice(varamt: variantArray[i].bogo.price, textAmt: amt)
                if checkless {
                    
                }
                else {
                    small.append(variantArray[i])
                }
            }
        }
        variantArray = small
        subvarArray = small
        tableview.reloadData()
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let discount = Double(discountText.text ?? "0") ?? 0.00
        
        let formattedDiscount = String(format: "%.2f", discount)
        
        if coup_type == "specific" {
            if textField == discountText {
                if setFlag == "1" {
                    dollarAmt = formattedDiscount
                    getlessAmtVarient()
                }
                else {
                    dollarAmt = ""
                }
            }
        }
    }
    
      @objc func updateTextCapsField(textField: MDCOutlinedTextField) {
          
          if textField == couponCodeText {
              
              if textField.text!.count == 12  {
                  textField.text = String(textField.text!.dropLast())
              }
              
              else if textField.text!.count > 0 {
                  createCustomTextField(textField: couponCodeText)
                  couponCodeText.trailingView?.isHidden = true
                  textField.text = textField.text?.uppercased()
              }
              
              else {
                  textField.text = textField.text?.uppercased()
                  
              }
          }
          
          else if textField == descriptionText {
              
              if textField.text!.count == 51 {
                  textField.text = String(textField.text!.dropLast())
              }
          }
          
          else if textField == enableRedemptionText {
              
              if textField.text?.count == 4 {
                  textField.text = String(textField.text!.dropLast())
              }
          }
          
      }
}

extension AddItemLevelCouponViewController {
    
    func openDatePicker(textField: UITextField, tag: Int) {
        
        let datePicker = UIDatePicker()
        var doneBtn = UIBarButtonItem()
        if tag < 3 {
            datePicker.datePickerMode = .date
            doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dateDoneBtn))
        }
        datePicker.addTarget(self, action: #selector(datePickerHandler(datePicker:)), for: .valueChanged)
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        textField.inputView = datePicker
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        let cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        let flexibleBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.setItems([cancelBtn, doneBtn, flexibleBtn], animated: false)
        textField.inputAccessoryView = toolbar
    }
    
    @objc func cancel(textfield: UITextField) {
        
        activeTextField.resignFirstResponder()
    }
    
    @objc func dateDoneBtn() {
        
        if let datePicker = activeTextField.inputView as? UIDatePicker {
            if activeTextField.tag == 1 {
                checkStartDate(date: datePicker.date)
            }
            else {
                checkEndDate(date: datePicker.date)
            }
        }
        activeTextField.resignFirstResponder()
        
    }
    
    
    
    @objc func datePickerHandler(datePicker: UIDatePicker) {
        print(datePicker.date)
    }
  
    
    func checkStartDate(date: Date) {
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM/dd/yyyy"
        
        let calendar = Calendar.current
        let dateToday = Date()
        let currentDay = calendar.component(.day, from: dateToday)
        let currentMonth = calendar.component(.month, from: dateToday)
        let currentYear = calendar.component(.year, from: dateToday)
        
        let startDay = calendar.component(.day, from: date)
        let startMonth = calendar.component(.month, from: date)
        let startYear = calendar.component(.year, from: date)
        
        if startYear < currentYear {
            
            showAlert(title: "Alert", message: "Start date should be greater than current date")
        }
        
        else if startYear == currentYear {
            
            if startMonth < currentMonth {
                
                showAlert(title: "Alert", message: "Start date should be greater than current date")
            }
            
            else if startMonth >= currentMonth {
                
                if startDay < currentDay {
                    
                    showAlert(title: "Alert", message: "Start date should be greater than current date")
                }
                
                else {
                    activeTextField.text = dateFormat.string(from: date)
                    endDate.text = ""
                }
            }
        }
        
        else {
            activeTextField.text = dateFormat.string(from: date)
            endDate.text = ""
        }
    }
    
    func checkEndDate(date: Date) {
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM/dd/yyyy"
        
        if startDate.text == "" {
            showAlert(title: "Alert", message: "Please enter start date first")
        }
        else {
            let startDateCheck = dateFormat.date(from: startDate.text!)
            
            let calendar = Calendar.current
            
            let startDay = calendar.component(.day, from: startDateCheck!)
            let startMonth = calendar.component(.month, from: startDateCheck!)
            let startYear = calendar.component(.year, from: startDateCheck!)
            
            let endDay = calendar.component(.day, from: date)
            let endMonth = calendar.component(.month, from: date)
            let endYear = calendar.component(.year, from: date)
            
            if endYear < startYear {
                
                showAlert(title: "Alert", message: "")
            }
            
            else if endYear == startYear {
                
                if endMonth < startMonth {
                    
                    showAlert(title: "Alert", message: "End date should be greater than Start date")
                }
                
                else if endMonth == startMonth {
                    
                    if endDay < startDay {
                        
                        showAlert(title: "Alert", message: "End date should be greater than Start date")
                    }
                    
//                    else if endDay == startDay {
//                        showAlert(title: "Alert", message: "End date should be greater than Start date")
//
//                    }
                    
                    else {
                        activeTextField.text = dateFormat.string(from: date)
                    }
                }
                
                else {
                    activeTextField.text = dateFormat.string(from: date)
                }
            }
            else {
                activeTextField.text = dateFormat.string(from: date)
            }
        }
        
    }
    
    
    func createCustomTextField(textField: MDCOutlinedTextField) {
        
        textField.font = UIFont(name: "Manrope-SemiBold", size: 13.0)
        textField.setOutlineColor(.lightGray, for: .normal)
        textField.setOutlineColor(.lightGray, for: .editing)
        textField.setFloatingLabelColor(.black, for: .normal)
        textField.setFloatingLabelColor(.black, for: .editing)
        textField.setNormalLabelColor(.lightGray, for: .normal)
        textField.setNormalLabelColor(.lightGray, for: .editing)
    }
}


extension AddItemLevelCouponViewController : UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return variantArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "CreatBogoDealCell", for: indexPath) as! CreatBogoDealCell
        
        let variant = variantArray[indexPath.row]
        
        if variant.bogo.isvarient ==  "1" {
            
            let title = variant.bogo.title
            let variantName = variant.bogo.variant
            
            if let range = title.range(of: variantName) {
                
                let separatedTitle = title.replacingCharacters(in: range, with: "").trimmingCharacters(in: .whitespaces)
                cell.titleLbl.text = separatedTitle
            }
            cell.varientlbl.isHidden = false
            cell.priceLbl.text = "$\(variant.bogo.var_price)"
            cell.upclbl.text = variant.bogo.var_upc
            cell.varientlbl.text = variant.bogo.variant
        }
        else {
            
            cell.varientlbl.isHidden = true
            cell.titleLbl.text = variant.bogo.title
            cell.priceLbl.text = "$\(variant.bogo.price)"
            cell.upclbl.text = variant.bogo.upc
        }
        
        cell.closeBtn.tag = indexPath.row
        return cell
    }
}


extension AddItemLevelCouponViewController : SelectBogoDelegate {
    
    func addSelectedBogoVariants(arr: [VariantBogoModel]) {
        
        print(arr)
        variantArray = arr
        subvarArray = arr
        
        DispatchQueue.main.async {
            
            self.tableview.reloadData()
            self.tableHeight.constant = CGFloat(100 * self.variantArray.count)
            let table = self.tableHeight.constant
            
            self.scrollHeight.constant = table + 700
        }
        
    }
}


extension UIView {
    func applySideOnlyShadow(
        opacity: Float = 0.35,
        radius: CGFloat = 6,
        shadowSize: CGFloat = 6
    ) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor(red: 0x0A/255, green: 0x64/255, blue: 0xF9/255, alpha: 1).cgColor
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowOffset = .zero
        
    }
    
    func removeShadow() {
        layer.shadowOpacity = 0
        layer.shadowRadius = 0
        layer.shadowOffset = .zero
    }
}
