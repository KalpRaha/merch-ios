//
//  SavePOViewController.swift
//  QuickveeApp
//
//  Created by Kalpesh on 06/08/25.
//

import UIKit

protocol SavePOViewControllerDelegate: AnyObject {
    func savePOItem()
}

class SavePOViewController: UIViewController {
    
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var issueDate: UILabel!
    
    @IBOutlet weak var stack: UIStackView!
    @IBOutlet weak var stackHeight: NSLayoutConstraint!
    
    @IBOutlet weak var editPOBtn: UIButton!
    @IBOutlet weak var receiveBtn: UIButton!
    
    @IBOutlet weak var voidLbl: UILabel!
    
    @IBOutlet weak var poTitile: UILabel!
    
    var poVariants = [POItems]()
    var variantList = [InventoryVariant]()
    var saveSelectedVariants = [InventoryVariant]()
    var id = ""
    
    private var isSymbolOnRight = false
    
    var checkArr = [String]()
    
    var reqQtyArr = [String]()
    var pendQtyArr = [String]()
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
    
    var vendorSave: VendorPO?
    var bigDetails: PODetails?
        
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.showsVerticalScrollIndicator = false
        
        editPOBtn.layer.cornerRadius = 10
        receiveBtn.layer.cornerRadius = 10
        
        editPOBtn.layer.borderWidth = 1
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(voidClick))
        voidLbl.addGestureRecognizer(tap)
        tap.numberOfTapsRequired = 1
        voidLbl.isUserInteractionEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
        setupApi()
    }
    
    func setupApi() {
        
        loadingIndicator.isAnimating = true
        tableview.isHidden = true
        
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
        
        if details.is_void == "1" || details.received_status == "2" {
            stack.isHidden = true
            stackHeight.constant = 0
            voidLbl.text = ""
            voidLbl.isHidden = true
        }
        else {
            stack.isHidden = false
            stackHeight.constant = 45
            voidLbl.text = "Void"
            voidLbl.isHidden = false
        }
        
        bigDetails = details
        
        vendorSave = VendorPO(id: bigDetails?.vendor_id ?? "", name: bigDetails?.vendor_name ?? "",
                                   issue_date: bigDetails?.issued_date ?? "", stock_date: bigDetails?.stock_date ?? "",
                                   reference: bigDetails?.reference ?? "", vendor_email: bigDetails?.email ?? "")
        
        poTitile.text = "\(details.vendor_name) - \(details.po_number)"
        
        let date = details.issued_date
        
        let upd = ToastClass.sharedToast.setCouponsDateFormat(dateStr: date)
        issueDate.text = upd
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
            pendQtyArr.append(poitem.pending_qty)
            costArr.append(poitem.cost_per_item)
            noteArr.append(poitem.note)
            afterQtyArr.append(poitem.after_qty)
            totalArr.append(poitem.total_pricing)
            
            orderItemArr.append(poitem.id)
            statusArr.append(poitem.recieved_status)
            
            if poitem.recieved_status == "0" || poitem.recieved_status == "1" {
                checkArr.append("1")
            }
            else {
                checkArr.append("0")
            }
        }
        poVariants = smallitems
        
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
                
                if poVariants.contains(where: {$0.variant_id == variant.var_id}) {
                    smallVarList.append(variant)
                }
            }
            else {
                if poVariants.contains(where: {$0.product_id == variant.id}) {
                    smallVarList.append(variant)
                }
            }
        }
        
        saveSelectedVariants = smallVarList
        
        saveSelectedVariants.append(contentsOf: fullAddedPOList)
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
    
    @objc func voidClick() {
        
        let m_id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        tableview.isHidden = true
        loadingIndicator.isAnimating = true
        
        ApiCalls.sharedCall.voidPO(merchant_id: m_id, admin_id: m_id, po_id: id) { isSuccess, responseData in
            
            if isSuccess {
                
                guard responseData["status"] as! Int == 1 else {
                    self.tableview.isHidden = true
                    self.loadingIndicator.isAnimating = true
                    return
                }
                
                ToastClass.sharedToast.showToast(message: "PO Void Successfully", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                self.tableview.isHidden = false
                self.loadingIndicator.isAnimating = false
                self.home()
            }
            else {
                print("Api Error")
            }
        }
    }
    
    
    @IBAction func checkBtnClick(_ sender: UIButton) {
        
        if sender.imageView?.image == UIImage(named: "check inventory") {
            sender.setImage(UIImage(named: "uncheck inventory"), for: .normal)
        }
        else {
            sender.setImage(UIImage(named: "check inventory"), for: .normal)
        }
    }
    
    
    @IBAction func editBtnClick(_ sender: UIButton) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "itemspo") as! ItemsPOViewController
        
        vc.poSelectedVariants = saveSelectedVariants
        vc.reqQtyArr = reqQtyArr
        vc.costArr = costArr
        vc.noteArr = noteArr
        vc.afterQtyArr = afterQtyArr
        vc.totalArr = totalArr
        vc.orderItemArr = orderItemArr
        vc.statusArr = statusArr
        
        vc.bigDetails = bigDetails
        
        vc.vendorSelect = vendorSave
    
        vc.mode = "saveedit"
        
        vc.saveDelegate = self
        
        present(vc, animated: true)
    }
    
    
    @IBAction func receiveBtnClick(_ sender: UIButton) {
        
        
//        ApiCalls.sharedCall.receivePO(merchant_id: <#T##String#>, admin_id: <#T##String#>, po_id: <#T##String#>, issue_date: <#T##String#>, stock_date: <#T##String#>, reference: <#T##String#>, vendor_email: <#T##String#>, order_items: <#T##String#>, is_draft: <#T##String#>, received_status: <#T##String#>, updated_at: <#T##String#>, completion: <#T##(Bool, [String : Any]) -> ()#>)
        
//        {"merchant_id":"VIK175871CA","admin_id":"VIK175871CA","vendor_id":"883","vendor_name":"Drew","po_id":"9188","po_number":"PO0068","product_id":"1480611","variant_id":"0","required_qty":"10","recieved_qty":"10","recieved_status":"0","pending_qty":"10","cost_per_item":"10.00","total_pricing":"100","upc":"00002837","note":"","created_at":"2025-08-25 17:15:22","updated_at":"2025-08-25 17:17:42","after_qty":15,"zoho_invoice_id":null,"product_title":"Juicy J Love 69 Dispo 7k","product_qty":"5","variant_title":null,"variant_qty":null,"item_fullname":"Juicy J Love 69 Dispo 7k","item_qty":"5","newPendingQty":"10","newReceivedQty":"10","toReceiveQty":"10","isChecked":true,"po_item_id":"115423"}
        
        
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
    
    func home() {
        
        var destiny = 0
        
        let viewcontrollerArray = navigationController?.viewControllers
        
        if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is InventoryViewController }) {
            destiny = destinationIndex
        }
        
        navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
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

