//
//  QuickAddPOViewController.swift
//  QuickveeApp
//
//  Created by Kalpesh on 17/11/25.
//

import UIKit

class QuickAddPOViewController: UIViewController {
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var taxCollection: UICollectionView!
    
    @IBOutlet weak var upcTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var costPerItemTextField: UITextField!
    
    @IBOutlet weak var quantityField: UITextField!
    
    @IBOutlet weak var genUpcLbl: UILabel!
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    
    @IBOutlet weak var collHeight: NSLayoutConstraint!
    
    @IBOutlet weak var taxcollHeight: NSLayoutConstraint!
    
    @IBOutlet weak var scrollHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollInnerView: UIView!
    
    var categoryPO = [InventoryCategory]()
    var defaultTax = [SetupTaxes]()
    var finalTaxes = [CheckTax]()
    var isSymbolOnRight = false
    var quick: QuickAddPO?
    
    weak var delegate: AddQuickPODelegate?
    
    let loadIndicator: ProgressView = {
        let progress = ProgressView(colors: [.white], lineWidth: 3)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.autocapitalizationType = .words
        
        cancelBtn.layer.cornerRadius = 10
        cancelBtn.layer.borderColor = UIColor.black.cgColor
        cancelBtn.layer.borderWidth = 1
        addBtn.layer.cornerRadius = 10
        
        let colLay = CustomFlowLayout()
        collection.collectionViewLayout = colLay
        colLay.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        collection.layer.borderColor = UIColor(named: "borderColor")?.cgColor
        collection.layer.borderWidth = 1.0
        collection.layer.cornerRadius = 10
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(openCategory))
        collection.addGestureRecognizer(tap)
        tap.numberOfTapsRequired = 1
        collection.isUserInteractionEnabled = true
        
        createCustomTextField(textField: upcTextField)
        createCustomTextField(textField: nameTextField)
        createCustomTextField(textField: priceTextField)
        createCustomTextField(textField: costPerItemTextField)
        createCustomTextField(textField: quantityField)
        
