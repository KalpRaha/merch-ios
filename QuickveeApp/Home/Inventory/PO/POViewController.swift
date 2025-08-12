//
//  POViewController.swift
//  QuickveeApp
//
//  Created by Kalpesh on 25/07/25.
//

import UIKit

protocol POListDelegate: AnyObject {
    
    func getPOVendors(vendors: [VendorsPO])
}

class POListViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var filterLbl: UILabel!
    @IBOutlet weak var lblSelCat: UILabel!
    
    var polist = [PO]()
    var subPOlist = [PO]()
    var searchPOlist = [PO]()
    
    var filterList = [PO]()
    var selectArray = [VendorsPO]()
    
    var isFilter = false
    var mode = ""
    var po_id = ""
    var name = ""
    
    var searching = false
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(openVendors))
        filterLbl.addGestureRecognizer(tap)
        filterLbl.isUserInteractionEnabled = true
        tap.numberOfTapsRequired = 1
        
        tableview.showsVerticalScrollIndicator = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        subPOlist = []
        setUpApi()
    }
    
    func setUpApi() {
        
        tableview.isHidden = true
        loadingIndicator.isHidden = true
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        ApiCalls.sharedCall.getPOList(merchant_id: id) { isSuccess, responseData in
            
            if isSuccess {
                
                if let data = responseData["result"], (data as! [[String:Any]]).count != 0   {
                    
                    self.getResponseValues(list: data)
                    
                    DispatchQueue.main.async {
                        self.loadingIndicator.isAnimating = false
                        self.tableview.isHidden = false
                        self.tableview.reloadData()
                    }
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
        
        var small = [PO]()
        let response = list as! [[String: Any]]
        
        for po in response {
            
            let po = PO(vendor_name: "\(po["vendor_name"] ?? "")", id: "\(po["id"] ?? "")", po_number: "\(po["po_number"] ?? "")",
                        vendor_id: "\(po["vendor_id"] ?? "")", reference: "\(po["reference"] ?? "")", email: "\(po["email"] ?? "")",
                        issued_date: "\(po["issued_date"] ?? "")", stock_date: "\(po["stock_date"] ?? "")", received_status: "\(po["received_status"] ?? "")",
                        is_void: "\(po["is_void"] ?? "")", is_draft: "\(po["is_draft"] ?? "")", is_deleted: "\(po["is_deleted"] ?? "")",
                        received_at: "\(po["received_at"] ?? "")", created_at: "\(po["created_at"] ?? "")", updated_at: "\(po["updated_at"] ?? "")",
                        merchant_id: "\(po["merchant_id"] ?? "")", total_qty: "\(po["total_qty"] ?? "")", total_cost: "\(po["total_cost"] ?? "")")
            
            small.append(po)
        }
        
        polist = small.reversed()
        subPOlist = small.reversed()
    }
    
    func setupFilterApi() {
        
        var smallPO = [PO]()
        
        for po in polist {
            
            if selectArray.contains(where: {$0.name == po.vendor_name}) {
                smallPO.append(po)
            }
        }
        
        filterList = smallPO
        subPOlist = smallPO
        
        tableview.isHidden = false
        loadingIndicator.isAnimating = false
        tableview.reloadData()
    }
    
    @objc func openVendors() {
        openVendor()
    }
    
    func openVendor() {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "filtercategory") as! FilterCategoryViewController
        vc.catMode = "POVc"
        vc.delegateVendorsSelected = self
        vc.selectVendors = selectArray
        print(vc.selectVendors)
        vc.apiMode = "vendors"
        
        present(vc, animated: true, completion: {
            vc.presentationController?.presentedView?.gestureRecognizers?[0].isEnabled = false
        })
    }
    
    
    func performSearch(searchText: String) {
        
        if searchText == "" {
            searching = false
            
            if selectArray.count == 0 {
                setUpApi()
            }
            else {
                setupFilterApi()
            }
        }
        else {
            searching = true
            
            if selectArray.count == 0 {
                searchPOlist = subPOlist.filter { $0.po_number.lowercased().contains(searchText.lowercased())
                }
            }
            
            else {
                filterList = subPOlist.filter { $0.po_number.lowercased().contains(searchText.lowercased())}
            }
            tableview.reloadData()
        }
    }
    
    @IBAction func filterBtnClick(_ sender: UIButton) {
        openVendor()
    }
    
    
    @IBAction func addBtnClick(_ sender: UIButton) {
        
        mode = "add"
        performSegue(withIdentifier: "toAddPO", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toAddPO" {
            let vc = segue.destination as! AddPOViewController
            vc.mode = mode
        }
        else if segue.identifier == "toEditDraftPO" {
            let vc = segue.destination as! ItemsPOViewController
            vc.mode = mode
            vc.displayName = name
            vc.id = po_id
        }
        else {
            let vc = segue.destination as! SavePOViewController
            vc.id = po_id
        }
    }
}

extension POListViewController: POListDelegate {
    
    func getPOVendors(vendors: [VendorsPO]) {
        selectArray = vendors
        
        if selectArray.count == 0 {
            isFilter = false
            setUpApi()
            lblSelCat.text = ""
        }
        else {
            isFilter = true
            setupFilterApi()
            lblSelCat.text = "   \(selectArray.count)   "
        }
    }
}


extension POListViewController {
    
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

extension POListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            
            if isFilter {
                return filterList.count
            }
            else {
                return searchPOlist.count
            }
        }
        
        else {
            
            if isFilter {
                return filterList.count
            }
            else {
                return polist.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! POTableViewCell
        
        if searching {
            if isFilter {
                
                let po = filterList[indexPath.row]
                
                let name = po.vendor_name
                let number = po.po_number
                
                cell.poName.text = "\(name) - \(number)"
                
                if po.is_void == "1" {
                    cell.poStatus.text = "Void"
                    cell.poStatus.textColor = UIColor(hexString: "#F90A0A")
                }
                else if po.is_draft == "1" {
                    cell.poStatus.text = "Draft"
                    cell.poStatus.textColor = UIColor(hexString: "#646464")
                }
                else if po.received_status == "0" {
                    cell.poStatus.text = "Active"
                    cell.poStatus.textColor = UIColor(hexString: "#0A64F9")
                }
                else if po.received_status == "1" {
                    cell.poStatus.text = "Partial"
                    cell.poStatus.textColor = UIColor(hexString: "#FF8800")
                }
                else {
                    cell.poStatus.text = "Received"
                    cell.poStatus.textColor = UIColor(hexString: "#2EC278")
                }
                
                cell.qtyValue.text = po.total_qty
                cell.costValue.text = po.total_cost
                cell.dueDateValue.text = po.received_at
                cell.updatedValue.text = po.updated_at
                cell.receivedValue.text = po.received_at
                
                cell.bgView.layer.borderColor = UIColor(hexString: "#DEDEDE").cgColor
                cell.bgView.layer.borderWidth = 1
                cell.bgView.layer.cornerRadius = 10
            }
            else {
                
                let po = searchPOlist[indexPath.row]
                
                let name = po.vendor_name
                let number = po.po_number
                
                cell.poName.text = "\(name) - \(number)"
                
                if po.is_void == "1" {
                    cell.poStatus.text = "Void"
                    cell.poStatus.textColor = UIColor(hexString: "#F90A0A")
                }
                else if po.is_draft == "1" {
                    cell.poStatus.text = "Draft"
                    cell.poStatus.textColor = UIColor(hexString: "#646464")
                }
                else if po.received_status == "0" {
                    cell.poStatus.text = "Active"
                    cell.poStatus.textColor = UIColor(hexString: "#0A64F9")
                }
                else if po.received_status == "1" {
                    cell.poStatus.text = "Partial"
                    cell.poStatus.textColor = UIColor(hexString: "#FF8800")
                }
                else {
                    cell.poStatus.text = "Received"
                    cell.poStatus.textColor = UIColor(hexString: "#2EC278")
                }
                
                cell.qtyValue.text = po.total_qty
                cell.costValue.text = po.total_cost
                cell.dueDateValue.text = po.received_at
                cell.updatedValue.text = po.updated_at
                cell.receivedValue.text = po.received_at
                
                cell.bgView.layer.borderColor = UIColor(hexString: "#DEDEDE").cgColor
                cell.bgView.layer.borderWidth = 1
                cell.bgView.layer.cornerRadius = 10
            }
        }
        
        else {
            if isFilter {
                
                let po = filterList[indexPath.row]
                
                let name = po.vendor_name
                let number = po.po_number
                
                cell.poName.text = "\(name) - \(number)"
                
                if po.is_void == "1" {
                    cell.poStatus.text = "Void"
                    cell.poStatus.textColor = UIColor(hexString: "#F90A0A")
                }
                else if po.is_draft == "1" {
                    cell.poStatus.text = "Draft"
                    cell.poStatus.textColor = UIColor(hexString: "#646464")
                }
                else if po.received_status == "0" {
                    cell.poStatus.text = "Active"
                    cell.poStatus.textColor = UIColor(hexString: "#0A64F9")
                }
                else if po.received_status == "1" {
                    cell.poStatus.text = "Partial"
                    cell.poStatus.textColor = UIColor(hexString: "#FF8800")
                }
                else {
                    cell.poStatus.text = "Received"
                    cell.poStatus.textColor = UIColor(hexString: "#2EC278")
                }
                
                cell.qtyValue.text = po.total_qty
                cell.costValue.text = po.total_cost
                cell.dueDateValue.text = po.received_at
                cell.updatedValue.text = po.updated_at
                cell.receivedValue.text = po.received_at
                
                cell.bgView.layer.borderColor = UIColor(hexString: "#DEDEDE").cgColor
                cell.bgView.layer.borderWidth = 1
                cell.bgView.layer.cornerRadius = 10
            }
            else {
                
                let po = polist[indexPath.row]
                
                let name = po.vendor_name
                let number = po.po_number
                
                cell.poName.text = "\(name) - \(number)"
                
                if po.is_void == "1" {
                    cell.poStatus.text = "Void"
                    cell.poStatus.textColor = UIColor(hexString: "#F90A0A")
                }
                else if po.is_draft == "1" {
                    cell.poStatus.text = "Draft"
                    cell.poStatus.textColor = UIColor(hexString: "#646464")
                }
                else if po.received_status == "0" {
                    cell.poStatus.text = "Active"
                    cell.poStatus.textColor = UIColor(hexString: "#0A64F9")
                }
                else if po.received_status == "1" {
                    cell.poStatus.text = "Partial"
                    cell.poStatus.textColor = UIColor(hexString: "#FF8800")
                }
                else {
                    cell.poStatus.text = "Received"
                    cell.poStatus.textColor = UIColor(hexString: "#2EC278")
                }
                
                cell.qtyValue.text = po.total_qty
                cell.costValue.text = po.total_cost
                cell.dueDateValue.text = po.received_at
                cell.updatedValue.text = po.updated_at
                cell.receivedValue.text = po.received_at
                
                cell.bgView.layer.borderColor = UIColor(hexString: "#DEDEDE").cgColor
                cell.bgView.layer.borderWidth = 1
                cell.bgView.layer.cornerRadius = 10
            }
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableview.deselectRow(at: indexPath, animated: true)
        
        mode = "edit"
        
        if searching {
            if isFilter {
                let po = filterList[indexPath.row]
                po_id = po.id
                name = po.vendor_name
                
                if po.is_void == "1" || po.received_status == "2" {
                    performSegue(withIdentifier: "toEditPO", sender: nil)
                }
                else {
                    performSegue(withIdentifier: "toEditDraftPO", sender: nil)
                }
            }
            else {
                let po = searchPOlist[indexPath.row]
                po_id = po.id
                name = po.vendor_name
                
                if po.is_void == "1" || po.received_status == "2" {
                    performSegue(withIdentifier: "toEditPO", sender: nil)
                }
                else {
                    performSegue(withIdentifier: "toEditDraftPO", sender: nil)
                }
            }
        }
        else {
            if isFilter {
                let po = filterList[indexPath.row]
                po_id = po.id
                name = po.vendor_name
                
                if po.is_void == "1" || po.received_status == "2" {
                    performSegue(withIdentifier: "toEditPO", sender: nil)
                }
                else {
                    performSegue(withIdentifier: "toEditDraftPO", sender: nil)
                }
            }
            else {
                let po = polist[indexPath.row]
                po_id = po.id
                name = po.vendor_name
                
                if po.is_void == "1" || po.received_status == "2" {
                    performSegue(withIdentifier: "toEditPO", sender: nil)
                }
                else {
                    performSegue(withIdentifier: "toEditDraftPO", sender: nil)
                }
            }
        }
    }
}

struct PO {
    
    let vendor_name: String
    let id: String
    let po_number: String
    let vendor_id: String
    let reference: String
    let email: String
    let issued_date: String
    let stock_date: String
    let received_status: String
    let is_void: String
    let is_draft: String
    let is_deleted: String
    let received_at: String
    let created_at: String
    let updated_at: String
    let merchant_id: String
    let total_qty: String
    let total_cost: String
}

struct VendorsPO {
    
    let vendor_id: String
    let name: String
    let phone: String
    let email: String
    let city: String
    let state: String
    let zip_code: String
    let full_address: String
    let pay_count: String
    let total_pay: String
    let recent_pay_amount: String
    let recent_payment_datetime: String
    let enabled: String
}

struct PODetails {
    
    let id: String
    let merchant_id: String
    let admin_id: String
    let po_number: String
    let vendor_id: String
    let vendor_names: String
    let reference: String
    let email: String
    let issued_date: String
    let stock_date: String
    let received_status: String
    let is_void: String
    let is_draft: String
    let is_deleted: String
    let received_at: String
    let created_at: String
    let updated_at: String
    let zoho_invoice_id: String
    let employee_id: String
    let IsCompleteInvoiceFromZoho: String
    let vendor_name: String
    let order_items: Any
}

struct POItems {
    
    let id: String
    let merchant_id: String
    let admin_id: String
    let vendor_id: String
    let vendor_name: String
    let po_id: String
    let po_number: String
    let product_id: String
    let variant_id: String
    let required_qty: String
    let recieved_qty: String
    let recieved_status: String
    let pending_qty: String
    let cost_per_item: String
    let total_pricing: String
    let upc: String
    let note: String
    let created_at: String
    let updated_at: String
    let after_qty: String
    let zoho_invoice_id: String
    let product_title: String
    let product_qty: String
    let variant_title: String
    let variant_qty: String
    let item_fullname: String
    let item_qty: String
}

struct VendorPO {
    
    let id: String
    let name: String
    let issue_date: String
    let stock_date: String
    let reference: String
    let vendor_email: String
}

struct AddPO: Encodable {
    
    let product_id: String
    let variant_id: String
    let required_qty: String
    let cost_per_item: String
    let total_pricing: String
    let upc: String
    let note: String
    let after_qty: String
}

struct EditPO: Encodable {
    
    let order_item_id: String
    let product_id: String
    let variant_id: String
    let required_qty: String
    let recieved_status: String
    let cost_per_item: String
    let total_pricing: String
    let upc: String
    let note: String
    let after_qty: String
}

//{"product_id":"1356902","variant_id":"","required_qty":"1","cost_per_item":"9.99","total_pricing":9.99,"upc":"WPGRMSRMD","note":"Notes 1","after_qty":31}
