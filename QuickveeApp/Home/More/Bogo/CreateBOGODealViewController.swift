//
//  CreateBOGODealViewController.swift
//
//
//  Created by Pallavi on 28/01/25.
//

import UIKit
import MaterialComponents

protocol AddBogoDelegate: AnyObject {
    
    func setSelectedBogoVarient(mix: [VariantBogoModel])
}

protocol AddScheduleDelegate: AnyObject {
    
    func setScheduleData(data: AddSchedule)
}

protocol AddBogoStoresDelegate: AnyObject {
    
    func setSelectedStores(reverseStores: [Store])
}

class CreateBOGODealViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var topView: UIView!
   
    
    @IBOutlet weak var dealNameTextfield: MDCOutlinedTextField!
    @IBOutlet weak var describeDealTextfield: UITextField!
    @IBOutlet weak var qtyTextfield: MDCOutlinedTextField!
    @IBOutlet weak var discountQtyTextfield: MDCOutlinedTextField!
    @IBOutlet weak var discountperItemTextfield: MDCOutlinedTextField!
   
    
    @IBOutlet weak var AddVarientBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var percentBtn: UIButton!
    @IBOutlet weak var dollerBtn: UIButton!
    
    @IBOutlet weak var addScheduleLbl: UILabel!
    @IBOutlet weak var activeLbl: UILabel!
    @IBOutlet weak var repeatLbl: UILabel!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var collection: UICollectionView!
    
    @IBOutlet weak var collHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var createTitle: UILabel!
    
    @IBOutlet weak var viewsview: UIView!
    @IBOutlet weak var storeView: UIView!
    @IBOutlet weak var btnView: UIView!
    
    @IBOutlet weak var copyLbl: UILabel!
    @IBOutlet weak var copyTop: NSLayoutConstraint!
    @IBOutlet weak var copyBtm: NSLayoutConstraint!
    @IBOutlet weak var collBottom: NSLayoutConstraint!
    private var isSymbolOnRight = false
    
    var mode = ""
    var discount_type = ""
    var dollarAmt = ""
    var bogo_id = ""
    var schedule_exist = false
    
    var searching = false
    var bogoObj : BogoModel?
    
    var bogo_mix_exist_ids = [String]()
    var itemsEditIds = ""
    
    var variantArray = [VariantBogoModel]()
    var subvarArray =  [VariantBogoModel]()
    var searchVarArray = [VariantBogoModel]()
    
    var varient_List = [BogoVariantModel]()
    
    var collBts = [Store]()
    
    var activeTextField = UITextField()
    var selectedAllEditIds = [String]()
    
    var scheduleData: AddSchedule?
    
    let loadIndicator: ProgressView = {
        
        let progress = ProgressView(colors: [.white], lineWidth: 3)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    
    let indicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 3)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topView.addBottomShadow()
        tableView.delegate = self
        tableView.dataSource = self
        
        setupUI()
        
        searchBar.isHidden = true
        
        if mode == "add" {
            addScheduleLbl.text = "Add Schedule +"
            activeLbl.text = "No Schedule Set"
            repeatLbl.text = ""
            
            if UserDefaults.standard.bool(forKey: "multi_store_access") {
                copyLbl.text = "Copy to Stores"
                copyLbl.isHidden = false
                copyTop.constant = 10
                copyBtm.constant = 10
                collBottom.constant = 10
                collection.isHidden = false
                collHeight.constant = 50
            }
            else {
                copyLbl.text = ""
                copyLbl.isHidden = true
                copyTop.constant = 0
                copyBtm.constant = 0
                collBottom.constant = 0
                collection.isHidden = true
                collHeight.constant = 0
            }
        }
        else {
            var sdate = ToastClass.sharedToast.setCouponsDateFormat(dateStr: bogoObj?.start_date ?? "")
            let edate = ToastClass.sharedToast.setCouponsDateFormat(dateStr: bogoObj?.end_date ?? "")
            
            let st = bogoObj?.start_time ?? ""
            let et = bogoObj?.end_time ?? ""
            
            var stime = ""
            var etime = ""
            
            if st != "" {
                let df1 = DateFormatter()
                df1.dateFormat = "HH:mm:ss"
                df1.locale = Locale(identifier: "en_GB")
                
                if let start = df1.date(from: st),
                   let end = df1.date(from: et) {
                 
                    let df2 = DateFormatter()
                    df2.dateFormat = "hh:mm a"
                    df2.locale = Locale(identifier: "en_US")
                    
                    stime = df2.string(from: start)
                    etime = df2.string(from: end)
                }
                else {
                    stime = ""
                    etime = ""
                }
            }
            else {
                stime = ""
                etime = ""
            }
            
            let wdays = bogoObj?.weekly_days ?? ""
            
            if bogoObj?.start_date == "0000-00-00" {
                addScheduleLbl.text = "Manage Schedule +"
                
                let date = Date()
                let dateFormat = DateFormatter()
                dateFormat.timeZone = TimeZone(secondsFromGMT: 0)
                dateFormat.dateFormat = "MM/dd/yyyy"
                
                sdate = dateFormat.string(from: date)
                activeLbl.text = "The Deal Will Starting From \(sdate)"
                repeatLbl.text = ""
            }
            else if bogoObj?.end_date == "0000-00-00" {
                addScheduleLbl.text = "Manage Schedule +"
                
                if bogoObj?.start_time == "00:00:00" {
                    
                    if bogoObj?.end_time == "00:00:00" {
                        activeLbl.text = "The Deal Will Starting From \(sdate)"
                    }
                    else {
                        activeLbl.text = "The Deal Will Be Active From \(stime) To \(etime) Starting From \(sdate)"
                    }
                }
                else {
                    activeLbl.text = "The Deal Will Be Active From \(stime) To \(etime) Starting From \(sdate)"
                }
            }
            else {
                addScheduleLbl.text = "Manage Schedule +"
                
                if bogoObj?.start_time == "00:00:00" {
                    
                    if bogoObj?.end_time == "00:00:00" {
                        activeLbl.text = "The Deal Will Starting From \(sdate) Till \(edate)"
                    }
                    else {
                        activeLbl.text = "The Deal Will Be Active From \(stime) To \(etime) Starting From \(sdate) Till \(edate)"
                    }
                }
                else {
                    activeLbl.text = "The Deal Will Be Active From \(stime) To \(etime) Starting From \(sdate) Till \(edate)"
                }
            }
            
            if bogoObj?.weekly_days == "" || bogoObj?.weekly_days == "<null>"  {
                repeatLbl.text = ""
            }
            else {
                repeatLbl.text = "Repeats On (Weekly) \(wdays)"
            }
            
            copyLbl.text = ""
            copyLbl.isHidden = true
            copyTop.constant = 0
            copyBtm.constant = 0
            collBottom.constant = 0
            collection.isHidden = true
            collHeight.constant = 0
        }
        
        collection.layer.borderColor = UIColor(named: "borderColor")?.cgColor
        collection.layer.borderWidth = 1.0
        collection.layer.cornerRadius = 5.0
        
        let colLay = CustomFlowLayout()
        collection.collectionViewLayout = colLay
        colLay.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let its_tap = UITapGestureRecognizer(target: self, action: #selector(openBtsScreen))
        collection.addGestureRecognizer(its_tap)
        its_tap.numberOfTapsRequired = 1
        collection.isUserInteractionEnabled = true
        
        tableView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        collection.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)

        
        let scheduleGest = UITapGestureRecognizer(target: self, action: #selector(addScheduleBtnClick))
        addScheduleLbl.isUserInteractionEnabled = true
        scheduleGest.numberOfTapsRequired = 1
        addScheduleLbl.addGestureRecognizer(scheduleGest)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUI()
        setMode()
        subvarArray = []
        
    }
    
    func setMode() {
        
        if mode == "add" {
            createTitle.text = "Create BOGO Deal"
            doneBtn.setTitle("Done", for: .normal)
            
            discount_type = "2"
            
            dollerBtn.backgroundColor = UIColor.init(hexString: "#0A64F9")
            percentBtn.backgroundColor = UIColor.init(hexString: "#EEEEEE")
            
            dollerBtn.setImage(UIImage(named: "dolllerSym"), for: .normal)
            percentBtn.setImage(UIImage(named: "PercentSymbol"), for: .normal)
            
            discountperItemTextfield.label.text = "Discount Per Item ($)"
        }
        else {
            
            createTitle.text = "Edit BOGO Deal"
            doneBtn.setTitle("Update", for: .normal)
            cancelBtn.setTitle("Delete", for: .normal)
            cancelBtn.tintColor = .red
            cancelBtn.layer.borderWidth = 1
            cancelBtn.layer.borderColor = UIColor.red.cgColor
            
            dealNameTextfield.text = bogoObj?.deal_name
            describeDealTextfield.text = bogoObj?.desc
            discountperItemTextfield.text = bogoObj?.discount
            discount_type = bogoObj?.discount_type ?? ""
            itemsEditIds = bogoObj?.items ?? ""
            bogo_id = bogoObj?.id ?? ""
            
            if discount_type == "2" {
                percentBtn.backgroundColor = UIColor.init(hexString: "#EEEEEE")
                dollerBtn.backgroundColor = UIColor.init(hexString: "#0A64F9")
                dollerBtn.setImage(UIImage(named: "dolllerSym"), for: .normal)
                percentBtn.setImage(UIImage(named: "PercentSymbol"), for: .normal)
                
                dollarAmt = discountperItemTextfield.text ?? ""
            }
            else {
                dollerBtn.backgroundColor = UIColor.init(hexString: "#EEEEEE")
                percentBtn.backgroundColor = UIColor.init(hexString: "#0A64F9")
                percentBtn.setImage(UIImage(named: "PerwhiteIcon"), for: .normal)
                dollerBtn.setImage(UIImage(named: "dollerGrey"), for: .normal)
                dollarAmt = ""
            }
            
            let buy_qty = bogoObj?.buy_qty
            let free_qty = bogoObj?.free_qty
            qtyTextfield.text = buy_qty
            discountQtyTextfield.text = free_qty
            
            if scheduleData == nil {
                scheduleData = AddSchedule(start_date: bogoObj?.start_date ?? "", end_date: bogoObj?.end_date ?? "",
                                           no_end_date: bogoObj?.no_end_date ?? "",
                                           full_day: bogoObj?.full_day ?? "", start_time: bogoObj?.start_time ?? "",
                                           end_time: bogoObj?.end_time ?? "", repeat_type: bogoObj?.repeat_type ?? "",
                                           weekly_days: bogoObj?.weekly_days ?? "", monthly_days: bogoObj?.monthly_dates ?? "")
                
                viewsview.isHidden = true
                indicator.isAnimating = true
                variantListApi()
            }
        }
    }
    
    
    func setUI() {
        
        createCustomTextField(textField: dealNameTextfield)
        createCustomTextField(textField: describeDealTextfield)
        createCustomTextField(textField: qtyTextfield)
        createCustomTextField(textField: discountQtyTextfield)
        createCustomTextField(textField: discountperItemTextfield)
//        createCustomTextField(textField: startDate)
//        createCustomTextField(textField: endDate)
        
        dealNameTextfield.label.text = "Name of Deal"
        qtyTextfield.label.text = "Quantity"
        discountQtyTextfield.label.text = " Quantity"
        discountperItemTextfield.label.text = "Discount Per Item"
//        startDate.label.text = "Start Date"
//        endDate.label.text = "End Date"
//                
//        startDate.delegate = self
//        endDate.delegate = self
        discountperItemTextfield.delegate = self
        qtyTextfield.delegate = self
        discountQtyTextfield.delegate = self
        
        qtyTextfield.keyboardType = .numberPad
        discountQtyTextfield.keyboardType = .numberPad
        discountperItemTextfield.keyboardType = .numberPad
        
        AddVarientBtn.layer.cornerRadius = 10
        cancelBtn.layer.cornerRadius = 5
        doneBtn.layer.cornerRadius = 5
        cancelBtn.layer.borderWidth = 1
        cancelBtn.layer.borderColor = UIColor.black.cgColor
        percentBtn.layer.cornerRadius = 5
        dollerBtn.layer.cornerRadius = 5
        
        describeDealTextfield.isUserInteractionEnabled = false
        
        discountperItemTextfield.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        qtyTextfield.addTarget(self, action: #selector(updateText), for: .editingChanged)
        discountQtyTextfield.addTarget(self, action: #selector(updateText), for: .editingChanged)
    }
    
    @objc func openBtsScreen() {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "filtercategory") as! FilterCategoryViewController
        
        vc.delegateBogoStores = self
        vc.catMode = "bogoStores"
        vc.selectIts = collBts
        vc.apiMode = "bts"
        present(vc, animated: true, completion: {
            vc.presentationController?.presentedView?.gestureRecognizers?[0].isEnabled = false
        })
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
    
    func validateData() {
        
        guard let name = dealNameTextfield.text, name != "" else {
            
            ToastClass.sharedToast.showToast(message: "Enter Deal name",
                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            dealNameTextfield.isError(numberOfShakes: 3, revert: true)
            return
        }
        
        guard let qty = qtyTextfield.text, qty != "", qty != "0" else {
            
            ToastClass.sharedToast.showToast(message: "Enter Quantity",
                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            qtyTextfield.isError(numberOfShakes: 3, revert: true)
            return
        }
        
        
        guard let freeQty = discountQtyTextfield.text, freeQty != "", freeQty != "0" else {
            
            ToastClass.sharedToast.showToast(message: "Enter Quantity",
                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            discountQtyTextfield.isError(numberOfShakes: 3, revert: true)
            return
        }
        
        let bqty = Int(qtyTextfield.text ?? "0") ?? 0
        let fqty = Int(discountQtyTextfield.text ?? "0") ?? 0
        
        
        guard bqty > fqty else {
            
            ToastClass.sharedToast.showToast(message: "Free Quantity must be less than Buy Quantity",
                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            discountQtyTextfield.isError(numberOfShakes: 3, revert: true)
            return
        }
        
        guard let disc = discountperItemTextfield.text, disc != "", disc != "0.00" else {
            ToastClass.sharedToast.showToast(message: "Enter Valid Discount Price",
                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            discountperItemTextfield.isError(numberOfShakes: 3, revert: true)
            return
        }
        
        if variantArray.count == 0 {
            ToastClass.sharedToast.showToast(message: "Please Select At least 1 Product Varient",
                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
        }
        else {
            guard let name = describeDealTextfield.text, name != "" else {
                return
            }
            setDataMix()
        }
    }
    
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
        
        addBogoApiCall(items_id: emp)
    }
    
    func addBogoApiCall(items_id: String) {
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        var stores = ""
        var storearr = [String]()
        if mode == "add" {
            
            for store in collBts {
                storearr.append(store.merchant_id)
            }
            stores = storearr.joined(separator: ",")
        }
        else {
            stores = ""
        }
        
        let d_name = dealNameTextfield.text ?? ""
        let price = discountperItemTextfield.text ?? ""
        let buy_qty = qtyTextfield.text ?? ""
        let Free_qty = discountQtyTextfield.text ?? ""
        let desc = describeDealTextfield.text ?? ""
        
        var sd = scheduleData?.start_date ?? ""
        let ed = scheduleData?.end_date ?? ""
        
        var change_start_date = ""
        var change_end_date = ""
        
        var startTime = ""
        var endTime = ""
        
        if sd == "" {
            
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            
            sd = dateFormatter.string(from: date)
            
            change_start_date = ToastClass.sharedToast.setCouponlistDate(dateStr: sd)
        }
        
        else {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            
            if let start = dateFormatter.date(from: sd) {
                
                let startString = dateFormatter.string(from: start)
                change_start_date = ToastClass.sharedToast.setCouponlistDate(dateStr: startString)
                
                if let end = dateFormatter.date(from: ed) {
                    
                    let endString = dateFormatter.string(from: end)
                    change_end_date = ToastClass.sharedToast.setCouponlistDate(dateStr: endString)
                }
                else {
                    change_end_date = ""
                }
            }
            
            else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                if let start = dateFormatter.date(from: sd) {
                    
                    change_start_date = dateFormatter.string(from: start)
                    if let end = dateFormatter.date(from: ed) {
                        
                        change_end_date = dateFormatter.string(from: end)
                    }
                    else {
                        change_end_date = ""
                    }
                }
            }
            
            let st = scheduleData?.start_time ?? ""
            let et = scheduleData?.end_time ?? ""
            
            if st != "" {
                let df1 = DateFormatter()
                df1.dateFormat = "hh:mm a"
                df1.locale = Locale(identifier: "en_US")
                
                if let start = df1.date(from: st),
                   let end = df1.date(from: et) {
                    let df2 = DateFormatter()
                    df2.dateFormat = "HH:mm"
                    df2.locale = Locale(identifier: "en_GB")
                    
                    startTime = df2.string(from: start)
                    endTime = df2.string(from: end)
                }
                else {
                    
                    let df1 = DateFormatter()
                    df1.dateFormat = "HH:mm:ss"
                    df1.locale = Locale(identifier: "en_GB")
                    
                    if let start = df1.date(from: st),
                       let end = df1.date(from: et) {
                        let df2 = DateFormatter()
                        df2.dateFormat = "HH:mm"
                        df2.locale = Locale(identifier: "en_GB")
                        
                        startTime = df2.string(from: start)
                        endTime = df2.string(from: end)
                    }
                    else {
                        startTime = ""
                        endTime = ""
                    }
                }
            }
            else {
                startTime = ""
                endTime = ""
            }
        }
        
        var full = scheduleData?.full_day ?? ""
        var ned = scheduleData?.no_end_date ?? ""
        var no_repeat = scheduleData?.repeat_type ?? ""
        
        if full == "" {
            full = "1"
        }
        
        if ned == "" {
            ned = "1"
        }
        
        if no_repeat == "" {
            no_repeat = "1"
        }
        
        let week = scheduleData?.weekly_days ?? ""
        
        loadIndicator.isAnimating = true
        
        ApiCalls.sharedCall.addBogoApiCall(merchant_id: id, deal_name: d_name,
                                           description: desc, no_end_date: ned,
                                           use_with_coupon: "1", buy_qty: buy_qty,
                                           free_qty: Free_qty, discount: price,
                                           discount_type: discount_type, items: items_id,
                                           start_date: change_start_date, end_date: change_end_date,
                                           full_day: full, start_time: startTime,
                                           end_time: endTime, repeat_type: no_repeat,
                                           weekly_days: week, monthly_dates: "",
                                           id: bogo_id, stores: stores) { isSuccess, responseData in
            
            if isSuccess {
                
                let msg = responseData["msg"] as? String ?? ""
                
                self.loadIndicator.isAnimating = false
                ToastClass.sharedToast.showToast(message: msg,
                                                 font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                
                if msg == "BOGO deal added successfully." || msg == "BOGO deal updated successfully." {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            else {
                print("Api Error")
            }
        }
    }
    
    func deletAPiCall() {
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        ApiCalls.sharedCall.deletebogoApiCall(merchant_id: id, bogo_id: bogo_id) { isSuccess, responceData in
            
            if isSuccess {
                
                let list = responceData["msg"] as! String
                                
                ToastClass.sharedToast.showToast(message: list, font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                
                self.loadingIndicator.isAnimating = false
                
                self.navigationController?.popViewController(animated: true)
                
                
            }
            else {
                print("API error")
                self.loadingIndicator.isAnimating = false
            }
        }
    }
    
    
    @objc func checkStartDateValid() {
        showAlert(title: "Alert", message: "Please enter a valid start date")
    }
    
    @IBAction func backBtnClick(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func cancelBtnClick(_ sender: UIButton) {
        
        if cancelBtn.currentTitle == "Delete" {
            
            if UserDefaults.standard.bool(forKey: "delete_bogo") {
                ToastClass.sharedToast.showToast(message: "Access Denied",
                                                 font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            }
            else {
                
                let alertController = UIAlertController(title: "Alert", message: "Are you sure you want to delete this deal?", preferredStyle: .alert)
                
                let cancel = UIAlertAction(title: "No", style: .default) { (action:UIAlertAction!) in
                }
                let okAction = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction!) in
                    
                    self.deletAPiCall()
                }
                
                alertController.addAction(cancel)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion:nil)
            }
        }
        else {
            
            let viewcontrollerArray = self.navigationController?.viewControllers
            var destiny = 4
            
            if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is BogoListViewController }) {
                destiny = destinationIndex
            }
            
            self.navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
            
        }
    }
    
    @IBAction func doneBtnClick(_ sender: UIButton) {
        validateData()
    }
 
    @objc func addScheduleBtnClick() {
        
        if addScheduleLbl.text == "Add Schedule +" {
            schedule_exist = false
        }
        else {
            schedule_exist = true
        }
        performSegue(withIdentifier: "toAddSchedule", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination as! AddScheduleViewController
        vc.delegate = self
        if schedule_exist {
            vc.schedule = scheduleData
        }
        else {
            vc.schedule = nil
        }
        vc.exist = schedule_exist
    }
    
  
    @IBAction func homeBtnClick(_ sender: UIButton) {
        
        let viewcontrollerArray = navigationController?.viewControllers
        var destiny = 0
        if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is HomeViewController }) {
            destiny = destinationIndex
        }
        navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
    }
    
    @IBAction func noEndDateSwitch(_ sender: UISwitch) {
        
        if sender.isOn {
            
            sender.thumbTintColor = .systemBlue
        }
        else {
          
            sender.thumbTintColor = .white
        }
        
    }
    
    
    @IBAction func btsCloseBtnClick(_ sender: UIButton) {
        
        collBts.remove(at: sender.tag)
        collection.reloadData()
    }
    
    @IBAction func closeBtnClick(_ sender: UIButton) {
        
        let index = sender.tag
        if searching {
            
            let arr = searchVarArray[index]
            removeVarient(arr: arr, index: index)
        }
        else {
            let arr = variantArray[sender.tag]
            removeVarient(arr: arr, index: index)
            if variantArray.count == 0 {
                searchBar.isHidden = true
            }
        }
    }
    
    @IBAction func percentBtnClick(_ sender: UIButton) {
        
        percentBtn.backgroundColor = UIColor.init(hexString: "#0A64F9")
        dollerBtn.backgroundColor = UIColor.init(hexString: "#EEEEEE")
        percentBtn.setImage(UIImage(named: "PerwhiteIcon"), for: .normal)
        dollerBtn.setImage(UIImage(named: "dollerGrey"), for: .normal)
        discountperItemTextfield.text = ""
        discountperItemTextfield.label.text = "Discount Per Item (%)"
        discount_type = "1"
        dollarAmt = ""
    }
    
    @IBAction func dollerBtnClick(_ sender: UIButton) {
          
        percentBtn.backgroundColor = UIColor.init(hexString: "#EEEEEE")
        dollerBtn.backgroundColor = UIColor.init(hexString: "#0A64F9")
        dollerBtn.setImage(UIImage(named: "dolllerSym"), for: .normal)
        percentBtn.setImage(UIImage(named: "PercentSymbol"), for: .normal)
        discountperItemTextfield.text = ""
        discountperItemTextfield.label.text = "Discount Per Item ($)"
        discount_type = "2"
        
    }
    
    
    @IBAction func AddVarientBtnClick(_ sender: UIButton) {
        
        print(bogo_mix_exist_ids)
        guard let disc = discountperItemTextfield.text, disc != "", disc != "0.00" else {
            ToastClass.sharedToast.showToast(message: "Enter Amount",
                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            discountperItemTextfield.isError(numberOfShakes: 3, revert: true)
            return
        }
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "selectBogoVariant") as! SelectBogoVariantViewController
        
        vc.mode = mode
        vc.bogo_mix_exist_ids = bogo_mix_exist_ids
        print(dollarAmt)
        vc.disc_amt = dollarAmt
        vc.bogoSelectedVariants = variantArray
        vc.adddelegate = self
        
        present(vc, animated: true, completion: {
            vc.presentationController?.presentedView?.gestureRecognizers?[0].isEnabled = false
        })
    }
    
    func checkPrice(varamt: String, textAmt: String) -> Bool {
        
        let v_amt = Double(varamt) ?? 0.00
        let textAmt = Double(textAmt) ?? 0.00
        
        if v_amt > textAmt {
            return false
        }
        return true
    }
    
    func roundOf(item : String) -> Double {
        
        let refund = item
        let doub = Double(refund) ?? 0.00
        let div = (100 * doub) / 100
        
        return div
        
    }
    
    func calculateQty(qty: String, freeQty: String) -> String {
        
        let buyQty = Int(qty) ?? 0
        let freeqty = Int(freeQty) ?? 0
        
        
        let finalqty = buyQty - freeqty
        
        return String(finalqty)
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
    
    func showAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
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
        
        if variantArray.count == 0 {
            searchBar.isHidden = true
        }
        else {
            searchBar.isHidden = false
        }
        DispatchQueue.main.async {
            self.viewsview.isHidden = false
            self.indicator.isAnimating = false
            self.tableView.reloadData()
        }
    }
    
    func removeVarient(arr: VariantBogoModel, index: Int) {
        
        if searching {
            
            searchVarArray.remove(at: index)
            
            if arr.bogo.isvarient == "1" {
                subvarArray.removeAll(where: {$0.bogo.var_id == arr.bogo.var_id})
                variantArray.removeAll(where: {$0.bogo.var_id == arr.bogo.var_id})
                bogo_mix_exist_ids.removeAll(where: {$0 == arr.bogo.var_id})
            }
            else {
                subvarArray.removeAll(where: {$0.bogo.product_id == arr.bogo.product_id})
                variantArray.removeAll(where: {$0.bogo.product_id == arr.bogo.product_id})
                bogo_mix_exist_ids.removeAll(where: {$0 == arr.bogo.product_id})
            }
        }
        
        else {
            variantArray.remove(at: index)
            if arr.bogo.isvarient == "1" {
                subvarArray.removeAll(where: {$0.bogo.var_id == arr.bogo.var_id})
                bogo_mix_exist_ids.removeAll(where: {$0 == arr.bogo.product_id})
            }
            else {
                subvarArray.removeAll(where: {$0.bogo.product_id == arr.bogo.product_id})
                bogo_mix_exist_ids.removeAll(where: {$0 == arr.bogo.product_id})
            }
        }
        tableView.reloadData()
    }
    
    func performSearch(searchText: String) {
        
        if searchText == "" {
            searching = false
        }
        
        else {
            searching = true
            searchVarArray = subvarArray.filter{ $0.bogo.title.lowercased().contains(searchText.lowercased())
                ||  $0.bogo.var_upc.lowercased().contains(searchText.lowercased())
                ||  $0.bogo.upc.lowercased().contains(searchText.lowercased())
                ||  $0.bogo.custom_code.lowercased().contains(searchText.lowercased())
            }
        }
        tableView.reloadData()
    }
    
    func createCustomTextField(textField: MDCOutlinedTextField) {
        
        textField.font = UIFont(name: "Manrope-Bold", size: 12.0)
        textField.setOutlineColor(.lightGray, for: .normal)
        textField.setOutlineColor(.lightGray, for: .editing)
        textField.setNormalLabelColor(.lightGray, for: .normal)
        textField.setNormalLabelColor(.lightGray, for: .editing)
        textField.setOutlineColor(UIColor(named: "borderColor")!, for: .normal)
        textField.setOutlineColor(UIColor(named: "borderColor")!, for: .editing)
        textField.setFloatingLabelColor(UIColor(named: "Attributeclr")!, for: .normal)
        textField.setFloatingLabelColor(UIColor(named: "Attributeclr")!, for: .editing)
    }
    
    func createCustomTextField(textField: UITextField) {
        
        textField.font = UIFont(name: "Manrope-Bold", size: 12.0)
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor(named: "borderColor")?.cgColor
        textField.layer.borderWidth = 1.0
    }
    
    private func setupUI() {
        
        cancelBtn.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor
                .constraint(equalTo: cancelBtn.centerXAnchor, constant: 40),
            loadingIndicator.centerYAnchor
                .constraint(equalTo: cancelBtn.centerYAnchor),
            loadingIndicator.widthAnchor
                .constraint(equalToConstant: 15),
            loadingIndicator.heightAnchor
                .constraint(equalTo: self.loadingIndicator.widthAnchor)
        ])
        
        doneBtn.addSubview(loadIndicator)
        
        NSLayoutConstraint.activate([
            loadIndicator.centerXAnchor
                .constraint(equalTo: doneBtn.centerXAnchor, constant: 45),
            loadIndicator.centerYAnchor
                .constraint(equalTo: doneBtn.centerYAnchor),
            loadIndicator.widthAnchor
                .constraint(equalToConstant: 15),
            loadIndicator.heightAnchor
                .constraint(equalTo: self.loadIndicator.widthAnchor)
        ])
        
        
        view.addSubview(indicator)
        
        NSLayoutConstraint.activate([
            indicator.centerXAnchor
                .constraint(equalTo: view.centerXAnchor),
            indicator.centerYAnchor
                .constraint(equalTo: view.centerYAnchor),
            indicator.widthAnchor
                .constraint(equalToConstant: 40),
            indicator.heightAnchor
                .constraint(equalTo: self.indicator.widthAnchor)
        ])
 
    }
    
}

extension CreateBOGODealViewController: AddScheduleDelegate {
    
    func setScheduleData(data: AddSchedule) {
        scheduleData = data
        
        if scheduleData?.start_date == "" || scheduleData?.start_date == "0000-00-00" {
            addScheduleLbl.text = "Add Schedule +"
            activeLbl.text = "No Schedule Set"
            repeatLbl.text = ""
        }
        else if scheduleData?.end_date == "" || scheduleData?.end_date == "0000-00-00" {
            addScheduleLbl.text = "Manage Schedule +"
            
            if scheduleData?.start_time == "" || scheduleData?.start_time == "00:00:00" {
                activeLbl.text = "The Deal Will Active From \(data.start_date)"
            }
            else {
                activeLbl.text = "The Deal Will Be Active From \(data.start_time) To \(data.end_time) Starting From \(data.start_date)"
            }
        }
        else {
            addScheduleLbl.text = "Manage Schedule +"
            
            if scheduleData?.start_time == "" || scheduleData?.start_time == "00:00:00" {
                activeLbl.text = "The Deal Will Be Active From \(data.start_date) Till \(data.end_date)"
            }
            else {
                activeLbl.text = "The Deal Will Be Active From \(data.start_time) To \(data.end_time) Starting From \(data.start_date) Till \(data.end_date)"
            }
        }
        
        if data.weekly_days == "" || bogoObj?.weekly_days == "<null>" {
            repeatLbl.text = ""
        }
        else {
            repeatLbl.text = "Repeats On (Weekly) \(data.weekly_days)"
        }
    }
}

extension CreateBOGODealViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        performSearch(searchText: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searching = false
        performSearch(searchText: "")
    }
}

extension CreateBOGODealViewController {
    
    
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
        
        if Double(cleanedAmount) ?? 0 > 99999999 {
            cleanedAmount = String(cleanedAmount.dropLast())
        }
        
        if discount_type == "2" {
            if Double(cleanedAmount) ?? 00000 > 99999999 {
                cleanedAmount = String(cleanedAmount.dropLast())
            }
        }
        else {
            if Double(cleanedAmount) ?? 0.00 > 10000 {
                cleanedAmount = String(cleanedAmount.dropLast())
            }
        }
        
        let amount = Double(cleanedAmount) ?? 0.0
        let amountAsDouble = (amount / 100.0)
        var amountAsString = String(amountAsDouble)
        if cleanedAmount.last == "0" {
            amountAsString.append("0")
        }
        textField.text = amountAsString
        
//        let qty = Int(qtyTextfield.text ?? "0") ?? 0
//        let freeQty = Int(discountQtyTextfield.text ?? "0") ?? 0
//        
//        let discount = Double(discountperItemTextfield.text ?? "0") ?? 0.00
//        
//        let buyQty = qty - freeQty
//        
//        let discountType = percentBtn.backgroundColor == UIColor.init(hexString: "#0A64F9") ? "%" : "$"
//        
//        let formattedDiscount = String(format: "%.2f", discount)
        
//        if textField == discountperItemTextfield {
//              if discount_type == "2" {
//                dollarAmt = formattedDiscount
//                getlessAmtVarient()
//              }
//              else {
//                dollarAmt = ""
//              }
//            }
//            else if textField == discountQtyTextfield {
//              guard qty > freeQty else {
//                ToastClass.sharedToast.showToast(message: "Free Quantity must be less than Buy Quantity",
//                                 font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
//                discountQtyTextfield.isError(numberOfShakes: 3, revert: true)
//                return
//              }
//            }
        
        if textField.text == "000" {
            textField.text = ""
            
        }
    }
    
    @objc func updateText(textField: MDCOutlinedTextField) {
        
        var updatetext = textField.text ?? ""
        
        if textField == qtyTextfield  {
            if updatetext.count > 6 {
                updatetext = String(updatetext.dropLast())
            }
            
        }
        else if textField == discountQtyTextfield  {
            if updatetext.count > 6 {
                updatetext = String(updatetext.dropLast())
            }
            
        }
        
        activeTextField.text = updatetext
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        tableView.layer.removeAllAnimations()
        tableHeight.constant = tableView.contentSize.height
        if mode == "add" {
            if collection.collectionViewLayout.collectionViewContentSize.height <= 50 {
                collHeight.constant = 50
            }
            else {
                collHeight.constant = collection.collectionViewLayout.collectionViewContentSize.height
            }
            if UserDefaults.standard.bool(forKey: "multi_store_access") {
                scrollHeight.constant = viewsview.bounds.size.height + collHeight.constant + btnView.bounds.size.height + tableHeight.constant + 100
            }
            else {
                collHeight.constant = 0
                scrollHeight.constant = viewsview.bounds.size.height + collHeight.constant + btnView.bounds.size.height + tableHeight.constant + 50
            }
        }
        else {
            collHeight.constant = 0
            scrollHeight.constant = viewsview.bounds.size.height + collHeight.constant + btnView.bounds.size.height + tableHeight.constant + 50
        }
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
        }
    }
    
    func getlessAmtVarient() {
        
        var small = [VariantBogoModel]()
        
        let amt = discountperItemTextfield.text ?? ""
        
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
        tableView.reloadData()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        
        if activeTextField == discountperItemTextfield {
            activeTextField = textField
        }
        else if activeTextField == qtyTextfield {
            activeTextField = textField
        }
        else if activeTextField == discountQtyTextfield {
            activeTextField = textField
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let qty = Int(qtyTextfield.text ?? "0") ?? 0
        let freeQty = Int(discountQtyTextfield.text ?? "0") ?? 0
        
        let discount = Double(discountperItemTextfield.text ?? "0") ?? 0.00
        
        let buyQty = qty - freeQty
        
        let discountType = percentBtn.backgroundColor == UIColor.init(hexString: "#0A64F9") ? "%" : "$"
        
        let formattedDiscount = String(format: "%.2f", discount)
        
        if textField == discountperItemTextfield {
              if discount_type == "2" {
                dollarAmt = formattedDiscount
                getlessAmtVarient()
              }
              else {
                dollarAmt = ""
              }
            }
            else if textField == discountQtyTextfield {
              guard qty > freeQty else {
                ToastClass.sharedToast.showToast(message: "Free Quantity must be less than Buy Quantity",
                                 font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                discountQtyTextfield.isError(numberOfShakes: 3, revert: true)
                return
              }
            }
        
        guard qty > 0, freeQty > 0, qty > freeQty, discount > 0.00 else {
            describeDealTextfield.text = ""
            return
        }
        
        if discount_type == "2" {
            describeDealTextfield.text = "Buy \(buyQty), Get \(freeQty) \(discountType)\(formattedDiscount) off"
        }
        else {
            if discount < 100 {
                describeDealTextfield.text = "Buy \(buyQty), Get \(freeQty) \(formattedDiscount) \(discountType) off"
                
            }
            else {
                describeDealTextfield.text = "Buy \(buyQty), Get \(freeQty) Free"
                
            }
            
        }
    }
}

extension CreateBOGODealViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching {
            return searchVarArray.count
        }
        else {
            return variantArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if searching {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CreatBogoDealCell", for: indexPath) as! CreatBogoDealCell
            
            let variant = searchVarArray[indexPath.row]
            
            
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
        else {
            
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
}

extension CreateBOGODealViewController: UICollectionViewDelegate, UICollectionViewDataSource  {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collBts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collection.dequeueReusableCell(withReuseIdentifier: "btscell", for: indexPath) as! PlusCollCollectionViewCell
        
        cell.catPlusLbl.text = collBts[indexPath.row].store_name
        cell.borderview.layer.cornerRadius = 5.0
        cell.closeBtn.tag = indexPath.row
        
        return cell
    }
}

extension CreateBOGODealViewController : SelectBogoDelegate {
    
    func addSelectedBogoVariants(arr: [VariantBogoModel]) {
        
        variantArray = arr
        subvarArray = arr
        
        if variantArray.count == 0 {
            searchBar.isHidden = true
            
        }
        else {
            searchBar.isHidden = false
        }
        tableView.reloadData()
        
    }
}

extension CreateBOGODealViewController: AddBogoStoresDelegate {
    func setSelectedStores(reverseStores: [Store]) {
        collBts = reverseStores
        collection.reloadData()
    }
}
