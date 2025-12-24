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
    var saveSelectedVariants = [VariantPOModel]()
    var id = ""
    
    private var isSymbolOnRight = false
    
//    var checkArr = [String]()
    
//    var reqQtyArr = [String]()
//    var pendQtyArr = [String]()
//    var costArr = [String]()
//    var noteArr = [String]()
//    var afterQtyArr = [String]()
//    var totalArr = [String]()
//    
//    var orderItemArr = [String]()
//    var statusArr = [String]()
    
//    var fullAddedPOList = [InventoryVariant]()
//    var fullAddedReqQtyArr = [String]()
//    
//    var fullAddedCostArr = [String]()
//    var fullAddedNoteArr = [String]()
//    var fullAddedAfterQtyArr = [String]()
//    var fullAddedTotalArr = [String]()
//    
//    var fullAddedOrderItemArr = [String]()
//    var fullAddedStatusArr = [String]()
    
    var vendorSave: VendorPO?
    var bigDetails: PODetails?
    
    var activeTextField = UITextField()
        
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
            
//            reqQtyArr.append(poitem.required_qty)
//            pendQtyArr.append(poitem.pending_qty)
//            costArr.append(poitem.cost_per_item)
//            noteArr.append(poitem.note)
//            afterQtyArr.append(poitem.after_qty)
//            totalArr.append(poitem.total_pricing)
//            
//            orderItemArr.append(poitem.id)
//            statusArr.append(poitem.recieved_status)
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
        var smallPoList = [VariantPOModel]()
        
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
        
        for variant in smallVarList {

            let pos: Int?

            if variant.isvarient == "1" {
                pos = poVariants.firstIndex(where: {
                    $0.variant_id == variant.var_id
                })
            } else {
                pos = poVariants.firstIndex(where: {
                    $0.product_id == variant.id
                })
            }

            // Make sure we found a match
            guard let index = pos else {
                print("No PO item found for variant:", variant.id)
                continue
            }

            let poItem = poVariants[index]

            var item = VariantPOModel(po: variant, isSelect: true, reqQty: poItem.required_qty,
                cost: poItem.cost_per_item, note: poItem.note, afterQty: poItem.after_qty,
                total: poItem.total_pricing, orderItem: poItem.id, status: poItem.recieved_status,
                pendingQty: poItem.pending_qty, check: "")
            
            if poItem.recieved_status == "0" || poItem.recieved_status == "1" {
                item.check = "1"
            }
            else {
                item.check = "0"
            }

            smallPoList.append(item)
        }

        
        saveSelectedVariants = smallPoList
        