extension SavePOViewController: SavePOViewControllerDelegate {
    
    func savePOItem() {
        navigationController?.popViewController(animated: true)
    }
}

extension SavePOViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let index = IndexPath(row: textField.tag, section: 0)
        
        let cell = tableview.cellForRow(at: index) as! ItemsPOTableViewCell
        
        if textField == cell.qtyTextField {
            
            let req_qty = cell.qtyTextField.text ?? ""
            let qty = saveSelectedVariants[textField.tag].quantity
            
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
            totalArr[textField.tag] = "\(totoal)"
            
            reqQtyArr[textField.tag] = req_qty
            afterQtyArr[textField.tag] = "\(qtyAfter)"
        }
        else if textField == cell.costPerTextField {
            
            let req_qty = cell.qtyTextField.text ?? ""
            let cost = cell.costPerTextField.text ?? ""
            
            let cost_str = cost.replacingOccurrences(of: "$", with: "")
            
            let req_doub = Double(req_qty) ?? 0.0
            let cost_doub = Double(cost_str) ?? 0.0
            
            let total = req_doub * cost_doub
            
            costArr[textField.tag] = cost_str
            
            let totoal = String(format: "%.02f", roundOf(item: "\(total)"))
            
            cell.total.text = "Total: $\(totoal)"
            totalArr[textField.tag] = "\(totoal)"
        }
        else {
            let note = cell.noteField.text ?? ""
            noteArr[textField.tag] = note
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
}

extension SavePOViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return saveSelectedVariants.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ItemsPOTableViewCell
        
        let item = saveSelectedVariants[indexPath.row]
        
        cell.name.text = item.title
                
        if item.isvarient == "1" {
            cell.upc.text = "UPC: \(item.var_upc)"
        }
        else {
            cell.upc.text = "UPC: \(item.upc)"
        }
                
        cell.deleteBtn.setImage(UIImage(named: "check inventory"), for: .normal)
        
        cell.costPerTextField.text = "$\(costArr[indexPath.row])"
        
        cell.qtyTextField.text = pendQtyArr[indexPath.row]
        
        if checkArr[indexPath.row] == "1" {
            cell.deleteBtn.isHidden = false
            cell.deleteBtn.isEnabled = true
        }
        else {
            cell.deleteBtn.isHidden = true
            cell.deleteBtn.isEnabled = false
        }
        
        cell.deleteBtn.tag = indexPath.row
                                
        cell.noteField.text = noteArr[indexPath.row]
        
        cell.qtyAfter.text = "Qty After: \(afterQtyArr[indexPath.row])"
        cell.total.text = "Total: $\(totalArr[indexPath.row])"
        
        cell.qtyTextField.borderStyle = .none
        cell.qtyTextField.delegate = self
        cell.qtyTextField.keyboardType = .numberPad
        
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
