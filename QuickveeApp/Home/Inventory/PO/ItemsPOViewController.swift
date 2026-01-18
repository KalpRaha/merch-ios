//
//  ItemsPOViewController.swift
//  QuickveeApp
//
//  Created by Kalpesh on 31/07/25.
//

import UIKit

protocol POSelectDelegate: AnyObject {
    func didSelectVariant(variant: [VariantPOModel])
}

protocol ChangeVendorDelegate: AnyObject {
    func didChangeVendor(vendor: VendorPO)
}

class ItemsPOViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var autoBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var vendorName: UILabel!
    @IBOutlet weak var editLbl: UILabel!
    @IBOutlet weak var saveDraft: UILabel!
    @IBOutlet weak var searchBtn: UIButton!
    
    weak var delegate: POSelectDelegate?
    
    var poSelectedVariants = [VariantPOModel]()
    var variantList = [InventoryVariant]()
    
    var deleteIds = [String]()
    
    var bigDetails: PODetails?
    
    var mode = ""
    var vendorSelect: VendorPO?
    var id = ""
    var displayName = ""
    var vendor_id = ""
    
    var itemslist = [POItems]()
    
    private var isSymbolOnRight = false
    var activeTextField = UITextField()
    
    weak var saveDelegate: SavePOViewControllerDelegate?
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UserDefaults.standard.set(0, forKey: "modal_screen")
        
        if mode == "add" {
            editLbl.text = ""
            saveDraft.text = "Save Draft"
            saveDraft.textColor = UIColor(named: "SelectCat")
            vendorName.text = vendorSelect?.name ?? ""
            saveBtn.setTitle("Create", for: .normal)
            autoBtn.setTitle("Back", for: .normal)
            autoBtn.setTitleColor(.black, for: .normal)
            autoBtn.layer.borderColor = UIColor.black.cgColor
            searchBtn.isHidden = true
        }
        else if mode == "edit" {
            editLbl.text = ""
            setupApi()
        }
        else {
            saveBtn.setTitle("Save", for: .normal)
            autoBtn.setTitle("Back", for: .normal)
            editLbl.text = ""
            vendorName.text = vendorSelect?.name
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
        
        vendorSelect = VendorPO(id: details.vendor_id, name: details.vendor_name,
                                issue_date: details.issued_date, stock_date: details.stock_date,
                                reference: details.reference, vendor_email: details.email)
        
        vendorName.text = details.vendor_name
        vendor_id = details.vendor_id
        
        saveDraft.text = "Save Draft"
        saveDraft.textColor = UIColor(named: "SelectCat")
        saveBtn.setTitle("Create", for: .normal)
        autoBtn.setTitle("Delete", for: .normal)
        autoBtn.setTitleColor(UIColor(named: "deletBorder"), for: .normal)
        autoBtn.layer.borderColor = UIColor(named: "deletBorder")?.cgColor
        searchBtn.isHidden = false
        
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
        var smallPoList = [VariantPOModel]()
        
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
        
        for variant in smallVarList {

            let pos: Int?

            if variant.isvarient == "1" {
                pos = itemslist.firstIndex(where: {
                    $0.variant_id == variant.var_id
                })
            } else {
                pos = itemslist.firstIndex(where: {
                    $0.product_id == variant.id
                })
            }

            guard let index = pos else {
                print("No PO item found for variant:", variant.id)
                continue
            }

            let poItem = itemslist[index]

            let item = VariantPOModel(po: variant, isSelect: true, reqQty: poItem.required_qty,
                cost: poItem.cost_per_item, note: poItem.note, afterQty: poItem.after_qty, total: poItem.total_pricing,
                orderItem: poItem.id, status: poItem.recieved_status, pendingQty: poItem.pending_qty, check: "")

            smallPoList.append(item)
        }
        
        poSelectedVariants = smallPoList
        
        DispatchQueue.main.async {
            self.loadingIndicator.isAnimating = false
            self.tableview.isHidden = false
            self.tableview.reloadData()
        }
    }
    
    func getResponseValuesAuto(list: Any){
        
        let response = list as! [[String: Any]]
        var small = [POAutoItem]()
        
        for item in response {
            
            let auto = POAutoItem(product_id: "\(item["product_id"] ?? "")", product_title: "\(item["product_title"] ?? "")",
                                  item_qty: "\(item["item_qty"] ?? "")", reorder_level: "\(item["reorder_level"] ?? "")",
                                  reorder_qty: "\(item["reorder_qty"] ?? "")", costperItem: "\(item["costperItem"] ?? "")",
                                  upc: "\(item["upc"] ?? "")", prefferd_vendor: "\(item["prefferd_vendor"] ?? "")",
                                  assigned_vendors: "\(item["assigned_vendors"] ?? "")", variant_id: "\(item["variant_id"] ?? "")",
                                  variant_title: "\(item["variant_title"] ?? "")", preferd_vendor_cost: "\(item["preferd_vendor_cost"] ?? "")")
            
            small.append(auto)
        }
        getAutoPOVariants(small: small)
    }
    
    func getAutoPOVariants(small: [POAutoItem]) {
        
        var smallVarList = [InventoryVariant]()
        
        for variant in variantList {
            
            if variant.isvarient == "1" {
                
                if small.contains(where: {$0.variant_id == variant.var_id}) {
                    smallVarList.append(variant)
                }
            }
            else {
                if small.contains(where: {$0.product_id == variant.id}) {
                    smallVarList.append(variant)
                }
            }
        }
        
        DispatchQueue.main.async {
            self.loadingIndicator.isAnimating = false
            self.tableview.isHidden = false
            self.tableview.reloadData()
        }
    }
    
    @objc func editClick() {
        
        let modal = UserDefaults.standard.integer(forKey: "modal_screen")
        
        if modal == 0 {
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "addpo") as! AddPOViewController
            
            let vendor = VendorPO(id: vendorSelect?.id ?? "", name: vendorSelect?.name ?? "",
                                  issue_date: vendorSelect?.issue_date ?? "", stock_date: vendorSelect?.stock_date ?? "",
                                  reference: vendorSelect?.reference ?? "", vendor_email: vendorSelect?.vendor_email ?? "")
            vc.addPODetails = vendor
            vc.mode = mode
            vc.delegate = self
            
            present(vc, animated: true)
        }
    }
    
    @objc func saveDraftClick() {
        
        if mode == "add" {
            createDraft()
        }
        else {
            deletePO(save: 0)
        }
    }
    
    func createDraft() {
        
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
            var reqQty = ""
            var cost = ""
            var total = ""
            var note = ""
            var afterQty = ""
            
            var smallAdd = [AddPO]()
            
            if poSelectedVariants.count == 0 {
                ToastClass.sharedToast.showToast(message: "Please Select Atleast One Product Variant",
                                                 font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            }
            else {
                
                for item in 0..<poSelectedVariants.count {
                    
                    p_id = poSelectedVariants[item].po.id
                    
                    if poSelectedVariants[item].po.isvarient == "1" {
                        upc = poSelectedVariants[item].po.var_upc
                        var_id = poSelectedVariants[item].po.var_id
                    }
                    else {
                        upc = poSelectedVariants[item].po.upc
                        var_id = ""
                    }
                    
                    reqQty = poSelectedVariants[item].reqQty
                    cost = poSelectedVariants[item].cost
                    total = poSelectedVariants[item].total
                    note = poSelectedVariants[item].note
                    afterQty = poSelectedVariants[item].afterQty
                    
                    guard reqQty != "" else {
                        ToastClass.sharedToast.showToast(message: "Add Quantity for all variants",
                                                         font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                        return
                    }
                    
                    let pos = AddPO(product_id: p_id, variant_id: var_id, required_qty: reqQty,
                                    cost_per_item: cost, total_pricing: total, upc: upc,
                                    note: note, after_qty: afterQty)
                    
                    smallAdd.append(pos)
                }
                
                guard smallAdd.count != 0 else {
                    ToastClass.sharedToast.showToast(message: "Please Select Atleast One Product Variant",
                                                     font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                    return
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
                
                tableview.isHidden = true
                loadingIndicator.isAnimating = true
                
                ApiCalls.sharedCall.savePO(merchant_id: m_id, admin_id: m_id, vendor_id: v_id,
                                           issue_date: i_d, stock_date: s_d, reference: r_f,
                                           vendor_email: v_e, order_items: final_json, is_draft: "1",
                                           created_at: i_d) { isSuccess, responseData in
                    
                    if isSuccess {
                        ToastClass.sharedToast.showToast(message: "Draft Created Successfully", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                        self.tableview.isHidden = false
                        self.loadingIndicator.isAnimating = false
                        self.home()
                    }
                    else {
                        print("Api Error")
                    }
                }
            }
        }
    }
    
    func updateDraft() {
        
        let m_id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        let emp_id = UserDefaults.standard.string(forKey: "emp_po_id") ?? ""
        
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
            var reqQty = ""
            var cost = ""
            var total = ""
            var note = ""
            var afterQty = ""
            var status = ""
            var order_item_id = ""
            
            var smallAdd = [EditPO]()
            
            if poSelectedVariants.count == 0 {
                ToastClass.sharedToast.showToast(message: "Please Select Atleast One Product Variant",
                                                 font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            }
            else {
                for item in 0..<poSelectedVariants.count {
                    
                    p_id = poSelectedVariants[item].po.id
                    
                    if poSelectedVariants[item].po.isvarient == "1" {
                        upc = poSelectedVariants[item].po.var_upc
                        var_id = poSelectedVariants[item].po.var_id
                    }
                    else {
                        upc = poSelectedVariants[item].po.upc
                        var_id = ""
                    }
                    
                    reqQty = poSelectedVariants[item].reqQty
                    cost = poSelectedVariants[item].cost
                    total = poSelectedVariants[item].total
                    note = poSelectedVariants[item].note
                    afterQty = poSelectedVariants[item].afterQty
                    status = poSelectedVariants[item].status
                    order_item_id = poSelectedVariants[item].orderItem
                    
                    guard reqQty != "" else {
                        ToastClass.sharedToast.showToast(message: "Add Quantity for all variants",
                                                         font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                        return
                    }
                    
                    let pos = EditPO(order_item_id: order_item_id, product_id: p_id, variant_id: var_id,
                                     required_qty: reqQty, recieved_status: status, cost_per_item: cost,
                                     total_pricing: total, upc: upc, note: note, after_qty: afterQty)
                    print(pos)
                    smallAdd.append(pos)
                }
                
                guard smallAdd.count != 0 else {
                    ToastClass.sharedToast.showToast(message: "Please Select Atleast One Product Variant",
                                                     font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                    return
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
                
                
                tableview.isHidden = true
                loadingIndicator.isAnimating = true
                
                ApiCalls.sharedCall.updatePO(merchant_id: m_id, admin_id: m_id, po_id: po_id, employee_id: emp_id, vendor_id: v_id,
                                             issue_date: i_d, stock_date: s_d, reference: r_f,
                                             vendor_email: v_e, order_items: final_json, is_draft: "1",
                                             received_status: r_status, updated_at: i_d) { isSuccess, responseData in
                    
                    if isSuccess {
                        ToastClass.sharedToast.showToast(message: "Draft Updated Successfully", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                        self.tableview.isHidden = false
                        self.loadingIndicator.isAnimating = false
                        self.home()
                    }
                    else {
                        print("Api Error")
                    }
                }
            }
        }
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
    
    func setupDeleteApi(id: String, tag: Int) {
        
        self.loadingIndicator.isAnimating = true
        self.tableview.isHidden = true
        
        let m_id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        let vendor_id = bigDetails?.vendor_id ?? ""
        
        ApiCalls.sharedCall.deletePOItem(merchant_id: m_id, po_item_id: id, vendor_id: vendor_id) { isSuccess, responseData in
            
            if isSuccess {
                
                if let status = responseData["status"], status as! Int == 1  {
                    
                    let msg = responseData["message"] as? String ?? ""
                    ToastClass.sharedToast.showToast(message: msg, font: UIFont(name: "Manrope-SemiBold", size: 15.0)!)
                    self.poSelectedVariants.remove(at: tag)
                    self.loadingIndicator.isAnimating = false
                    self.tableview.isHidden = false
                    self.tableview.reloadData()
                }
                else {
                    print("Api Error")
                    self.loadingIndicator.isAnimating = false
                    self.tableview.isHidden = false
                }
            }
            else {
                self.loadingIndicator.isAnimating = false
                self.tableview.isHidden = false
            }
        }
    }
    
    @IBAction func searchBtnClick(_ sender: UIButton) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "poselect") as! POSelectViewController
        
        vc.selectDelegate = self
        vc.mode = mode
        vc.poSelectedVariants = poSelectedVariants
        
        present(vc, animated: true)
    }
    
    
    @IBAction func autoBtnClick(_ sender: UIButton) {
        
        let m_id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
//        if sender.titleLabel?.text == "Auto PO" {
//            
//            loadingIndicator.isAnimating = true
//            tableview.isHidden = true
//            
//            let v = vendorSelect?.id ?? ""
//            
//            ApiCalls.sharedCall.autoPOList(merchant_id: m_id, admin_id: m_id, vendor_id: v) { isSuccess, responseData in
//                
//                if isSuccess {
//                    print(responseData)
//                    if let data = responseData["result"] {
//                        self.getResponseValuesAuto(list: data)
//                    }
//                    else {
//                        ToastClass.sharedToast.showToast(message: "No Product List Found",
//                                                         font: UIFont(name: "Manrope-SemiBold", size: 15.0)!)
//                        self.loadingIndicator.isAnimating = false
//                        self.tableview.isHidden = false
//                        print("Api Error")
//                    }
//                }
//                else {
//                    print("Api Error")
//                }
//            }
//        }
        if sender.titleLabel?.text == "Delete" {
            
            let emp_id = UserDefaults.standard.string(forKey: "emp_po_id") ?? ""
            
            let alertController = UIAlertController(title: "Alert", message: "Are you sure you want to delete this Purchase Order?", preferredStyle: .alert)
            
            let cancel = UIAlertAction(title: "No", style: .default) { (action:UIAlertAction!) in
                self.dismiss(animated: true)
            }
            
            let okAction = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction!) in
                
                print("Ok button tapped")
                
                ApiCalls.sharedCall.deletePO(merchant_id: m_id, employee_id: emp_id, po_id: self.id) { isSuccess, responseData in
                    
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
            
            alertController.addAction(cancel)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion:nil)
        }
//        else {
//            dismiss(animated: true) {
//                self.saveDelegate?.savePOItem(save: self.poSelectedVariants, mode: "join")
//            }
//        }
    }
    
    
    @IBAction func saveBtnClick(_ sender: UIButton) {
    
        if mode == "add" {
            createPO()
        }
        
        else {
            deletePO(save: 1)
        }
    }
    
    func createPO() {
        
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
        var reqQty = ""
        var cost = ""
        var total = ""
        var note = ""
        var afterQty = ""
        var status = ""
        var order_item_id = ""
        
        var smallAdd = [AddPO]()
        
        for item in 0..<poSelectedVariants.count {
            
            p_id = poSelectedVariants[item].po.id
            
            if poSelectedVariants[item].po.isvarient == "1" {
                upc = poSelectedVariants[item].po.var_upc
                var_id = poSelectedVariants[item].po.var_id
            }
            else {
                upc = poSelectedVariants[item].po.upc
                var_id = ""
            }
            
            reqQty = poSelectedVariants[item].reqQty
            cost = poSelectedVariants[item].cost
            total = poSelectedVariants[item].total
            note = poSelectedVariants[item].note
            afterQty = poSelectedVariants[item].afterQty
            
            guard reqQty != "" else {
                ToastClass.sharedToast.showToast(message: "Add Quantity for all variants",
                                                 font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                return
            }
            
            let pos = AddPO(product_id: p_id, variant_id: var_id, required_qty: reqQty,
                            cost_per_item: cost, total_pricing: total, upc: upc,
                            note: note, after_qty: afterQty)
            
            smallAdd.append(pos)
        }
        
        guard smallAdd.count != 0 else {
            ToastClass.sharedToast.showToast(message: "Please Select Atleast One Product Variant",
                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            return
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
        
        tableview.isHidden = true
        loadingIndicator.isAnimating = true
        
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
    
    func deletePO(save: Int) {
        
        let po_id = bigDetails?.id ?? ""
        let v_id = vendorSelect?.id ?? ""
        
        if deleteIds.count > 0 {
            deleteItems(delete: deleteIds, po_id: po_id, v_id: v_id) {
                if self.mode == "edit" && save == 0 {
                    self.updateDraft()
                }
                else {
                    self.updatePO()
                }
            }
        }
        else {
            if self.mode == "edit" && save == 0 {
                self.updateDraft()
            }
            else {
                self.updatePO()
            }
        }
    }
    
    func updatePO() {
        
        let m_id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        let emp_id = UserDefaults.standard.string(forKey: "emp_po_id") ?? ""
        var final_json = ""
        
        let v_id = vendorSelect?.id ?? ""
        let i_d = vendorSelect?.issue_date ?? ""
        let s_d = vendorSelect?.stock_date ?? ""
        let r_f = vendorSelect?.reference ?? ""
        let v_e = vendorSelect?.vendor_email ?? ""
        
        var upc = ""
        var var_id = ""
        var p_id = ""
        var reqQty = ""
        var cost = ""
        var total = ""
        var note = ""
        var afterQty = ""
        var status = ""
        var order_item_id = ""
        
        var smallAdd = [EditPO]()
        
        if poSelectedVariants.count == 0 {
            
            ToastClass.sharedToast.showToast(message: "Please Select Atleast One Product Variant", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
        }
        else {
            
            for item in 0..<poSelectedVariants.count {
                
                p_id = poSelectedVariants[item].po.id
                
                if poSelectedVariants[item].po.isvarient == "1" {
                    upc = poSelectedVariants[item].po.var_upc
                    var_id = poSelectedVariants[item].po.var_id
                }
                else {
                    upc = poSelectedVariants[item].po.upc
                    var_id = ""
                }
                
                reqQty = poSelectedVariants[item].reqQty
                cost = poSelectedVariants[item].cost
                total = poSelectedVariants[item].total
                note = poSelectedVariants[item].note
                afterQty = poSelectedVariants[item].afterQty
                status = poSelectedVariants[item].status
                order_item_id = poSelectedVariants[item].orderItem
                
                guard reqQty != "" else {
                    ToastClass.sharedToast.showToast(message: "Add Quantity for all variants",
                                                     font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                    return
                }
                
                let pos = EditPO(order_item_id: order_item_id, product_id: p_id, variant_id: var_id,
                                 required_qty: reqQty, recieved_status: status, cost_per_item: cost,
                                 total_pricing: total, upc: upc, note: note, after_qty: afterQty)
                
                smallAdd.append(pos)
            }
            
            guard smallAdd.count != 0 else {
                ToastClass.sharedToast.showToast(message: "Please Select Atleast One Product Variant",
                                                 font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                return
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
            let upd_at = bigDetails?.updated_at ?? ""
            
            
            tableview.isHidden = true
            loadingIndicator.isAnimating = true
            
            ApiCalls.sharedCall.updatePO(merchant_id: m_id, admin_id: m_id, po_id: po_id, employee_id: emp_id, vendor_id: v_id,
                                         issue_date: i_d, stock_date: s_d, reference: r_f,
                                         vendor_email: v_e, order_items: final_json, is_draft: "0",
                                         received_status: r_status, updated_at: upd_at) { isSuccess, responseData in
                
                if isSuccess {
                    
                    ToastClass.sharedToast.showToast(message: "PO Updated Successfully", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                    
                    if self.mode == "edit" {
                        self.home()
                    }
                    else {
                        self.dismiss(animated: true) {
                            self.saveDelegate?.savePOItem(save: [], mode: "")
                        }
                    }
                }
                else {
                    print("Api Error")
                }
            }
        }
    }
    
    func deleteItems(delete: [String], po_id: String, v_id: String, completion: @escaping () -> Void) {
        
        let m_id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        var del_ids = delete
        let id = del_ids.removeFirst()
        
        ApiCalls.sharedCall.deletePOItem(merchant_id: m_id, po_item_id: id, vendor_id: v_id) { isSuccess, _ in
            
            DispatchQueue.main.async {
                if isSuccess {
                    if del_ids.count > 0 {
                        self.deleteItems(delete: del_ids, po_id: po_id, v_id: v_id, completion: completion)
                    }
                    else {
                        completion()
                    }
                }
                else {
                    print("Failed to delete item")
                    completion()
                }
            }
        }
    }
    
    @IBAction func deleteClickBtn(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Alert", message: "Are you sure you want to delete this item?", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "No", style: .cancel)
        
        let okAction = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction!) in
            
            let id = self.poSelectedVariants[sender.tag].orderItem
            
            if id == "" {
            }
            else {
                self.deleteIds.append(id)
            }
            self.poSelectedVariants.remove(at: sender.tag)
            self.tableview.reloadData()
        }
        
        alertController.addAction(cancel)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion:nil)
    }
    
    
    @IBAction func backBtnClick(_ sender: UIButton) {
        
        if mode == "add" {
            navigationController?.popViewController(animated: true)
        }
        else {
            
            let alertController = UIAlertController(title: "Alert", message: "Are you sure you want to Exit?", preferredStyle: .alert)
            
            let cancel = UIAlertAction(title: "No", style: .cancel)
            
            let okAction = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction!) in
                
                if self.mode == "edit" {
                    self.navigationController?.popViewController(animated: true)
                }
                else {
                    self.dismiss(animated: true) {
                        //self.saveDelegate?.savePOItem(save: self.poSelectedVariants, mode: "join")
                    }
                }
            }
            
            alertController.addAction(cancel)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion:nil)
        }
    }
    
    
    @IBAction func homeBtnClick(_ sender: UIButton) {
        
        if mode == "add" || mode == "edit" {
            var destiny = 0
            
            let viewcontrollerArray = navigationController?.viewControllers
            
            if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is HomeViewController }) {
                destiny = destinationIndex
            }
            
            navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
        }
        else {
            dismiss(animated: true)
        }
    }
}

extension ItemsPOViewController: POSelectDelegate {
    
    func didSelectVariant(variant: [VariantPOModel]) {
        
        if variant.count > 0 {
            
            poSelectedVariants = variant
            tableview.reloadData()
        }
    }
}

extension ItemsPOViewController: ChangeVendorDelegate {
    
    func didChangeVendor(vendor: VendorPO) {
        vendorSelect = vendor
        vendorName.text = vendor.name
    }
}

extension ItemsPOViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let index = IndexPath(row: textField.tag, section: 0)
        
        let cell = tableview.cellForRow(at: index) as! ItemsPOTableViewCell
        
        if textField == cell.qtyTextField {
            
            let req_qty = cell.qtyTextField.text ?? ""
            let qty = poSelectedVariants[textField.tag].po.quantity
            
            let cost = cell.costPerTextField.text ?? ""
            
            let cost_str = cost.replacingOccurrences(of: "$", with: "")
            
            let req_int = Int(req_qty) ?? 0
            let qty_int = Int(qty) ?? 0
            
            let req_doub = Double(req_qty) ?? 0.0
            let cost_doub = Double(cost_str) ?? 0.0
            
            let qtyAfter = qty_int + req_int
            let total = req_doub * cost_doub
            
            cell.qtyAfter.text = "Qty After: \(qtyAfter)"
            
            let totoal = String(format: "%.02f", roundOf(item: "\(total)"))
            
            cell.total.text = "Total: $\(totoal)"
            poSelectedVariants[textField.tag].total = "\(totoal)"
            
            poSelectedVariants[textField.tag].reqQty = req_qty
            poSelectedVariants[textField.tag].afterQty = "\(qtyAfter)"
        }
        else if textField == cell.costPerTextField {
            
            let req_qty = cell.qtyTextField.text ?? ""
            let cost = cell.costPerTextField.text ?? ""
            
            let cost_str = cost.replacingOccurrences(of: "$", with: "")
            
            let req_doub = Double(req_qty) ?? 0.0
            let cost_doub = Double(cost_str) ?? 0.0
            
            let total = req_doub * cost_doub
            
            poSelectedVariants[textField.tag].cost = cost_str
            
            let totoal = String(format: "%.02f", roundOf(item: "\(total)"))
            
            cell.total.text = "Total: $\(totoal)"
            poSelectedVariants[textField.tag].total = "\(totoal)"
        }
        else {
            let note = cell.noteField.text ?? ""
            poSelectedVariants[textField.tag].note = note
        }
    }
    
    @objc func updateTextField(textField: UITextField) {
        
        var cleanedAmount = ""
        
        for character in textField.text ?? "" {
            if character.isNumber {
                cleanedAmount.append(character)
            }
        }
        
        if isSymbolOnRight {
            cleanedAmount = String(cleanedAmount.dropLast())
        }
        
        if Double(cleanedAmount) ?? 00000 > 99999999 {
            cleanedAmount = String(cleanedAmount.dropLast())
        }
        
        let amount = Double(cleanedAmount) ?? 0.0
        let amountAsDouble = (amount / 100.0)
        var amountAsString = String(amountAsDouble)
        if cleanedAmount.last == "0" {
            amountAsString.append("0")
        }
        textField.text = "$\(amountAsString)"
        
        if textField.text == "000" {
            textField.text = ""
        }
    }
    
    @objc func updateText(textField: UITextField) {
        
        let index = IndexPath(row: textField.tag, section: 0)
        let cell = tableview.cellForRow(at: index) as! ItemsPOTableViewCell
        
        var updatetext = textField.text ?? ""
        
        if textField == cell.qtyTextField {
            
            if updatetext.count > 6 {
                updatetext = String(updatetext.dropLast())
            }
        }
        activeTextField.text = updatetext
    }
    
    func roundOf(item : String) -> Double {
        
        var itemDollar = ""
        
        if item.starts(with: "$") || item.starts(with: "-") {
            itemDollar = String(item.dropFirst())
            let doub = Double(itemDollar) ?? 0.00
            let div = (100 * doub) / 100
            return div
        }
        else {
            let doub = Double(item) ?? 0.00
            let div = (100 * doub) / 100
            print(div)
            return div
        }
    }
    
    private func setupUI() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor
                .constraint(equalTo: tableview.centerXAnchor, constant: 0),
            loadingIndicator.centerYAnchor
                .constraint(equalTo: tableview.centerYAnchor),
            loadingIndicator.widthAnchor
                .constraint(equalToConstant: 40),
            loadingIndicator.heightAnchor
                .constraint(equalTo: self.loadingIndicator.widthAnchor)
        ])
    }
}
    
extension ItemsPOViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return poSelectedVariants.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ItemsPOTableViewCell
        
        let item = poSelectedVariants[indexPath.row]
        
        if mode == "add" {
            
            cell.name.text = item.po.title
            
            cell.qtyTextField.text = ""
            
            if item.po.isvarient == "1" {
                cell.upc.text = "UPC: \(item.po.var_upc)"
            }
            else {
                cell.upc.text = "UPC: \(item.po.upc)"
            }
            
            cell.costPerTextField.text = "$\(item.cost)"
            
            cell.noteField.text = item.note
            
            cell.qtyAfter.text = "Qty After:"
            cell.total.text = "Total:"
        }
        
        else {
            
            cell.name.text = item.po.title
            
            if item.po.isvarient == "1" {
                cell.upc.text = "UPC: \(item.po.var_upc)"
            }
            else {
                cell.upc.text = "UPC: \(item.po.upc)"
            }
            
            cell.costPerTextField.text = "$\(item.cost)"
            
            let status = item.status
            
            if status == "0" || status == "1" {
                cell.qtyTextField.isEnabled = true
                cell.costPerTextField.isEnabled = true
                cell.noteField.isEnabled = true
                cell.deleteBtn.isHidden = false
            }
            else {
                cell.qtyTextField.isEnabled = false
                cell.costPerTextField.isEnabled = false
                cell.noteField.isEnabled = false
                cell.deleteBtn.isHidden = true
            }
            
            cell.qtyTextField.text = item.reqQty
            
            cell.noteField.text = item.note
            
            cell.qtyAfter.text = "Qty After: \(item.afterQty)"
            cell.total.text = "Total: $\(item.total)"
        }
        
        cell.qtyTextField.borderStyle = .none
        cell.qtyTextField.delegate = self
        cell.qtyTextField.keyboardType = .numberPad
        cell.qtyTextField.addTarget(self, action: #selector(updateText), for: .editingChanged)
        
        cell.qtyView.layer.borderColor = UIColor(hexString: "#D0D0D0").cgColor
        cell.qtyView.layer.borderWidth = 1
        cell.qtyView.layer.cornerRadius = 10
        
        cell.costPerTextField.borderStyle = .none
        cell.costPerTextField.delegate = self
        cell.costPerTextField.keyboardType = .numberPad
        cell.costPerTextField.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        
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
        cell.qtyAfter.tag = indexPath.row
        cell.total.tag = indexPath.row
        
        return cell
        
    }
}
