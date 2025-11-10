//
//  AddItemLevelCouponViewController.swift
//  QuickveeApp
//
//  Created by Pallavi on 24/10/25.
//

import UIKit

class AddItemLevelCouponViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var universalView: UIView!
    
    @IBOutlet weak var specificItemView: UIView!
    
    @IBOutlet weak var couponCodeTextfield: UITextField!
    
    @IBOutlet weak var descriptionText: UITextField!
    
    @IBOutlet weak var discountText: UITextField!
    
    
    @IBOutlet weak var percentBtn: UIButton!
   
    @IBOutlet weak var dollerBtn: UIButton!
   
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var addBtn: UIButton!
    
    @IBOutlet weak var universalLbl: UILabel!
    
    @IBOutlet weak var specificLbl: UILabel!
    
    @IBOutlet weak var startDate: UITextField!
    
    @IBOutlet weak var endDate: UITextField!
  
    @IBOutlet weak var addVariantBtn: UIButton!
   
    @IBOutlet weak var tableview: UITableView!
   
    @IBOutlet weak var scrollHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    var varient_List = [BogoVariantModel]()
    var variantArray = [VariantBogoModel]()
    var subvarArray =  [VariantBogoModel]()
    var selectedAllEditIds = [String]()
    
    var couponItemArray :Coupon?
   
    var activeTextField = UITextField()
    
    var itemsEditIds = ""
    var mode = ""
    var coupon_type = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableview.isHidden = true
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
        print("$$\(itemsEditIds)")
        
        if couponItemArray?.type == "2" {
            specificItemViewClick()
            variantListApi()
        }
        else {
            universalViewClick()
        }
    }
    
    func setUI(){
       
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
    }
    
    
    func setMode(){
        if mode == "edit" {
         
            if couponItemArray?.type == "1" {
                couponCodeTextfield.text = couponItemArray?.name
                descriptionText.text = couponItemArray?.description
                startDate.text = couponItemArray?.date_valid
                endDate.text = couponItemArray?.date_expire
                discountText.text = couponItemArray?.discount
            }
            else {
                couponCodeTextfield.text = couponItemArray?.name
                descriptionText.text = couponItemArray?.description
                startDate.text = couponItemArray?.date_valid
                endDate.text = couponItemArray?.date_expire
                discountText.text = couponItemArray?.discount
            }
            
        }
        else {
            
            
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
   
//    func validateData() {
//        
//        if variantArray.count == 0 {
//            ToastClass.sharedToast.showToast(message: "Please Select At least 1 Product Varient",
//                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
//        }
//        else {
//        
//            setDataMix()
//        }
//        
//    }
    
    func setDataMix() {
        
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
        
       
    }
    
    
    
    
    @objc func universalViewClick() {
        universalView.layer.borderWidth = 1
        universalView.layer.borderColor = UIColor(hexString: "#0A64F9").cgColor
        specificItemView.layer.borderWidth = 1
        specificItemView.layer.borderColor = UIColor(hexString: "#ECEFF3").cgColor
        universalLbl.textColor = UIColor(hexString: "#0A64F9")
        specificLbl.textColor = UIColor.black
        tableview.isHidden = true
        
    }
    
    @objc func specificItemViewClick() {
        specificItemView.layer.borderWidth = 1
        specificItemView.layer.borderColor = UIColor(hexString: "#0A64F9").cgColor
        universalView.layer.borderWidth = 1
        universalView.layer.borderColor = UIColor(hexString: "#ECEFF3").cgColor
        specificLbl.textColor = UIColor(hexString: "#0A64F9")
        universalLbl.textColor = UIColor.black
        tableview.isHidden = false
        variantListApi()
    }
    
    @IBAction func backBtnClick(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func percentBtnClick(_ sender: UIButton) {
  
        percentBtn.backgroundColor = UIColor.init(hexString: "#0A64F9")
        dollerBtn.backgroundColor = UIColor.init(hexString: "#EEEEEE")
        percentBtn.setImage(UIImage(named: "PerwhiteIcon"), for: .normal)
        dollerBtn.setImage(UIImage(named: "dollerGrey"), for: .normal)
    }
    
    
    @IBAction func dollerBtnClick(_ sender: UIButton) {
        dollerBtn.backgroundColor = UIColor.init(hexString: "#0A64F9")
        percentBtn.backgroundColor = UIColor.init(hexString: "#EEEEEE")
        percentBtn.setImage(UIImage(named: "PercentSymbol"), for: .normal)
        dollerBtn.setImage(UIImage(named: "dolllerSym"), for: .normal)
    }
    
    
    @IBAction func cancelBtnClick(_ sender: UIButton) {
        
    }
    
    @IBAction func addBtnClick(_ sender: UIButton) {
       // validateData()
    }
    
    @IBAction func closeBtnClick(_ sender: UIButton) {
        
    }
    
    @IBAction func addVariantBtnClick(_ sender: UIButton) {
     
//        guard let disc = discountText.text, disc != "", disc != "0.00" else {
//            ToastClass.sharedToast.showToast(message: "Enter Amount",
//                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
//            discountText.isError(numberOfShakes: 3, revert: true)
//            return
//        }
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "selectBogoVariant") as! SelectBogoVariantViewController
        
        vc.mode_Type = "coupon"
        vc.adddelegate = self
        
        //vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: {
            vc.presentationController?.presentedView?.gestureRecognizers?[0].isEnabled = false
        })
        
       
        
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
       
            getEditItemsIds()
            getEditVarients(list: varient_List)
       
    }
    
    
    func getEditItemsIds() {
        
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
           // self.viewsview.isHidden = false
           // self.indicator.isAnimating = false
            self.tableview.reloadData()
            self.tableHeight.constant = CGFloat(100 * self.variantArray.count)
            let table = self.tableHeight.constant
            
            self.scrollHeight.constant = table + 700
        }
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
        print("@@\(variantArray)")
        
        subvarArray = arr
        
        DispatchQueue.main.async {
              
                self.tableview.reloadData()
            }
        
    }
}
