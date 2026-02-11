//
//  VendorProductViewController.swift
//  QuickveeApp
//
//  Created by Kalpesh on 12/01/26.
//

import UIKit
import MaterialComponents

protocol VendorProductDelegate: AnyObject {
    
    func getVendorProduct(vendors: [VendorProduct], variant_id: String, singleProduct: String)
}

class VendorProductViewController: UIViewController {
    
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    
    @IBOutlet weak var tableview: UITableView!
    
    var vendorProductList = [VendorProduct]()
    var var_id = ""
    var single_product = ""
    var prev_prefer = 0
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    private var isSymbolOnRight = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
    }
    
    @IBAction func backBtnClick(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func saveBtnClick(_ sender: UIButton) {
        
        tableview.isHidden = true
        loadingIndicator.isAnimating = true
        
        var vendorIds = [String]()
        var vendorCost = [String]()
        
        guard vendorProductList.count > 0 else {
            tableview.isHidden = false
            loadingIndicator.isAnimating = false
            return
        }
        
        for vendor in vendorProductList {
            
            vendorIds.append(vendor.id)
            vendorCost.append(vendor.cost_per_item)
        }
        
        let vendorIdString = vendorIds.joined(separator: ",")
        let vendorCostString = vendorCost.joined(separator: ",")
        
        ApiCalls.sharedCall.saveVendorProduct(vendor_id: vendorIdString, variant_id: var_id, costperItem: vendorCostString, single_product: single_product) { isSuccess, responseData in
            
            if isSuccess {
                ToastClass.sharedToast.showToast(message: responseData["message"] as! String, font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                DispatchQueue.main.async {
                    self.tableview.isHidden = false
                    self.loadingIndicator.isAnimating = false
                }
            }
            else {
                self.tableview.isHidden = false
                self.loadingIndicator.isAnimating = false
            }
        }
    }
    
    
    @IBAction func homeBtnClick(_ sender: UIButton) {
        
        let viewcontrollerArray = navigationController?.viewControllers
        var destiny = 0
        if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is HomeViewController }) {
            destiny = destinationIndex
        }
        navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
    }
    
    
    @IBAction func addBtnClick(_ sender: UIButton) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "filtercategory") as! FilterCategoryViewController
        
        vc.selectProductVendors = vendorProductList
        vc.delegateVendorProduct = self
        vc.apiMode = "vendorProduct"
        vc.catMode = "vendorProducts"
        vc.variantProductVendorId = var_id
        vc.variantSingleProduct = single_product
        
        self.present(vc, animated: true)
    }
    
    
    @IBAction func preferClick(_ sender: UIButton) {
        
        self.tableview.isHidden = true
        self.loadingIndicator.isAnimating = true
        
        setPreferVendor(tag: sender.tag)
    }
    
    func setPreferVendor(tag: Int) {
        
        let pref = vendorProductList[tag].pref_vendor
        
        let vendor_id = vendorProductList[tag].id
        
        ApiCalls.sharedCall.setPreferVendorProduct(vendor_id: vendor_id, varient_id: var_id, single_product: single_product) { isSuccess, responseData in
            
            if isSuccess {
                
                DispatchQueue.main.async {
                    self.vendorProductList[self.prev_prefer].pref_vendor = "0"
                    if pref == "1" {
                        self.vendorProductList[tag].pref_vendor = "0"
                    }
                    else {
                        self.vendorProductList[tag].pref_vendor = "1"
                    }
                    self.tableview.reloadData()
                    self.tableview.isHidden = false
                    self.loadingIndicator.isAnimating = false
                    ToastClass.sharedToast.showToast(message: responseData["message"] as! String, font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                }
            }
            else {
                self.tableview.isHidden = false
                self.loadingIndicator.isAnimating = false
            }
        }
    }
    
    func setupAssignApi() {
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        ApiCalls.sharedCall.getVendorProductList(merchant_id: id, varient_id: var_id, single_product: single_product) { isSuccess, responseData in
            
            if isSuccess {
                self.setVendorProduct(list: responseData["result"])
            }
        }
    }
    
    func setVendorProduct(list: Any) {
        
        let response = list as! [[String:Any]]
        var smallres = [VendorProduct]()
        
        for res in response {
            
            let vendor = VendorProduct(id: "\(res["id"] ?? "")", name: "\(res["name"] ?? "")",
                                       cost_per_item: "\(res["cost_per_item"] ?? "")", pref_vendor: "\(res["pref_vendor"] ?? "")")
            
            smallres.append(vendor)
        }
        vendorProductList = smallres
        
        DispatchQueue.main.async {
            self.tableview.reloadData()
            self.tableview.isHidden = false
            self.loadingIndicator.isAnimating = false
        }
    }
    
    
    @IBAction func deleteBtnClick(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Alert", message: "Are you sure you want to delete this item?", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "No", style: .cancel)
        
        let okAction = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction!) in

            let id = self.vendorProductList[sender.tag].id
            self.deleteVendorProduct(vendor_id: id, tag: sender.tag)
            
        }
        
        alertController.addAction(cancel)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion:nil)
    }
    
    func deleteVendorProduct(vendor_id: String, tag: Int) {
        
        tableview.isHidden = true
        loadingIndicator.isAnimating = true
        
        let m_id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        ApiCalls.sharedCall.deleteVendorProduct(vendor_id: vendor_id, variant_id: var_id, merchant_id: m_id, single_product: single_product) { isSuccess, responseData in
            
            if isSuccess {
                
                DispatchQueue.main.async {
                    self.vendorProductList.remove(at: tag)
                    self.tableview.reloadData()
                    self.tableview.isHidden = false
                    self.loadingIndicator.isAnimating = false
                    ToastClass.sharedToast.showToast(message: responseData["message"] as! String, font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                }
            }
            else {
                self.tableview.isHidden = false
                self.loadingIndicator.isAnimating = false
            }
        }
    }
    
    
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
        
        if Double(cleanedAmount) ?? 00000 > 99999999 {
            cleanedAmount = String(cleanedAmount.dropLast())
        }
        
        let amount = Double(cleanedAmount) ?? 0.0
        let amountAsDouble = (amount / 100.0)
        var amountAsString = String(amountAsDouble)
        if cleanedAmount.last == "0" {
            amountAsString.append("0")
        }
        textField.text = amountAsString
        
        if textField.text == "000" {
            textField.text = ""
        }
    }
    
    func createCustomTextField(textField: MDCOutlinedTextField) {
        
        textField.font = UIFont(name: "Manrope-SemiBold", size: 13.0)
        textField.setOutlineColor(UIColor(named: "borderColor")!, for: .normal)
        textField.setOutlineColor(UIColor(named: "borderColor")!, for: .editing)
        textField.setFloatingLabelColor(UIColor(named: "Attributeclr")!, for: .normal)
        textField.setFloatingLabelColor(UIColor(named: "Attributeclr")!, for: .editing)
        textField.setNormalLabelColor(UIColor(named: "Attributeclr")!, for: .normal)
        textField.setNormalLabelColor(UIColor(named: "Attributeclr")!, for: .editing)
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

extension VendorProductViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let index = IndexPath(row: textField.tag, section: 0)
        let cell = tableview.cellForRow(at: index) as! VendorProductTableViewCell
        
        vendorProductList[textField.tag].cost_per_item = cell.costPer.text ?? ""
    }
}

