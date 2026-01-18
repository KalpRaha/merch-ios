//
//  SavePOViewController.swift
//  QuickveeApp
//
//  Created by Kalpesh on 06/08/25.
//

import UIKit

protocol SavePOViewControllerDelegate: AnyObject {
    func savePOItem(save: [VariantPOModel], mode: String)
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
    
    @IBOutlet weak var stockDate: UILabel!
    
    @IBOutlet weak var threeBtn: UIButton!
    
    @IBOutlet weak var menu: UIView!
    
    @IBOutlet weak var emailLbl: UILabel!
    
    @IBOutlet weak var vendorEmail: UILabel!
    
    var poVariants = [POItems]()
    var variantList = [InventoryVariant]()
    var saveSelectedVariants = [VariantPOModel]()
    var id = ""
    
    private var isSymbolOnRight = false
    
    var vendorSave: VendorPO?
    var bigDetails: PODetails?
    
    var activeTextField = UITextField()
    
    var poItemEmail = [POItemEmail]()
    var itemHeaderEmail = ["ITEM NAME", "UPC", "QTY", "PRICE", "TOTAL", "NOTE"]
        
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
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(emailClick))
        emailLbl.addGestureRecognizer(tap1)
        tap1.numberOfTapsRequired = 1
        emailLbl.isUserInteractionEnabled = true
        
        menu.isHidden = true
        menu.layer.cornerRadius = 10
        menu.layer.shadowColor =  UIColor.lightGray.cgColor
        menu.layer.shadowOpacity = 1
        menu.layer.shadowRadius = 3
        menu.layer.shadowOffset = CGSize.zero
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
        
        if details.is_void == "1" {
            stack.isHidden = true
            stackHeight.constant = 0
            voidLbl.text = "Void"
            voidLbl.textColor = UIColor(named: "borderRed")
        }
        else if details.received_status == "2" {
            stack.isHidden = true
            stackHeight.constant = 0
            voidLbl.text = "Received"
            voidLbl.textColor = UIColor(named: "Compeletetext")
        }
        else {
            stack.isHidden = false
            stackHeight.constant = 45
            voidLbl.text = "Void"
            voidLbl.textColor = UIColor(named: "borderRed")
        }
        
        bigDetails = details
        
        vendorSave = VendorPO(id: bigDetails?.vendor_id ?? "", name: bigDetails?.vendor_name ?? "",
                                   issue_date: bigDetails?.issued_date ?? "", stock_date: bigDetails?.stock_date ?? "",
                                   reference: bigDetails?.reference ?? "", vendor_email: bigDetails?.email ?? "")
        
        poTitile.text = "\(details.vendor_name) - \(details.po_number)"
        
        let date = details.issued_date
        let dates = details.stock_date
        let email = details.email
        
        if email == "" {
            vendorEmail.text = ""
        }
        else {
            vendorEmail.text = "Vendor Email: \(email)"
        }
        
        let upd = ToastClass.sharedToast.setCouponsDateFormat(dateStr: date)
        issueDate.text = "Issue Date: \(upd)"
        
        if dates == "0000-00-00" {
            stockDate.text = ""
        }
        else {
            let upds = ToastClass.sharedToast.setCouponsDateFormat(dateStr: dates)
            stockDate.text = "Stock Date: \(upds)"
        }
        getItems(items: details.order_items)
    }
    
    func getItems(items: Any) {
        
        var smallitems = [POItems]()
        var poSmallItemEmail = [POItemEmail]()
        
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
            poSmallItemEmail.append(POItemEmail(name: "\(item["item_fullname"] ?? "")", upc: "\(item["upc"] ?? "")",
                                                qty: "\(item["required_qty"] ?? "")", price: "\(item["cost_per_item"] ?? "")",
                                                total: "\(item["total_pricing"] ?? "")", note: "\(item["note"] ?? "")"))
        }
        poVariants = smallitems
        poItemEmail = poSmallItemEmail
        
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
        
        if voidLbl.text == "Void" && bigDetails?.is_void == "0" {
            
            let alertController = UIAlertController(title: "Alert", message: "Are you sure you want to void this Purchase Order?", preferredStyle: .alert)
            
            let cancel = UIAlertAction(title: "No", style: .cancel)
            
            let okAction = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction!) in
                
                self.voidApi()
            }
            
            alertController.addAction(cancel)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion:nil)
        }
    }
    
    func emailHtml(htmlString: String) -> String {
        
        let storeName = UserDefaults.standard.string(forKey: "store_name") ?? ""
        let storeAddress = "230 Sterling dr, Tracy, CA 95391"
        
        let date = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        let currentDate = dateFormatter.string(from: date)
        
        
        let htmlType = """
        <!DOCTYPE html>
        <html>
        <head>
        <title>\(storeName)</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
        <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
        </head>
        <body>
        <table border="0" width="100%" cellpadding="0" cellspacing="0" align="center" style="max-width:600px;margin:auto;border-spacing:0;border-collapse:collapse;background:white;border-radius:0px 0px 10px 10px;font-family:sans-serif;">
        <tbody>
        <tr>
        <td style="text-align:center;border-collapse:collapse;background:#fff;border-radius:10px 10px 0px 0px;color:white;height:70px;background-color:#0a64f9;padding:10px">
        <img src="https://production.quickvee.net/images/maillogo.png" width="100" class="CToWUd">
        </td>
        </tr>
        <tr>
        <td style="background:#fafafa;">
        <table border="0" width="100%" cellpadding="0" cellspacing="0" align="center" style="max-width:560px;border-spacing:0;border-collapse:collapse;margin:20px auto;width:560px;font-size:16px;">
        <tbody>
        <tr>
        <td>
        <h5 style="font-size:1.25rem">\(storeName)</h5>
        </td>
        <td style="text-align:right;">
        <h5 style="font-size:1.25rem">Purchase Order</h5>
        </td>
        </tr>
        </tbody>
        </table>
        </td>
        </tr>
        <tr>
        <td style="background:#fafafa;">
        <table border="0" width="100%" cellpadding="0" cellspacing="0" align="center" style="max-width:560px;border-spacing:0;border-collapse:collapse;margin:20px auto;width:560px;font-size:16px;">
        <tbody>
        <tr>
        <td>
        <b>Ship/Bill to</b>
        </td>
        <td>
        <p style="margin-bottom:0px;"><b>Order Number</b> <span style="float:right;">\(id)</span></p>
        </td>
        </tr>
        <tr>
        <tr>
        <td>
        \(storeName)
        </td>
        <td>
        <p style="margin-bottom:0px;"><b>Issue Date </b> <span style="float:right;">\(currentDate)</span></p>
        </td>
        </tr>
        <tr>
        <td>
        230 Sterling Dr Suite 260, Tracy, CA 95391
        </td>
        </tr>
        <tr>
        <td>
        </td>
        </tr>
        </tbody>
        </table>
        </td>
        </tr>
        <tr>
        <td style="background:#fafafa;">
        \(htmlString)
        </td>
        </tr>
        <tr>
        <td style="background:#fafafa;">
        <table border="0" width="100%" cellpadding="0" cellspacing="0" align="center" style="max-width:560px;border-spacing:0;border-collapse:collapse;margin:20px auto;width:560px;">
        <tbody>
        <tr>
        <td><b>Supplier,</b></td>
        </tr>
        <tr>
        <td>Nihal</td>
        </tr>
        </tbody>
        </table>
        </td>
        </tr>
        </tbody>
        </table>
        </body>
        </html>
        """
        
        return htmlType
    }
    
    @objc func emailClick() {
    
        
        var sumQty = 0
        var sumTotalUSD = 0.0
        
        for item in poItemEmail {
            sumQty += Int(item.price) ?? 0
            sumTotalUSD += Double(item.total) ?? 0.00
        }
        
        // Convert to JSON
//        let jsonData = try? JSONSerialization.data(withJSONObject: poItemEmail, options: [])
//        let jsonString = String(data: jsonData ?? Data(), encoding: .utf8) ?? ""
        
        let body = generateTableFromJson(jsonData: poItemEmail, sumQty: sumQty, sumTotalUSD: "\(sumTotalUSD)")
        
        let story = UIStoryboard(name: "Main", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: "stockemail") as! StockEmailViewController
        
        vc.email_body = body
        vc.email_subject = "Purchase Order Details:\(id)"
        vc.email_name = id
        
        
        present(vc, animated: true)
    }
    
    func generateTableFromJson(jsonData: [POItemEmail], sumQty: Int, sumTotalUSD: String) -> String {
        
        var jsonArray: [POItemEmail] = []
        
        jsonArray = jsonData
        
//        guard let data = jsonData.data(using: .utf8), let jsonArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]], !jsonArray.isEmpty else {
//            return ""
//        }
        
        var html = ""
        
        // Table start
        html += """
        <table border="1" width="100%" cellpadding="10" cellspacing="0" align="center"
               style="max-width:560px;border-spacing:0;border-collapse:collapse;margin:20px auto;width:560px;">
        <tbody>
        <tr>
        """
        
        // Headers (from first object keys)
        for key in itemHeaderEmail {
            html += "<th style=\"text-align:center;\">\(key)</th>"
        }
        html += "</tr>"
        
        // Rows
        for row in jsonArray {
            
            html += "<tr>"
            
            html += "<td style=\"border:1px solid #000;\">\(row.name)</td>"
            html += "<td style=\"border:1px solid #000;\">\(row.upc)</td>"
            html += "<td style=\"text-align:center;border:1px solid #000;\">\(row.qty)</td>"
            
            let price = Double(row.price) ?? 0.00
            html += "<td style=\"text-align:right;border:1px solid #000;\">$\(price)</td>"
            
            let total = Double(row.total) ?? 0.00
            html += "<td style=\"text-align:right;border:1px solid #000;\">$\(total)</td>"
            
            html += "<td style=\"border:1px solid #000;\">\(row.note)</td>"
            
            html += "</tr>"
        }
        
        // Summary rows
        html += """
        <tr>
            <td></td>
            <th colspan="3" style="text-align:right;">TOTAL UNITS</th>
            <td style="text-align:right;">\(sumQty)</td>
            <td style="border:1px solid #000;"></td>
        </tr>
        <tr>
            <td></td>
            <th colspan="3" style="text-align:right;">SUBTOTAL</th>
            <td style="text-align:right;">$\(sumTotalUSD)</td>
            <td style="border:1px solid #000;"></td>
        </tr>
        <tr>
            <td></td>
            <th colspan="3" style="text-align:right;">TOTAL (USD)</th>
            <td style="text-align:right;">$\(sumTotalUSD)</td>
            <td style="border:1px solid #000;"></td>
        </tr>
        """
        
        html += "</tbody></table>"
        
        return emailHtml(htmlString: html)
    }
    
    func voidApi() {
        
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
                self.tableview.isHidden = false
                self.loadingIndicator.isAnimating = false
            }
        }
    }
    
    
    @IBAction func threeBtnClick(_ sender: UIButton) {
        
        if menu.isHidden {
            menu.isHidden = false
        }
        else {
            menu.isHidden = true
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
        vc.id = bigDetails?.id ?? ""
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
    
    func savePOItem(save: [VariantPOModel], mode: String) {
        if mode == "join" {
            saveSelectedVariants = save
            tableview.reloadData()
        }
        else {
            navigationController?.popViewController(animated: true)
        }
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
        
        cell.costValue.text = "$\(item.cost)"
        
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
        
        let status = item.status
        
        if bigDetails?.is_void == "1" {
            cell.toReceiveField.isEnabled = false
            cell.toReceiveField.text = ""
            cell.qtyAfter.text = "Qty After:"
        }
        else if status == "2" {
            cell.toReceiveField.isEnabled = false
            cell.toReceiveField.text = "\(item.pendingQty)"
            cell.qtyAfter.text = "Qty After: \(item.afterQty)"
        }
        else {
            cell.toReceiveField.text = "\(item.pendingQty)"
            
            cell.toReceiveView.layer.borderColor = UIColor(hexString: "#D0D0D0").cgColor
            cell.toReceiveView.layer.borderWidth = 1
            cell.toReceiveView.layer.cornerRadius = 10
            cell.toReceiveField.isEnabled = true
            
            cell.qtyAfter.text = "Qty After: \(item.afterQty)"
        }
        
        cell.deleteBtn.tag = indexPath.row
                                
        let note = item.note
        
        if note == "" {
            cell.noteLbl.text = ""
        }
        else {
            cell.noteLbl.text = "Note"
        }
        cell.noteValue.text = item.note
        
        cell.total.text = "Total: $\(item.total)"
        
        cell.toReceiveField.borderStyle = .none
        cell.toReceiveField.delegate = self
        cell.toReceiveField.keyboardType = .numberPad
        cell.toReceiveField.addTarget(self, action: #selector(updateText), for: .editingChanged)
        
        cell.deleteBtn.tag = indexPath.row
        cell.costValue.tag = indexPath.row
        cell.qtyValue.tag = indexPath.row
        cell.noteValue.tag = indexPath.row
        cell.qtyAfter.tag = indexPath.row
        cell.total.tag = indexPath.row
        cell.toReceiveField.tag = indexPath.row
        
        return cell
        
    }
}

struct POItemEmail {
    
    let name: String
    let upc: String
    let qty: String
    let price: String
    let total: String
    let note: String
}
