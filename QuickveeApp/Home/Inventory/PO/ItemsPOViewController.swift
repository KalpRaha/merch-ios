//
//  ItemsPOViewController.swift
//  QuickveeApp
//
//  Created by Kalpesh on 31/07/25.
//

import UIKit

protocol POSelectDelegate: AnyObject {
    func didSelectVariant(variant: [InventoryVariant], revreqQtyArr: [String], revCostArr: [String],
                          revNoteArr: [String], revAfterQtyArr: [String], revTotalArr: [String],
                          revOrderItemArr: [String], revStatusArr: [String])
}

class ItemsPOViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var autoBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var vendorName: UILabel!
    @IBOutlet weak var editLbl: UILabel!
    @IBOutlet weak var saveDraft: UILabel!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var threeBtns: UIButton!
    
    @IBOutlet weak var threeBtnWidth: NSLayoutConstraint!
    
    @IBOutlet weak var menu: UIView!
    @IBOutlet weak var emailLbl: UILabel!

    var activeTextField = UITextField()
    
    var poSelectedVariants = [InventoryVariant]()
    var variantList = [InventoryVariant]()
    
    var bigDetails: PODetails?
    
    var mode = ""
    var vendorSelect: VendorPO?
    var id = ""
    var displayName = ""
    var vendor_id = ""
    
    var reqQtyArr = [String]()
    var costArr = [String]()
    var noteArr = [String]()
    var afterQtyArr = [String]()
    var totalArr = [String]()
    
    var orderItemArr = [String]()
    var statusArr = [String]()
    
    var fullAddedPOList = [InventoryVariant]()
    var fullAddedReqQtyArr = [String]()
    var fullAddedCostArr = [String]()
    var fullAddedNoteArr = [String]()
    var fullAddedAfterQtyArr = [String]()
    var fullAddedTotalArr = [String]()
    
    var fullAddedOrderItemArr = [String]()
    var fullAddedStatusArr = [String]()
    
    var itemslist = [POItems]()
    var poVarList = [InventoryVariant]()
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.showsVerticalScrollIndicator = false
        
        autoBtn.layer.cornerRadius = 10
        saveBtn.layer.cornerRadius = 10
        
        autoBtn.layer.borderWidth = 1
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(editClick))
        editLbl.addGestureRecognizer(tap)
        editLbl.isUserInteractionEnabled = true
        tap.numberOfTapsRequired = 1
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(saveDraftClick))
        saveDraft.addGestureRecognizer(tap1)
        saveDraft.isUserInteractionEnabled = true
        tap1.numberOfTapsRequired = 1
        
        setupUI()
        
        menu.isHidden = true
        menu.layer.cornerRadius = 10
        menu.layer.shadowColor =  UIColor.lightGray.cgColor
        menu.layer.shadowOpacity = 1
        menu.layer.shadowRadius = 3
        menu.layer.shadowOffset = CGSize.zero
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if mode == "add" {
            editLbl.text = ""
            saveDraft.text = "Save Draft"
            saveDraft.textColor = UIColor(named: "SelectCat")
            vendorName.text = vendorSelect?.name ?? ""
            saveBtn.setTitle("Create", for: .normal)
            autoBtn.setTitle("Auto PO", for: .normal)
            autoBtn.setTitleColor(.black, for: .normal)
            autoBtn.layer.borderColor = UIColor.black.cgColor
        }
        else if mode == "edit" {
            editLbl.text = "Edit"
            setupApi()
        }
    }
    
    func setupApi() {
        
        self.loadingIndicator.isAnimating = true
        self.tableview.isHidden = true
        
        let mid = UserDefaults.standard.string(forKey: "merchant_id") ?? ""

        ApiCalls.sharedCall.getPOById(merchant_id: mid, id: id, admin_id: mid) { isSuccess, responseData in
            
            if isSuccess {
                
                if let data = responseData["result"] {
                    
                    self.getResponseValues(list: data)
                }
                else {
                    print("Api Error")
                }
            }
            else {
                print("Api Error")
            }
        }
    }
    
    func getResponseValues(list: Any) {
        
        let response = list as! [String: Any]
                
        let details = PODetails(id: "\(response["id"] ?? "")", merchant_id: "\(response["merchant_id"] ?? "")",
                                admin_id: "\(response["admin_id"] ?? "")", po_number: "\(response["po_number"] ?? "")",
                                vendor_id: "\(response["vendor_id"] ?? "")", vendor_names: "\(response["vendor_names"] ?? "")",
                                reference: "\(response["reference"] ?? "")", email: "\(response["email"] ?? "")",
                                issued_date: "\(response["issued_date"] ?? "")", stock_date: "\(response["stock_date"] ?? "")",
                                received_status: "\(response["received_status"] ?? "")", is_void: "\(response["is_void"] ?? "")",
                                is_draft: "\(response["is_draft"] ?? "")", is_deleted: "\(response["is_deleted"] ?? "")",
                                received_at: "\(response["received_at"] ?? "")", created_at: "\(response["created_at"] ?? "")",
                                updated_at: "\(response["updated_at"] ?? "")", zoho_invoice_id: "\(response["zoho_invoice_id"] ?? "")",
                                employee_id: "\(response["employee_id"] ?? "")", IsCompleteInvoiceFromZoho: "\(response["IsCompleteInvoiceFromZoho"] ?? "")",
                                vendor_name: "\(response["vendor_name"] ?? "")", order_items: response["order_items"])
        
        bigDetails = details
        
        vendorName.text = details.vendor_name
        vendor_id = details.vendor_id

        if details.is_draft == "1" {
            saveDraft.text = "Save Draft"
            saveDraft.textColor = UIColor(named: "SelectCat")
            saveBtn.setTitle("Save", for: .normal)
            autoBtn.setTitle("Delete", for: .normal)
            autoBtn.setTitleColor(UIColor(named: "deletBorder"), for: .normal)
            autoBtn.layer.borderColor = UIColor(named: "deletBorder")?.cgColor
            threeBtns.isHidden = true
            searchBtn.isHidden = false
            threeBtnWidth.constant = 0
        }
        else {
            saveDraft.text = "Void"
            saveDraft.textColor = UIColor(named: "deletBorder")
            saveBtn.setTitle("Save", for: .normal)
            autoBtn.setTitle("Edit PO", for: .normal)
            autoBtn.setTitleColor(.black, for: .normal)
            autoBtn.layer.borderColor = UIColor.black.cgColor
            threeBtns.isHidden = false
            searchBtn.isHidden = true
            threeBtnWidth.constant = 50
        }
        
        getItems(items: details.order_items)
    }
    
    func getItems(items: Any) {
        
        var smallitems = [POItems]()
        
        let response = items as! [[String: Any]]
        
        for item in response {
            
            let poitem = POItems(id: "\(item["id"] ?? "")", merchant_id: "\(item["merchant_id"] ?? "")",
                               admin_id: "\(item["admin_id"] ?? "")", vendor_id: "\(item["vendor_id"] ?? "")",
                               vendor_name: "\(item["vendor_name"] ?? "")", po_id: "\(item["po_id"] ?? "")",
                               po_number: "\(item["po_number"] ?? "")", product_id: "\(item["product_id"] ?? "")",
                               variant_id: "\(item["variant_id"] ?? "")", required_qty: "\(item["required_qty"] ?? "")",
                               recieved_qty: "\(item["recieved_qty"] ?? "")", recieved_status: "\(item["recieved_status"] ?? "")",
                               pending_qty: "\(item["pending_qty"] ?? "")", cost_per_item: "\(item["cost_per_item"] ?? "")",
                               total_pricing: "\(item["total_pricing"] ?? "")", upc: "\(item["upc"] ?? "")", note: "\(item["note"] ?? "")",
                               created_at: "\(item["created_at"] ?? "")", updated_at: "\(item["updated_at"] ?? "")",
                               after_qty: "\(item["after_qty"] ?? "")", zoho_invoice_id: "\(item["zoho_invoice_id"] ?? "")",
                               product_title: "\(item["product_title"] ?? "")", product_qty: "\(item["product_qty"] ?? "")",
                               variant_title: "\(item["variant_title"] ?? "")", variant_qty: "\(item["variant_qty"] ?? "")",
                               item_fullname: "\(item["item_fullname"] ?? "")", item_qty: "\(item["item_qty"] ?? "")")
            
            smallitems.append(poitem)
            
            reqQtyArr.append(poitem.required_qty)
            costArr.append(poitem.cost_per_item)
            noteArr.append(poitem.note)
            afterQtyArr.append(poitem.after_qty)
            totalArr.append(poitem.total_pricing)
            
            orderItemArr.append(poitem.id)
            statusArr.append(poitem.recieved_status)
        }
        itemslist = smallitems
        
        variantListApi()
    }
    
    func variantListApi() {
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        ApiCalls.sharedCall.variantListCall(merchant_id: id) { isSuccess, responseData in
            
            if isSuccess {
                
                guard let list = responseData["result"] else {
                    return
                }
                self.getResponseValues(varient: list)
            }
            else{
                print("Api Error")
            }
        }
    }
    
    func getResponseValues(varient: Any){
        
        let response = varient as! [[String: Any]]
        var small = [InventoryVariant]()
        
        for res in response {
            
            let variant = InventoryVariant(id: "\(res["id"] ?? "")", costperItem: "\(res["costperItem"] ?? "")",
                                           title: "\(res["title"] ?? "")",
                                           isvarient: "\(res["isvarient"] ?? "")", upc: "\(res["upc"] ?? "")",
                                           cotegory: "\(res["cotegory"] ?? "")",
                                           var_id: "\(res["var_id"] ?? "")",
                                           var_upc: "\(res["var_upc"] ?? "")",
                                           quantity: "\(res["quantity"] ?? "")", price: "\(res["price"] ?? "")",
                                           custom_code: "\(res["custom_code"] ?? "")", variant: "\(res["variant"] ?? "")",
                                           var_price: "\(res["var_price"] ?? "")", is_lottery: "\(res["is_lottery"] ?? "")",
                                           var_costperItem: "\(res["var_costperItem"] ?? "")")
            
            small.append(variant)
        }
        
        variantList = small
        
        getPOVariants()
    }
    
    func getPOVariants() {
        
        var smallVarList = [InventoryVariant]()
        
        for variant in variantList {
            
            if variant.isvarient == "1" {
                
                if itemslist.contains(where: {$0.variant_id == variant.var_id}) {
                    smallVarList.append(variant)
                }
            }
            else {
                if itemslist.contains(where: {$0.product_id == variant.id}) {
                    smallVarList.append(variant)
                }
            }
        }
        
        poVarList = smallVarList
        
        poVarList.append(contentsOf: fullAddedPOList)
        reqQtyArr.append(contentsOf: fullAddedReqQtyArr)
        costArr.append(contentsOf: fullAddedCostArr)
        noteArr.append(contentsOf: fullAddedNoteArr)
        afterQtyArr.append(contentsOf: fullAddedAfterQtyArr)
        totalArr.append(contentsOf: fullAddedTotalArr)
        
        orderItemArr.append(contentsOf: fullAddedOrderItemArr)
        statusArr.append(contentsOf: fullAddedStatusArr)
        
        DispatchQueue.main.async {
            self.loadingIndicator.isAnimating = false
            self.tableview.isHidden = false
            self.tableview.reloadData()
        }
    }
    
    @objc func editClick() {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "addpo") as! AddPOViewController
        vc.addPODetails = bigDetails!
        vc.mode = mode
        present(vc, animated: true)
    }
    
    @objc func saveDraftClick() {
        
        let m_id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        if saveDraft.text == "Save Draft" {
            
            var final_json = ""
            
            let v_id = vendorSelect?.id ?? ""
            let i_d = vendorSelect?.issue_date ?? ""
            let s_d = vendorSelect?.stock_date ?? ""
            let r_f = vendorSelect?.reference ?? ""
            let v_e = vendorSelect?.vendor_email ?? ""
            
            var upc = ""
            var var_id = ""
            var p_id = ""
            
            if mode == "add" {
                
                var smallAdd = [AddPO]()
                
                for item in 0..<poSelectedVariants.count {
                    
                    p_id = poSelectedVariants[item].id
                    
                    if poSelectedVariants[item].isvarient == "1" {
                        upc = poSelectedVariants[item].var_upc
                        var_id = poSelectedVariants[item].var_id
                    }
                    else {
                        upc = poSelectedVariants[item].upc
                        var_id = ""
                    }
                    
                    let req = reqQtyArr[item]
                    let cost = costArr[item]
                    let total = totalArr[item]
                    let note = noteArr[item]
                    let afterQty = afterQtyArr[item]
                    
                    let pos = AddPO(product_id: p_id, variant_id: var_id, required_qty: req,
                                    cost_per_item: cost, total_pricing: total, upc: upc,
                                    note: note, after_qty: afterQty)
                    
                    smallAdd.append(pos)
                }
            }
            else {
                
                var smallAdd = [EditPO]()
                
                for item in 0..<poVarList.count {
                    
                    p_id = poVarList[item].id
                    
                    if poVarList[item].isvarient == "1" {
                        upc = poVarList[item].var_upc
                        var_id = poVarList[item].var_id
                    }
                    else {
                        upc = poVarList[item].upc
                        var_id = ""
                    }
                    
                    let req = reqQtyArr[item]
                    let cost = costArr[item]
                    let total = totalArr[item]
                    let note = noteArr[item]
                    let afterQty = afterQtyArr[item]
                    
                    let order_items = orderItemArr[item]
                    let status = statusArr[item]
                    
                    let pos = EditPO(order_item_id: order_items, product_id: p_id, variant_id: var_id,
                                     required_qty: req, recieved_status: status, cost_per_item: cost,
                                     total_pricing: total, upc: upc, note: note, after_qty: afterQty)
                    
                    smallAdd.append(pos)
                }
                
                do {
                    let encoder = JSONEncoder()
                    encoder.outputFormatting = .prettyPrinted  // Makes the output readable
                    let jsonData = try encoder.encode(smallAdd) // Wrap the object in an array for consistency with the provided JSON structure
                    
                    // Convert the encoded JSON into a string for display or further processing
                    if let jsonString = String(data: jsonData, encoding: .utf8) {
                        final_json = jsonString
                    }
                } catch {
                    print("Error encoding JSON: \(error)")
                }
                
                let po_id = bigDetails?.id ?? ""
                let r_status = bigDetails?.received_status ?? ""
                
                ApiCalls.sharedCall.updatePO(merchant_id: m_id, admin_id: m_id, po_id: po_id,
                                                     issue_date: i_d, stock_date: s_d, reference: r_f,
                                                     vendor_email: v_e, order_items: final_json, is_draft: "1",
                                                     received_status: r_status, updated_at: i_d) { isSuccess, responseData in
                    
                    if isSuccess {
                        ToastClass.sharedToast.showToast(message: "Draft Updated Successfully", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                        self.home()
                    }
                    else {
                        print("Api Error")
                    }
                }
            }
        }
        else {
            
        }
    }
    
    func roundOf(item : String) -> Double {
        
        let doub = Double(item) ?? 0.00
        let div = (100 * doub) / 100
        print(div)
        return div
    }
    
    func calQtyAfter(qty: String, req: String) -> String {
        
        let qty_int = Int(qty) ?? 0
        let req_int = Int(req) ?? 0
        
        print(qty_int)
        print(req_int)
        
        let total = qty_int + req_int
        return String(total)
        
    }
    
    func calTotal(qty: String, req: String) -> String {
        
        let qty_int = Int(qty) ?? 0
        let req_int = Int(req) ?? 0
        
        print(qty_int)
        print(req_int)
        
        let total = qty_int + req_int
        return String(total)
        
    }
    
    func home() {
        
        var destiny = 0
        
        let viewcontrollerArray = navigationController?.viewControllers
        
        if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is InventoryViewController }) {
            destiny = destinationIndex
        }
        
        navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
    }
    
    
    @IBAction func searchBtnClick(_ sender: UIButton) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "poselect") as! POSelectViewController
        
        vc.selectDelegate = self
        vc.mode = mode
        vc.poSelectedVariants = poVarList
        present(vc, animated: true)
    }
    
    
    @IBAction func menuBtnClick(_ sender: UIButton) {
        
        if menu.isHidden {
            menu.isHidden = false
        }
        else {
            menu.isHidden = true
        }
    }
    
    
    @IBAction func autoBtnClick(_ sender: UIButton) {
        
        let m_id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        
        if sender.titleLabel?.text == "Auto PO" {
            
            ApiCalls.sharedCall.autoPOList(merchant_id: m_id, admin_id: m_id, vendor_id: vendor_id) { isSuccess, responseData in
                
                if isSuccess {
                    
                    if let status = responseData["status"], status as! Int == 1  {
                       
                        let msg = responseData["message"] as? String ?? ""
                        ToastClass.sharedToast.showToast(message: msg,
                                                         font: UIFont(name: "Manrope-SemiBold", size: 15.0)!)
                        self.navigationController?.popViewController(animated: true)
                    }
                    else {
                        print("Api Error")
                    }
                }
                else {
                    print("Api Error")
                }
            }
        }
        else if sender.titleLabel?.text == "Delete" {
            
            let emp_id = UserDefaults.standard.string(forKey: "emp_po_id") ?? ""
            
            ApiCalls.sharedCall.deletePO(merchant_id: m_id, employee_id: emp_id, po_id: id) { isSuccess, responseData in
                
                if isSuccess {
                    
                    if let status = responseData["status"], status as! Int == 1  {
                       
                        let msg = responseData["message"] as? String ?? ""
                        ToastClass.sharedToast.showToast(message: msg,
                                                         font: UIFont(name: "Manrope-SemiBold", size: 15.0)!)
                        self.navigationController?.popViewController(animated: true)
                    }
                    else {
                        print("Api Error")
                    }
                }
                else {
                    print("Api Error")
                }
            }
        }
        else {
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "poselect") as! POSelectViewController
            
            vc.selectDelegate = self
            vc.mode = mode
            vc.poSelectedVariants = poSelectedVariants
            present(vc, animated: true)
        }
    }
    
    
    @IBAction func saveBtnClick(_ sender: UIButton) {
        
        let m_id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        var final_json = ""
        
        let v_id = vendorSelect?.id ?? ""
        let i_d = vendorSelect?.issue_date ?? ""
        let s_d = vendorSelect?.stock_date ?? ""
        let r_f = vendorSelect?.reference ?? ""
        let v_e = vendorSelect?.vendor_email ?? ""
        
        var upc = ""
        var var_id = ""
        var p_id = ""
        
        if sender.titleLabel?.text == "Create" {
            
            var smallAdd = [AddPO]()
            
            for item in 0..<poSelectedVariants.count {
                
                p_id = poSelectedVariants[item].id
                
                if poSelectedVariants[item].isvarient == "1" {
                    upc = poSelectedVariants[item].var_upc
                    var_id = poSelectedVariants[item].var_id
                }
                else {
                    upc = poSelectedVariants[item].upc
                    var_id = ""
                }
                
                let req = reqQtyArr[item]
                let cost = costArr[item]
                let total = totalArr[item]
                let note = noteArr[item]
                let afterQty = afterQtyArr[item]
                
                let pos = AddPO(product_id: p_id, variant_id: var_id, required_qty: req,
                                cost_per_item: cost, total_pricing: total, upc: upc,
                                note: note, after_qty: afterQty)
                
                smallAdd.append(pos)
            }
            
            do {
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted  // Makes the output readable
                let jsonData = try encoder.encode(smallAdd) // Wrap the object in an array for consistency with the provided JSON structure
                
                // Convert the encoded JSON into a string for display or further processing
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    final_json = jsonString
                }
            } catch {
                print("Error encoding JSON: \(error)")
            }
            
            ApiCalls.sharedCall.savePO(merchant_id: m_id, admin_id: m_id, vendor_id: v_id,
                                       issue_date: i_d, stock_date: s_d, reference: r_f,
                                       vendor_email: v_e, order_items: final_json, is_draft: "0",
                                       created_at: i_d) { isSuccess, responseData in
                
                if isSuccess {
                    
                    ToastClass.sharedToast.showToast(message: "PO Created Successfully", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                    self.home()
                }
                else {
                    print("Api Error")
                }
            }
        }
        else {
            
            var smallAdd = [EditPO]()
            
            for item in 0..<poVarList.count {
                
                p_id = poVarList[item].id
                
                if poVarList[item].isvarient == "1" {
                    upc = poVarList[item].var_upc
                    var_id = poVarList[item].var_id
                }
                else {
                    upc = poVarList[item].upc
                    var_id = ""
                }
                
                let req = reqQtyArr[item]
                let cost = costArr[item]
                let total = totalArr[item]
                let note = noteArr[item]
                let afterQty = afterQtyArr[item]
                
                let order_items = orderItemArr[item]
                let status = statusArr[item]
                
                let pos = EditPO(order_item_id: order_items, product_id: p_id, variant_id: var_id,
                                 required_qty: req, recieved_status: status, cost_per_item: cost,
                                 total_pricing: total, upc: upc, note: note, after_qty: afterQty)
                
                smallAdd.append(pos)
            }
            
            do {
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted  // Makes the output readable
                let jsonData = try encoder.encode(smallAdd) // Wrap the object in an array for consistency with the provided JSON structure
                
                // Convert the encoded JSON into a string for display or further processing
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    final_json = jsonString
                }
            } catch {
                print("Error encoding JSON: \(error)")
            }
            
            let po_id = bigDetails?.id ?? ""
            let r_status = bigDetails?.received_status ?? ""
            
            ApiCalls.sharedCall.updatePO(merchant_id: m_id, admin_id: m_id, po_id: po_id,
                                         issue_date: i_d, stock_date: s_d, reference: r_f,
                                         vendor_email: v_e, order_items: final_json, is_draft: "0",
                                         received_status: r_status, updated_at: i_d) { isSuccess, responseData in
                
                if isSuccess {
                    
                    ToastClass.sharedToast.showToast(message: "PO Updated Successfully", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                    self.home()
                }
                else {
                    print("Api Error")
                }
            }
        }
    }
    
    @IBAction func deleteClickBtn(_ sender: UIButton) {
        
        loadingIndicator.isAnimating = true
        tableview.isHidden = true
        
        let tag = sender.tag
        
        if mode == "add" {
            poSelectedVariants.remove(at: tag)
        }
        else {
            poVarList.remove(at: tag)
        }
        
        loadingIndicator.isAnimating = false
        tableview.isHidden = false
        tableview.reloadData()
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
}

