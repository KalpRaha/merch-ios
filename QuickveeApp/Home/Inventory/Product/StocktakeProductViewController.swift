//
//  StocktakeProductViewController.swift
//  QuickveeApp
//
//  Created by Pallavi on 08/10/25.
//

import UIKit
import MaterialComponents

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
    
    var editProd: ProductById?
    var editVarr: ProductById?
    
    var activeTextField = UITextField()
    var descrepancy = ""
    
    
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
       
        
        
        let cost_descre =   Double((descre * costperItem))
        print(cost_descre)
        
        return String(cost_descre)
    }
    
    
    func setData() {
     
        if editProd?.isvarient == "0" {
            
            producName.text = editProd?.title
            upc.text = editProd?.upc
            currentQtyValue.text = editProd?.quantity
            descrepantyValue.text = "0"
        }
        else {
            producName.text = editVarr?.variant
            upc.text = editVarr?.upc
            currentQtyValue.text = editVarr?.quantity
            descrepantyValue.text = "0"
        }
        
    
    }
    
    
    func  stockSaveApiCall() {
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        let emp_id = UserDefaults.standard.string(forKey: "emp_po_id") ?? ""
        
        
        let date = Date()
        
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateFormat = format.string(from: date)
        
        
        var items = [SaveStock]()
        var final_json = ""
        
        var upc = ""
        var var_id = ""
        var note_per = ""
        var category_id = ""
        var product_id = ""
        var product_name = ""
        var variant = ""
        var current_qty = ""
        var new_qty = ""
        var discre_cost = ""
        
        new_qty =  newQty.text ?? ""
        note_per = noteTextField.text ?? ""
        
        
        if editProd?.isvarient == "0" {
            upc = editProd?.upc ?? ""
            category_id = editProd?.cotegory ?? ""
            product_name = editProd?.title ?? ""
            product_id = editProd?.id ?? ""
            var_id = ""
            variant = editProd?.variant ?? ""
            current_qty = editProd?.quantity ?? ""
            discre_cost = calculateDescCost(descrepancy: descrepancy, costper: editProd?.costperItem ?? "")
            print(discre_cost)
        }
        else {
            upc = editVarr?.upc ?? ""
            category_id = editProd?.cotegory ?? ""
            var_id = editVarr?.id ?? ""
            product_name = editVarr?.title ?? ""
            product_id = ""
            variant = editVarr?.variant ?? ""
            current_qty = editVarr?.quantity ?? ""
            discre_cost = calculateDescCost(descrepancy: descrepancy, costper: editVarr?.costperItem ?? "")
            print(discre_cost)
        }
        
        
        

        let save = SaveStock(upc: upc, category_id: category_id,
                             product_id:product_id , variant_id: var_id,
                             product_name:product_name ,
                             variant: variant,
                             current_qty: current_qty,
                             new_qty: new_qty, discrepancy: descrepancy,
                             discrepancy_cost: discre_cost, stocktake_item_id: "", note: note_per)
        
        items.append(save)
        
        print(items)
        
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted  // Makes the output readable
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
        
        ApiCalls.sharedCall.saveStockTake(merchant_id: id, employee_id: emp_id, total_qty: new_qty, total_discrepancy: descrepancy, total_discrepancy_cost: discre_cost, status: "1", datetime: dateFormat, stocktake_items: final_json , stocktake_id: ""){ isSuccess, response in
            
            if isSuccess {
                
                guard let msg = response["message"] else {
                    return
                }
                self.loadingIndicator.isAnimating = false
                ToastClass.sharedToast.showToast(message: msg as! String,
                                                 font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    
                    let transition = CATransition()
                    transition.duration = 0.7
                    transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                    transition.type = CATransitionType.reveal
                    transition.subtype = CATransitionSubtype.fromBottom
                    self.navigationController?.view.layer.add(transition, forKey: nil)
                    
                    self.navigationController?.popViewController(animated: false)
                }
                
                
            }
            else {
                print("error")
            }
        }
        
    }
    
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
       
        if textField == newQty {
            
            let newqty = newQty.text ?? ""
            var currentQty = ""
           
            if editProd?.isvarient == "0" {
                 currentQty = editProd?.quantity ?? ""
            }
            else {
                currentQty = editVarr?.quantity ?? ""
            }
            
            let currentDouble = Int(currentQty) ?? 0
            let newDouble = Int(newqty) ?? 0
            let discrepancy = newDouble - currentDouble
            print(discrepancy)
            descrepancy = "\(discrepancy)"
            descrepantyValue.text = "\(discrepancy)"
            let total = String(discrepancy)
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
        activeTextField.text = updatetext
    }
    
    
    
     
    @IBAction func crossBtnClick(_ sender: UIButton) {
        
          let transition = CATransition()
          transition.duration = 0.7
          transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
          transition.type = CATransitionType.reveal
          transition.subtype = CATransitionSubtype.fromBottom
          navigationController?.view.layer.add(transition, forKey: nil)
          
          navigationController?.popViewController(animated: false)
    }
    
    @IBAction func cancelBtnClick(_ sender: UIButton) {
        let transition = CATransition()
        transition.duration = 0.7
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        navigationController?.view.layer.add(transition, forKey: nil)
        
        navigationController?.popViewController(animated: false)
        
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