extension VendorProductViewController: VendorProductDelegate {
    
    func getVendorProduct(vendors: [VendorProduct], variant_id: String, singleProduct: String) {
        vendorProductList = vendors
        var_id = variant_id
        single_product = singleProduct
        tableview.reloadData()
    }
}

extension VendorProductViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vendorProductList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! VendorProductTableViewCell
        
        let vendor = vendorProductList[indexPath.row]
        
        if vendor.pref_vendor == "1" {
            cell.vendorPrefer.setImage(UIImage(named: "select_radio"), for: .normal)
            prev_prefer = indexPath.row
        }
        else {
            cell.vendorPrefer.setImage(UIImage(named: "unselect_radio"), for: .normal)
        }
        
        cell.vendorName.text = vendor.name
        
        if vendor.cost_per_item == "" || vendor.cost_per_item == "<null>" {
            cell.costPer.text = "0.00"
        }
        else {
            cell.costPer.text = vendor.cost_per_item
        }
        cell.costPer.label.text = "Cost Per Item"
        
        cell.costPer.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        cell.costPer.delegate = self
        
        cell.vendorPrefer.tag = indexPath.row
        cell.deleteBtn.tag = indexPath.row
        cell.costPer.tag = indexPath.row
        
        createCustomTextField(textField: cell.costPer)
        cell.costPer.keyboardType = .decimalPad
    
        return cell
    }
}

struct VendorProduct {
    
    let id: String
    let name: String
    var cost_per_item: String
    var pref_vendor: String
}