extension ItemsPOViewController: POSelectDelegate {
    
    func didSelectVariant(variant: [InventoryVariant], revreqQtyArr: [String], revCostArr: [String],
                          revNoteArr: [String], revAfterQtyArr: [String], revTotalArr: [String],
                          revOrderItemArr: [String], revStatusArr: [String]) {
                
        if variant.count > 0 {
            
            poVarList = variant
            reqQtyArr = revreqQtyArr
            costArr = revCostArr
            noteArr = revNoteArr
            afterQtyArr = revAfterQtyArr
            totalArr = revTotalArr
            orderItemArr = revOrderItemArr
            statusArr = revStatusArr
            
            tableview.reloadData()
        }
        else {
            
        }
    }
}

extension ItemsPOViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        let index = IndexPath(row: textField.tag, section: 0)
        
        let cell = tableview.cellForRow(at: index) as! ItemsPOTableViewCell
        
        if textField == cell.qtyTextField {
            activeTextField = textField
        }
        else if textField == cell.costPerTextField {
            activeTextField = textField
        }
        else {
            activeTextField = textField
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let index = IndexPath(row: textField.tag, section: 0)
        
        let cell = tableview.cellForRow(at: index) as! ItemsPOTableViewCell
        
        if textField == cell.qtyTextField {
            
            if mode == "add" {
                
                let req_qty = cell.qtyTextField.text ?? ""
                let qty = poSelectedVariants[textField.tag].quantity
                
                let cost = cell.costPerTextField.text ?? ""
                
                let req_int = Int(req_qty) ?? 0
                let qty_int = Int(qty) ?? 0
                
                let req_doub = Double(req_qty) ?? 0.0
                let cost_doub = Double(cost) ?? 0.0
                
                let qtyAfter = qty_int + req_int
                let total = req_doub * cost_doub
                
                cell.qtyAfter.text = "Qty After: \(qtyAfter)"
                cell.total.text = "Total: $\(total)"
                
                reqQtyArr[textField.tag] = req_qty
                afterQtyArr[textField.tag] = "\(qtyAfter)"
                totalArr[textField.tag] = "\(total)"
            }
            else {
                
                let req_qty = cell.qtyTextField.text ?? ""
                let qty = poVarList[textField.tag].quantity
                
                let cost = cell.costPerTextField.text ?? ""
                
                let req_int = Int(req_qty) ?? 0
                let qty_int = Int(qty) ?? 0
                
                let req_doub = Double(req_qty) ?? 0.0
                let cost_doub = Double(cost) ?? 0.0
                
                let qtyAfter = qty_int + req_int
                let total = req_doub * cost_doub
                
                cell.qtyAfter.text = "Qty After: \(qtyAfter)"
                cell.total.text = "Total: $\(total)"
                
                reqQtyArr[textField.tag] = req_qty
                afterQtyArr[textField.tag] = "\(qtyAfter)"
                totalArr[textField.tag] = "\(total)"
            }
        }
        else if textField == cell.costPerTextField {
            
            if mode == "add" {
                
                let req_qty = cell.qtyTextField.text ?? ""
                let cost = cell.costPerTextField.text ?? ""
                
                let req_doub = Double(req_qty) ?? 0.0
                let cost_doub = Double(cost) ?? 0.0
                
                let total = req_doub * cost_doub
                
                costArr[textField.tag] = cost
                
                cell.total.text = "Total: $\(total)"
                totalArr[textField.tag] = "\(total)"
            }
            else {
                
                let req_qty = cell.qtyTextField.text ?? ""
                let cost = cell.costPerTextField.text ?? ""
                                
                let req_doub = Double(req_qty) ?? 0.0
                let cost_doub = Double(cost) ?? 0.0
                
                let total = req_doub * cost_doub
                
                costArr[textField.tag] = cost
                
                cell.total.text = "Total: $\(total)"
                
                totalArr[textField.tag] = "\(total)"
            }
        }
        else {
            let note = cell.noteField.text ?? ""
            noteArr[textField.tag] = note
        }
    }
    
    private func setupUI() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor
                .constraint(equalTo: view.centerXAnchor, constant: 0),
            loadingIndicator.centerYAnchor
                .constraint(equalTo: view.centerYAnchor),
            loadingIndicator.widthAnchor
                .constraint(equalToConstant: 40),
            loadingIndicator.heightAnchor
                .constraint(equalTo: self.loadingIndicator.widthAnchor)
        ])
    }
}
    
