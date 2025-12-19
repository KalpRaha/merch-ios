//
//  StocktakeProductViewController.swift
//  QuickveeApp
//
//  Created by Pallavi on 08/10/25.
//
protocol StocktakeProductDelegate: AnyObject {
    func setProductStocktake(new_qty: String)
}

import UIKit
import MaterialComponents
import IQKeyboardManagerSwift

class StocktakeProductViewController: UIViewController, UITextFieldDelegate {

  
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var saveBtn: UIButton!
   
    @IBOutlet weak var producName: UILabel!
   
    @IBOutlet weak var upc: UILabel!
   
    @IBOutlet weak var currentView: UIView!
    
    @IBOutlet weak var descrepantyValue: UILabel!
    @IBOutlet weak var descrepancyView: UIView!
    
    @IBOutlet weak var newQty: MDCOutlinedTextField!
    
    @IBOutlet weak var noteTextField: UITextField!
    
    
    @IBOutlet weak var currentQtyValue: UILabel!
    
    @IBOutlet weak var bgView: UIView!
    
    
    var varrObject: ProductById?
    
    var prod_id = ""
    
    var activeTextField = UITextField()
    var descrepancy = ""
    
    weak var delegateStock: StocktakeProductDelegate?
    var updated_new_qty = ""
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.white], lineWidth: 3)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setData()
        setupUI()
        setUI()
        newQty.delegate = self

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    
    func setUI(){
        
        cancelBtn.layer.cornerRadius = 5
        cancelBtn.layer.borderWidth = 1
        cancelBtn.layer.borderColor = UIColor.black.cgColor
        
        saveBtn.layer.cornerRadius = 5
        currentView.layer.cornerRadius = 5
        descrepancyView.layer.cornerRadius = 5
        
        bgView.layer.cornerRadius = 10
        newQty.keyboardType = .numberPad
        
        newQty.delegate = self
        newQty.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
    }
    
    func calculateDescCost(descrepancy: String, costper: String) -> String {
        let descre = Double(descrepancy) ?? 0.0
        let costperItem = Double(costper) ?? 0.0
        let cost_descre = Double((descre * costperItem))
        return String(cost_descre)
      }
    
    
    func setData() {
        
        if varrObject?.isvarient == "0" {
            producName.text = varrObject?.title
        }
        else {
            producName.text = varrObject?.variant
        }
        
        upc.text = varrObject?.upc
        currentQtyValue.text = varrObject?.quantity
        updated_new_qty = varrObject?.quantity ?? ""
        descrepantyValue.text = "0"
    }
    
    func stockSaveApiCall() {
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        let emp_id = UserDefaults.standard.string(forKey: "emp_po_id") ?? ""
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateFormat = format.string(from: date)
        var var_id = ""
        var items = [SaveStock]()
        var final_json = ""
        let new_qty = newQty.text ?? ""
        let note_per = noteTextField.text ?? ""
        let upc = varrObject?.upc ?? ""
        let category_id = varrObject?.cotegory ?? ""
        let product_name = varrObject?.title ?? ""
        var product_id = ""
        let variant = varrObject?.variant ?? ""
        let current_qty = varrObject?.quantity ?? ""
        let cpi = varrObject?.costperItem ?? ""
        let discre_cost = calculateDescCost(descrepancy: descrepancy, costper: cpi)
        print(cpi)
        print(descrepancy)
        print(discre_cost)
        if varrObject?.isvarient == "0" {
          product_id = varrObject?.id ?? ""
          var_id = ""
        }
        else {
          var_id = varrObject?.id ?? ""
          product_id = prod_id
        }
        let save = SaveStock(upc: upc, category_id: category_id,
                   product_id:product_id , variant_id: var_id,
                   product_name:product_name ,
                   variant: variant,
                   current_qty: current_qty,
                   new_qty: new_qty, discrepancy: descrepancy,
                   discrepancy_cost: discre_cost, stocktake_item_id: "", note: note_per)
        print(save)
        items.append(save)
        print(items)
        do {
          let encoder = JSONEncoder()
          encoder.outputFormatting = .prettyPrinted // Makes the output readable
          let jsonData = try encoder.encode(items) // Wrap the object in an array for consistency with the provided JSON structure
          // Convert the encoded JSON into a string for display or further processing
          if let jsonString = String(data: jsonData, encoding: .utf8) {
            final_json = jsonString
            print(final_json)
          }
        } catch {
          print("Error encoding JSON: \(error)")
        }
        loadingIndicator.isAnimating = true
        ApiCalls.sharedCall.saveStockTake(merchant_id: id, employee_id: emp_id,
                         total_qty: new_qty, total_discrepancy: descrepancy,
                         total_discrepancy_cost: discre_cost, status: "0", datetime: dateFormat,
                         stocktake_items: final_json , stocktake_id: ""){ isSuccess, response in
          if isSuccess {
            guard let msg = response["message"] else {
              return
            }
            self.loadingIndicator.isAnimating = false
            ToastClass.sharedToast.showToast(message: msg as! String,
                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            self.dismiss(animated: true) {
              self.delegateStock?.setProductStocktake(new_qty: self.updated_new_qty)
            }
          }
          else {
            print("error")
          }
        }
      }
    
    
//    @objc func dismissKeyboard() {
//        view.endEditing(true)
//    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == newQty {
            
            let newqty = newQty.text ?? ""
            var currentQty = ""
            
            currentQty = varrObject?.quantity ?? ""
            
            let currentDouble = Int(currentQty) ?? 0
            let newDouble = Int(newqty) ?? 0
            let discrepancy = newDouble - currentDouble
            print(discrepancy)
            descrepancy = "\(discrepancy)"
            
            
            if descrepancy.contains("-"){
                descrepantyValue.textColor = .red
                descrepantyValue.text = "\(discrepancy)"
            }else if descrepancy.contains("0"){
                descrepantyValue.textColor = .black
                descrepantyValue.text = "\(discrepancy)"
            }
            else {
                descrepantyValue.textColor = UIColor(hexString: "#15AE5D")
                descrepantyValue.text = "+\(discrepancy)"
            }
                
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == newQty {
            activeTextField = newQty
        }
    }
    
    
    @objc func updateTextField(textField: MDCOutlinedTextField ) {
    
        var updatetext = textField.text ?? ""
        
        
        if textField == newQty {
            
            if updatetext.count > 6 {
                updatetext = String(updatetext.dropLast())
            }
        }
        updated_new_qty = updatetext
        activeTextField.text = updatetext
    }
   
    @IBAction func crossBtnClick(_ sender: UIButton) {
        
       dismiss(animated: true)
    }
    
    @IBAction func cancelBtnClick(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func saveBtnClick(_ sender: UIButton) {
        stockSaveApiCall()
    }
   
     private func setupUI() {
         if #available(iOS 13.0, *) {
             overrideUserInterfaceStyle = .light
         }
         
         
         saveBtn.addSubview(loadingIndicator)

         NSLayoutConstraint.activate([
             loadingIndicator.centerXAnchor
                 .constraint(equalTo: saveBtn.centerXAnchor, constant: 65),
             loadingIndicator.centerYAnchor
                 .constraint(equalTo: saveBtn.centerYAnchor),
             loadingIndicator.widthAnchor
                 .constraint(equalToConstant: 15),
             loadingIndicator.heightAnchor
                 .constraint(equalTo: self.loadingIndicator.widthAnchor)
         ])
     }
    
}