//        saveSelectedVariants.append(contentsOf: fullAddedPOList)
//        reqQtyArr.append(contentsOf: fullAddedReqQtyArr)
//        costArr.append(contentsOf: fullAddedCostArr)
//        noteArr.append(contentsOf: fullAddedNoteArr)
//        afterQtyArr.append(contentsOf: fullAddedAfterQtyArr)
//        totalArr.append(contentsOf: fullAddedTotalArr)
//        
//        orderItemArr.append(contentsOf: fullAddedOrderItemArr)
//        statusArr.append(contentsOf: fullAddedStatusArr)
        
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
            saveSelectedVariants[sender.tag].check = "0"
        }
        else {
            sender.setImage(UIImage(named: "check inventory"), for: .normal)
            saveSelectedVariants[sender.tag].check = "1"
        }
    }
    
    
    @IBAction func editBtnClick(_ sender: UIButton) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "itemspo") as! ItemsPOViewController
        
        vc.poSelectedVariants = saveSelectedVariants
        
        vc.bigDetails = bigDetails
        
        vc.vendorSelect = vendorSave
    
        vc.mode = "saveedit"
        
        vc.saveDelegate = self
        
        present(vc, animated: true)
    }
    
    
    @IBAction func receiveBtnClick(_ sender: UIButton) {
        
        let m_id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        var final_json = ""
        
        var pendingQty = ""
        var afterQty = ""
        var order_item_id = ""
        
        var smallAdd = [ReceivePO]()
        
        for item in 0..<saveSelectedVariants.count {
            
            if saveSelectedVariants[item].check == "0" {
                continue
            }
            else {
                
                pendingQty = saveSelectedVariants[item].pendingQty
                afterQty = saveSelectedVariants[item].afterQty
                order_item_id = saveSelectedVariants[item].orderItem
                
                guard pendingQty != "" else {
                    ToastClass.sharedToast.showToast(message: "Add Quantity for all variants",
                                                     font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                    return
                }
                
                let pos = ReceivePO(po_item_id: order_item_id, recieved_qty: pendingQty, after_qty: afterQty)
                
                smallAdd.append(pos)
            }
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
        
        ApiCalls.sharedCall.receivePO(merchant_id: m_id, admin_id: m_id, po_id: id, po_items: final_json, recieve_date_time: "2025-12-25 21:12:33") { isSuccess, responseData in
            
            if isSuccess {
                
                ToastClass.sharedToast.showToast(message: "PO Updated Successfully", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                self.home()
            }
            else {
                print("Api Error")
            }
        }
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

extension SavePOViewController: POSelectDelegate {
    
    func didSelectVariant(variant: [VariantPOModel]) {
        
        if variant.count > 0 {
            
            saveSelectedVariants = variant
//            reqQtyArr = revreqQtyArr
//            costArr = revCostArr
//            noteArr = revNoteArr
//            afterQtyArr = revAfterQtyArr
//            totalArr = revTotalArr
//            orderItemArr = revOrderItemArr
//            statusArr = revStatusArr
            
            tableview.reloadData()
        }
        else {
            
        }
    }
}

extension SavePOViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let index = IndexPath(row: textField.tag, section: 0)
        
        let cell = tableview.cellForRow(at: index) as! ItemsPOTableViewCell
        
        if textField == cell.toReceiveField {
            
            let req_qty = saveSelectedVariants[textField.tag].reqQty
            let torec = cell.toReceiveField.text ?? ""
            
            let req_int = Int(req_qty) ?? 0
            let torec_int = Int(torec) ?? 0
            
            let afterQty = saveSelectedVariants[textField.tag].afterQty

            let afterQty_int = Int(afterQty) ?? 0
            
            let diff = req_int - torec_int
            
            if diff == 0 {
            
            }
            else {
                let ans = afterQty_int - diff
                cell.qtyAfter.text = "Qty After: \(ans)"
            }
            
            let pending = cell.toReceiveField.text ?? ""
            saveSelectedVariants[textField.tag].pendingQty = pending
        }
        else if textField == cell.costPerTextField {
            
            let req_qty = cell.qtyValue.text ?? ""
            let cost = cell.costPerTextField.text ?? ""
            
            let cost_str = cost.replacingOccurrences(of: "$", with: "")
            
            let req_doub = Double(req_qty) ?? 0.0
            let cost_doub = Double(cost_str) ?? 0.0
            
            let total = req_doub * cost_doub
            
            saveSelectedVariants[textField.tag].cost = cost_str
            
            let totoal = String(format: "%.02f", roundOf(item: "\(total)"))
            
            cell.total.text = "Total: $\(totoal)"
            saveSelectedVariants[textField.tag].total = "\(totoal)"
        }
        else if textField == cell.noteField {
            let note = cell.noteField.text ?? ""
            saveSelectedVariants[textField.tag].note = note
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
        
        if textField == cell.toReceiveField {
            
            let req_qty = saveSelectedVariants[textField.tag].reqQty
            let torec = updatetext
            
            let req_int = Int(req_qty) ?? 0
            let torec_int = Int(torec) ?? 0
            
            if torec_int > req_int || updatetext == "0" {
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
}

extension SavePOViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return saveSelectedVariants.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ItemsPOTableViewCell
        
        let item = saveSelectedVariants[indexPath.row]
        
        cell.name.text = item.po.title
                
        if item.po.isvarient == "1" {
            cell.upc.text = "UPC: \(item.po.var_upc)"
        }
        else {
            cell.upc.text = "UPC: \(item.po.upc)"
        }
                
        cell.deleteBtn.setImage(UIImage(named: "check inventory"), for: .normal)
        
        cell.costPerTextField.text = "$\(item.cost)"
        
        cell.toReceiveField.text = "\(item.pendingQty)"
        
        cell.qtyValue.text = item.reqQty
        
        if bigDetails?.is_void == "1" {
            cell.deleteBtn.isHidden = true
            cell.deleteBtn.isEnabled = false
        }
        else {
            if item.check == "1" {
                cell.deleteBtn.isHidden = false
                cell.deleteBtn.isEnabled = true
            }
            else {
                cell.deleteBtn.isHidden = true
                cell.deleteBtn.isEnabled = false
            }
        }
        
        cell.deleteBtn.tag = indexPath.row
                                
        cell.noteField.text = item.note
        
        cell.qtyAfter.text = "Qty After: \(item.afterQty)"
        cell.total.text = "Total: $\(item.total)"
        
//        cell.qtyTextField.borderStyle = .none
//        cell.qtyTextField.delegate = self
//        cell.qtyTextField.keyboardType = .numberPad
//        cell.qtyTextField.addTarget(self, action: #selector(updateText), for: .editingChanged)
        
        cell.toReceiveField.borderStyle = .none
        cell.toReceiveField.delegate = self
        cell.toReceiveField.keyboardType = .numberPad
        cell.toReceiveField.addTarget(self, action: #selector(updateText), for: .editingChanged)
        
        cell.toReceiveView.layer.borderColor = UIColor(hexString: "#D0D0D0").cgColor
        cell.toReceiveView.layer.borderWidth = 1
        cell.toReceiveView.layer.cornerRadius = 10
        
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
        cell.qtyValue.tag = indexPath.row
        cell.noteField.tag = indexPath.row
        cell.qtyAfter.tag = indexPath.row
        cell.total.tag = indexPath.row
        cell.toReceiveField.tag = indexPath.row
        
        return cell
        
    }
    
}