extension ItemsPOViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if mode == "add" {
            return poSelectedVariants.count
        }
        else {
            return poVarList.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ItemsPOTableViewCell
        
        if mode == "add" {
            
            let item = poSelectedVariants[indexPath.row]
            
            cell.name.text = item.title
            
            cell.qtyTextField.text = ""
            
            if item.isvarient == "1" {
                cell.costPerTextField.text = costArr[indexPath.row]
                cell.upc.text = "UPC: \(item.var_upc)"
            }
            else {
                cell.costPerTextField.text = costArr[indexPath.row]
                cell.upc.text = "UPC: \(item.upc)"
            }
            
            cell.noteField.text = noteArr[indexPath.row]
            
            cell.qtyAfter.text = "Qty After:"
            cell.total.text = "Total:"
        }
        
        else {
            
            let item = poVarList[indexPath.row]
            
            cell.name.text = item.title
            
            if item.isvarient == "1" {
                cell.costPerTextField.text = costArr[indexPath.row]
                cell.upc.text = "UPC: \(item.var_upc)"
            }
            else {
                cell.costPerTextField.text = costArr[indexPath.row]
                cell.upc.text = "UPC: \(item.upc)"
            }
            
            cell.qtyTextField.text = reqQtyArr[indexPath.row]
            
            cell.noteField.text = noteArr[indexPath.row]
                    
            cell.qtyAfter.text = "Qty After: \(afterQtyArr[indexPath.row])"
            cell.total.text = "Total: $\(totalArr[indexPath.row])"
        }
        
        cell.qtyTextField.borderStyle = .none
        cell.qtyTextField.delegate = self
        cell.qtyTextField.keyboardType = .numberPad
        
        cell.qtyView.layer.borderColor = UIColor(hexString: "#D0D0D0").cgColor
        cell.qtyView.layer.borderWidth = 1
        cell.qtyView.layer.cornerRadius = 10
        
        cell.costPerTextField.borderStyle = .none
        cell.costPerTextField.delegate = self
        cell.costPerTextField.keyboardType = .numberPad
        
        cell.costView.layer.borderColor = UIColor(hexString: "#D0D0D0").cgColor
        cell.costView.layer.borderWidth = 1
        cell.costView.layer.cornerRadius = 10
        
        cell.noteField.borderStyle = .none
        cell.noteField.delegate = self
        
        cell.noteView.layer.borderColor = UIColor(hexString: "#D0D0D0").cgColor
        cell.noteView.layer.borderWidth = 1
        cell.noteView.layer.cornerRadius = 10
        
        cell.deleteBtn.tag = indexPath.row
        cell.costPerTextField.tag = indexPath.row
        cell.qtyTextField.tag = indexPath.row
        cell.noteField.tag = indexPath.row
        
        return cell
        
    }
    
}