        quantityField.addTarget(self, action: #selector(updateText), for: .editingChanged)
        priceTextField.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        costPerItemTextField.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        
        upcTextField.delegate = self
        nameTextField.delegate = self
        priceTextField.delegate = self
        costPerItemTextField.delegate = self
        quantityField.delegate = self
        
        
        let tapUpc = UITapGestureRecognizer(target: self, action: #selector(genUpcClick))
        genUpcLbl.addGestureRecognizer(tapUpc)
        tapUpc.numberOfTapsRequired = 1
        genUpcLbl.isUserInteractionEnabled = true
        
        priceTextField.keyboardType = .numberPad
        quantityField.keyboardType = .numberPad
        costPerItemTextField.keyboardType = .numberPad
        
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nameTextField.text = quick?.name ?? ""
        upcTextField.text = quick?.upc ?? ""
        quantityField.text = quick?.quantity ?? ""
        priceTextField.text = quick?.price ?? ""
        costPerItemTextField.text = quick?.cost ?? ""
        
        setupTax()
    }
    
    func setupTax() {
        
        let m_id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        ApiCalls.sharedCall.productTaxList(merchant_id: m_id) { isSuccess, responseData in
            
            if isSuccess {
                
                guard let list = responseData["result"] else {
                    return
                }
                guard let list_status = responseData["status"], list_status as! Int != 0 else {
                    return
                }
                
                self.getResponseTaxes(list: list)
            }else{
                print("Api Error")
            }
        }
    }
    
    func getResponseTaxes(list: Any) {
        
        let response = list as! [[String:Any]]
        var first = 0
        var taxArray = [SetupTaxes]()
        for res in response {
            
            let setTax = SetupTaxes(alternateName: "\(res["alternateName"] ?? "")",
                                    created_on: "\(res["created_on"] ?? "")",
                                    displayname: "\(res["displayname"] ?? "")",
                                    id: "\(res["id"] ?? "")",
                                    merchant_id: "\(res["merchant_id"] ?? "")",
                                    percent: "\(res["percent"] ?? "")",
                                    title: "\(res["title"] ?? "")",
                                    user_id: "\(res["user_id"] ?? "")")
            if first != 0 {
                taxArray.append(setTax)
            }
            first += 1
        }
        defaultTax = taxArray
        
        var checkTax = [CheckTax]()
        
        for tax in defaultTax {
            if tax.title == "DefaultTax" {
                checkTax.append(CheckTax(tax: tax, isSelected: true))
            }
            else {
                checkTax.append(CheckTax(tax: tax, isSelected: false))
            }
        }
        finalTaxes = checkTax
        
        DispatchQueue.main.async {
            self.taxcollHeight.constant = 64 * CGFloat(self.finalTaxes.count)
            self.taxCollection.reloadData()
        }
    }
    
    @objc func openCategory() {
        
        dismiss(animated: true) {
            self.delegate?.addProduct(mode: 1, quick: self.quick!, category: self.categoryPO, p_id: "")
        }
    }
    
    func getGeneratedUpc(length: Int) -> String {
        let characters = "0123456789"
        var result = ""
        for _ in 0..<length {
            let resInt = Int(floor(Double.random(in: 0.0...0.9) * Double(characters.count)))
            result += String(resInt)
        }
        
        return result
    }
    
    @objc func genUpcClick() {
        
        if upcTextField.text == "" {
            
            let upcCode = getGeneratedUpc(length: 12)
            
            let upcUnique = UserDefaults.standard.stringArray(forKey: "variant_upcs") ?? []
            
            if upcUnique.contains(upcCode) {
                ToastClass.sharedToast.showToast(message: "Duplicate upc found", font:  UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                upcTextField.text = ""
                quick?.upc = ""
            }
            else {
                quick?.upc = upcCode
                upcTextField.text = upcCode
            }
        }
    }
    
    @IBAction func closeBtnClick(_ sender: UIButton) {
        
        categoryPO.remove(at: sender.tag)
        if categoryPO.count > 0 {
            collection.reloadData()
        }
        else {
            setCatHeight()
            collection.isHidden = true
        }
    }
    
    
    @IBAction func cancelBtnClick(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    
    @IBAction func addBtnClick(_ sender: UIButton) {
        
        validateAddParams()
    }
    
    func validateAddParams() {
        
        let m_id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        guard let name = nameTextField.text, name != "" else {
            nameTextField.isErrorView(numberOfShakes: 3, revert: true)
            ToastClass.sharedToast.showToast(message: "Enter product name", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            return
        }
        
        guard categoryPO.count != 0 else{
            ToastClass.sharedToast.showToast(message: "Category not selected", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            return
        }
        
        var small = [String]()
        for cat in categoryPO {
            small.append(cat.id)
        }
        
        let collection = small.joined(separator: ",")
        
        var other_taxes = ""
        var ischargeTax = ""
        var taxid = [String]()
        
        for tax in finalTaxes {
            if tax.isSelected {
                taxid.append(tax.tax.id)
            }
        }
        if taxid.count > 0 {
            other_taxes = taxid.joined(separator: ",")
            ischargeTax = "1"
        }
        else {
            other_taxes = ""
            ischargeTax = "0"
        }
        
        let costperitem = costPerItemTextField.text ?? "0.00"
        
        guard let price = priceTextField.text, price != "", price != "0.00" else {
            priceTextField.isErrorView(numberOfShakes: 3, revert: true)
            ToastClass.sharedToast.showToast(message: "Enter valid price", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            return
        }
        
        guard var qty = quantityField.text else {
            quantityField.isErrorView(numberOfShakes: 3, revert: true)
            ToastClass.sharedToast.showToast(message: "Enter valid quantity", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            return
        }
        
        guard let upc_code = upcTextField.text, upc_code != "" else {
            
            upcTextField.isErrorView(numberOfShakes: 3, revert: true)
            ToastClass.sharedToast.showToast(message: "Enter UPC code", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            return
        }
        
        if qty == "" {
            qty = "0"
        }
        
        loadIndicator.isAnimating = true
        
        addBtn.isEnabled = false
        
        ApiCalls.sharedCall.productAddCall(id: m_id, title: name, description: "",
                                           brand: "", tags: "", stores: "", price: price,
                                           compare_price: "",
                                           costperItem: costperitem, margin: "",
                                           profit: "", ischargeTax: ischargeTax,
                                           trackqnty: "", isstockcontinue: "",
                                           quantity: qty, collection: collection,
                                           isvarient: "0", is_lottery: "0",
                                           created_on: "",
                                           optionarray: "", optionarray1: "", optionarray2: "",
                                           optionvalue: "", optionvalue1: "", optionvalue2: "",
                                           other_taxes: other_taxes, bought_product: "",
                                           featured_product: "", varvarient: "",
                                           varprice: "",
                                           varcompareprice: "", varcostperitem: "",
                                           varquantity: "",
                                           upc: upc_code, custom_code: "",
                                           reorder_qty: "",
                                           reorder_level: "", reorder_cost: "",
                                           is_tobacco: "",
                                           disable: "", food_stampable: "",
                                           varupc: "",
                                           varcustomcode: "",
                                           vartrackqnty: "", varcontinue_selling: "",
                                           varcheckid: "",
                                           vardisable: "", varfood_stampable: "", varmargin: "",
                                           varprofit: "", varreorder_qty: "",
                                           varreorder_level: "", varreorder_cost: "")
        { isSuccess, responseData in
            
            if isSuccess {
                
                if let list = responseData["message"] as? String {
                    if list == "Success" {
                        let id = responseData["product_id"] as? Int ?? 0
                        ToastClass.sharedToast.showToast(message: "Successfully created product", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                        self.loadIndicator.isAnimating = false
                        self.addBtn.isEnabled = true
                        self.dismiss(animated: true) {
                            self.delegate?.addProduct(mode: 2, quick: self.quick!, category: self.categoryPO, p_id: "\(id)")
                        }
                    }
                    else{
                        ToastClass.sharedToast.showToast(message: "Product already exist", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                        self.loadIndicator.isAnimating = false
                        self.addBtn.isEnabled = true
                    }
                }
            }
            else {
                
            }
        }
    }
    
    func setCatHeight() {
        
        let height = collection.collectionViewLayout.collectionViewContentSize.height
        
        if height <= 50 {
            collHeight.constant = 50
        }
        else {
            collHeight.constant = height
        }
        
        let taxheight = 64 * CGFloat(self.finalTaxes.count)
        
        scrollHeight.constant = scrollInnerView.bounds.size.height + taxheight + collHeight.constant + 103.33
        
        self.view.layoutIfNeeded()
    }
    
    func createCustomTextField(textField: UITextField) {
        
        textField.font = UIFont(name: "Manrope-SemiBold", size: 13.0)
        textField.layer.borderColor = UIColor(named: "borderColor")!.cgColor
        textField.layer.borderWidth = 1.0
    }
    
    private func setUI() {
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        addBtn.addSubview(loadIndicator)
        
        NSLayoutConstraint.activate([
            loadIndicator.centerXAnchor
                .constraint(equalTo: addBtn.centerXAnchor, constant: CGFloat(30)),
            loadIndicator.centerYAnchor
                .constraint(equalTo: addBtn.centerYAnchor),
            loadIndicator.widthAnchor
                .constraint(equalToConstant: 15),
            loadIndicator.heightAnchor
                .constraint(equalTo: self.loadIndicator.widthAnchor)
        ])
    }
}

extension QuickAddPOViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == upcTextField {
            
            let upcString = upcTextField.text ?? ""
            
            let upcUnique = UserDefaults.standard.stringArray(forKey: "variant_upcs") ?? []
            
            if upcString == "" {}
            else {
                if upcUnique.contains(upcString) {
                    ToastClass.sharedToast.showToast(message: "Duplicate upc found", font:  UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                    upcTextField.text = ""
                    quick?.upc = ""
                }
                else {
                    quick?.upc = upcString
                }
            }
        }
        
        else if textField == nameTextField {
            quick?.name = nameTextField.text ?? ""
        }
        
        else if textField == quantityField {
            quick?.quantity = quantityField.text ?? ""
        }
        
        else if textField == priceTextField {
            quick?.price = priceTextField.text ?? ""
        }
        
        else {
            quick?.cost = costPerItemTextField.text ?? ""
        }
    }
    
    @objc func updateText(textField: UITextField) {
        
        var updatetext = textField.text ?? ""
        
        if textField == quantityField {
            if updatetext.count > 6 {
                updatetext = String(updatetext.dropLast())
            }
        }
        quantityField.text = updatetext
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
        textField.text = amountAsString
        
        if textField.text == "000" {
            textField.text = ""
        }
    }
}

extension QuickAddPOViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == collection {
            return categoryPO.count
        }
        else {
            return finalTaxes.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collection {
            let cell = collection.dequeueReusableCell(withReuseIdentifier: "pocatcell", for: indexPath) as! PlusCollCollectionViewCell
            
            cell.catPlusLbl.text = categoryPO[indexPath.row].title
            cell.borderview.layer.cornerRadius = 5.0
            cell.closeBtn.tag = indexPath.row
            
            setCatHeight()
            return cell
        }
        else {
            
            let cell = taxCollection.dequeueReusableCell(withReuseIdentifier: "taxcell", for: indexPath) as! QuickAddTaxPOCollectionViewCell
            
            let tax = finalTaxes[indexPath.row]
            
            if tax.isSelected {
                cell.taxImg.image = UIImage(named: "check inventory")
            }
            else {
                cell.taxImg.image = UIImage(named: "uncheck inventory")
            }
            cell.taxLbl.text = defaultTax[indexPath.row].title
            
            cell.taxLbl.tag = indexPath.row
            
            setCatHeight()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == taxCollection {
            
            let cell = taxCollection.cellForItem(at: indexPath) as! QuickAddTaxPOCollectionViewCell
            
            if cell.taxImg.image == UIImage(named: "uncheck inventory") {
                cell.taxImg.image = UIImage(named: "check inventory")
            }
            else {
                cell.taxImg.image = UIImage(named: "uncheck inventory")
            }
            finalTaxes[indexPath.row].isSelected.toggle()
        }
    }
}

extension QuickAddPOViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == collection {
            let width = collectionView.bounds.width
            return CGSize(width: width, height: 38)
        }
        else {
            let width = collection.bounds.size.width
            return CGSize(width: width/2 - 10, height: 64)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == collection {
            return 0
        }
        else {
            return 10
        }
    }
}

struct CheckTax {
    let tax: SetupTaxes
    var isSelected: Bool
}
