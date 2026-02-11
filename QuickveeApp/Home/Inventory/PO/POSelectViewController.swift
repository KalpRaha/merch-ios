//
//  POSelectViewController.swift
//  QuickveeApp
//
//  Created by Kalpesh on 30/07/25.
//

import UIKit
import BarcodeScanner

protocol AddQuickPODelegate: AnyObject {
    func addProduct(mode: Int, quick: QuickAddPO, category: [InventoryCategory], p_id: String)
}

class POSelectViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var searchBarName: UISearchBar!
    
    @IBOutlet weak var searchBarUPC: UISearchBar!
    
    @IBOutlet weak var scanBtn: UIButton!
    
    @IBOutlet weak var noProductView: UIView!

    @IBOutlet weak var noProductLbl: UILabel!
    
    @IBOutlet weak var scanWidth: NSLayoutConstraint!
    
    
    var variantList = [InventoryVariant]()
    
    var searchVariantPOList = [VariantPOModel]()
    
    var variantPOList = [VariantPOModel]()
    var subVariantPOList = [VariantPOModel]()
        
    var poSelectedVariants = [VariantPOModel]()
    var autoSelectedVariants = [POVendorProduct]()
    
    var selected = [VariantPOModel]()
    
    var varUpc = [String]()
    
    var searching = false
    var mode = ""
    var vendor: VendorPO?
    
    var new_id = ""
    
    var searchMode = 0
    var quickAddSelect: QuickAddPO?
    
    weak var selectDelegate: POSelectDelegate?
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        searchBarName.searchBarStyle = .minimal
        searchBarName.placeholder = "Start Typing Product Name"
        searchBarUPC.searchBarStyle = .minimal
        searchBarUPC.placeholder = "Start Typing UPC"
        scanWidth.constant = 0
        scanBtn.isHidden = true
        topView.addBottomShadow()
        cancelBtn.layer.cornerRadius = 10
        nextBtn.layer.cornerRadius = 10
        
        cancelBtn.layer.borderColor = UIColor.black.cgColor
        cancelBtn.layer.borderWidth = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        variantListApi()
    }
    
    func variantListApi() {
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        noProductView.isHidden = true
        noProductLbl.isHidden = true
        tableview.isHidden = true
        loadingIndicator.isAnimating = true
        
        ApiCalls.sharedCall.variantListCall(merchant_id: id) { isSuccess, responseData in
            
            
            if isSuccess {
                
                guard let list = responseData["result"] else {
                    return
                }
                
                self.getResponseValues(variant: list)
            }
            else {
                print("Api Error")
            }
        }
    }
    
    func getResponseValues(variant: Any) {
        
        let response = variant as! [[String:Any]]
        var varupc = [String]()
        var small = [InventoryVariant]()
        
        for res in response {
            
            let variant = InventoryVariant(id: "\(res["id"] ?? "")", costperItem: "\(res["costperItem"] ?? "")", title: "\(res["title"] ?? "")",
                                           isvarient: "\(res["isvarient"] ?? "")", upc: "\(res["upc"] ?? "")",
                                           cotegory: "\(res["cotegory"] ?? "")",
                                           var_id: "\(res["var_id"] ?? "")",
                                           var_upc: "\(res["var_upc"] ?? "")",
                                           quantity: "\(res["quantity"] ?? "")", price: "\(res["price"] ?? "")",
                                           custom_code: "\(res["custom_code"] ?? "")", variant: "\(res["variant"] ?? "")",
                                           var_price: "\(res["var_price"] ?? "")", is_lottery: "\(res["is_lottery"] ?? "")",
                                           var_costperItem: "\(res["var_costperItem"] ?? "")", brand: "\(res["brand"] ?? "")", brand_id: "\(res["brand_id"] ?? "")", tags: "\(res["tags"] ?? "")")
            
            if variant.is_lottery == "0" {
                small.append(variant)
                varupc.append(variant.upc)
                varupc.append(variant.var_upc)
            }
        }
        
        self.varUpc = varupc
        
        UserDefaults.standard.set(self.varUpc, forKey: "variant_upcs")
        
        variantList = small.sorted(by: {$0.id > $1.id})

        setCheckVariants()
    }
    
    func setCheckVariants() {
        
        var miniSelect = [VariantPOModel]()
        var select = [VariantPOModel]()
        var remainSelect = [InventoryVariant]()
        
        if autoSelectedVariants.count > 0 {
            
            for auto in variantList {
                
                if auto.isvarient == "1" {
                    
                    if let matched = autoSelectedVariants.first(where: {$0.variant_id == auto.var_id}) {
                        
                        var autovar = VariantPOModel(po: auto, isSelect: true, reqQty: matched.reorder_qty,
                                                     cost: "", note: "", afterQty: "",
                                                         total: "", orderItem: "", status: "0", pendingQty: "", check: "")
                        
                        if matched.preferd_vendor_cost == "" {
                            autovar.cost = "0.00"
                        }
                        else {
                            autovar.cost = matched.preferd_vendor_cost
                        }
                        
                        let after = (Int(matched.reorder_qty) ?? 0) + (Int(matched.item_qty) ?? 0)
                        let totat = (Double(matched.reorder_qty) ?? 0.00) * (Double(matched.preferd_vendor_cost) ?? 0.00)
                        autovar.total = String(format: "%.2f", totat)
                        autovar.afterQty = "\(after)"
                        select.append(autovar)
                    }
                    else {
                        remainSelect.append(auto)
                    }
                }
                else {
                    if let matched = autoSelectedVariants.first(where: {$0.product_id == auto.id}) {
                        
                        var autovar = VariantPOModel(po: auto, isSelect: true, reqQty: matched.reorder_qty,
                                                     cost: matched.preferd_vendor_cost, note: "", afterQty: "",
                                                         total: "", orderItem: "", status: "0", pendingQty: "", check: "")
                        
                        if matched.preferd_vendor_cost == "" {
                            autovar.cost = "0.00"
                        }
                        else {
                            autovar.cost = matched.preferd_vendor_cost
                        }
                        
                        let after = (Int(matched.reorder_qty) ?? 0) + (Int(matched.item_qty) ?? 0)
                        let totat = (Double(matched.reorder_qty) ?? 0.00) * (Double(matched.preferd_vendor_cost) ?? 0.00)
                        autovar.total = String(format: "%.2f", totat)
                        autovar.afterQty = "\(after)"
                        select.append(autovar)
                    }
                    else {
                        remainSelect.append(auto)
                    }
                }
            }
        }
        else {
            remainSelect = variantList
        }
        
        if poSelectedVariants.count > 0 {
            selected = poSelectedVariants
        }
        
        for main in remainSelect {
            if main.isvarient == "1" {
                if poSelectedVariants.contains(where: {$0.po.var_id == main.var_id}) {}
                else {
                    miniSelect.append(VariantPOModel(po: main, isSelect: false, reqQty: "",
                                                 cost: main.costperItem, note: "", afterQty: "",
                                                 total: "", orderItem: "", status: "0", pendingQty: "", check: ""))
                }
            }
            else {
                if poSelectedVariants.contains(where: {$0.po.id == main.id}) {}
                else if main.id == new_id {
                    select.append(VariantPOModel(po: main, isSelect: true, reqQty: "",
                                                             cost: main.costperItem, note: "", afterQty: "",
                                                             total: "", orderItem: "", status: "0", pendingQty: "", check: ""))
                }
                else {
                    miniSelect.append(VariantPOModel(po: main, isSelect: false, reqQty: "",
                                                 cost: main.costperItem, note: "", afterQty: "",
                                                 total: "", orderItem: "", status: "0", pendingQty: "", check: ""))
                }
            }
        }
        
        let m_select = [VariantPOModel]()
        
        if mode == "add" {
            poSelectedVariants = select + selected
            autoSelectedVariants = []
            
            variantPOList = select + selected + miniSelect
            subVariantPOList = select + selected + miniSelect
        }
        else {
            poSelectedVariants = select
            autoSelectedVariants = []
            
            variantPOList = select + miniSelect
            subVariantPOList = select + miniSelect
        }
        
        DispatchQueue.main.async {
            self.tableview.isHidden = false
            self.loadingIndicator.isAnimating = false
            self.tableview.reloadData()
        }
    }
    
    func unSelectVarient(match: VariantPOModel) {
        
        if match.po.isvarient == "1" {
            let index = poSelectedVariants.firstIndex(where: {$0.po.var_id == match.po.var_id}) ?? 0
            poSelectedVariants.remove(at: index)
        }
        else {
            let index = poSelectedVariants.firstIndex(where: {$0.po.id == match.po.id}) ?? 0
            poSelectedVariants.remove(at: index)
        }
    }
    
    func selectSubVariant(match: VariantPOModel, offset: Bool) {
        
        
        if match.po.isvarient == "1" {
            
            let index = subVariantPOList.firstIndex(where: {$0.po.var_id == match.po.var_id}) ?? 0
            subVariantPOList[index].isSelect = offset
            
        }
        else {
            let index = subVariantPOList.firstIndex(where: {$0.po.id == match.po.id}) ?? 0
            subVariantPOList[index].isSelect = offset
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination as! ItemsPOViewController
        vc.mode = mode
        vc.vendorSelect = vendor
        vc.poSelectedVariants = poSelectedVariants
    }
    
    
    @IBAction func backBtnClick(_ sender: UIButton) {
        if mode == "add" {
            navigationController?.popViewController(animated: true)
        }
        else {
            dismiss(animated: true)
        }
    }
    
    
    @IBAction func homebtnClick(_ sender: UIButton) {
        
        if mode == "add" {
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
    
    
    @IBAction func nextBtnClick(_ sender: UIButton) {
        
        if mode == "add" {
            guard poSelectedVariants.count > 0 else {
                ToastClass.sharedToast.showToast(message: "Please select atleast 1 variant", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                return
            }
            mode = "add"
            performSegue(withIdentifier: "toItemsPO", sender: nil)
        }
        else {
            dismiss(animated: true) {
                self.poSelectedVariants.append(contentsOf: self.selected)
                self.selectDelegate?.didSelectVariant(variant: self.poSelectedVariants)
            }
        }
    }
    
    
    @IBAction func scanBtnClick(_ sender: UIButton) {
        
        let vc = BarcodeScannerViewController()
        vc.codeDelegate = self
        vc.errorDelegate = self
        vc.dismissalDelegate = self
        searchMode = 1
        self.present(vc, animated: true)
    }
    
    
    @IBAction func addBtnClick(_ sender: UIButton) {
        
        view.endEditing(true)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "quick") as! QuickAddPOViewController
        
        var quick = QuickAddPO(upc: "", name: "",
                               price: "", cost: "",
                               quantity: "", category: "", tax: "1")
        if searchMode == 0 {
            quick.name = searchBarName.text ?? ""
        }
        else {
            quick.upc = searchBarUPC.text ?? ""
        }
        vc.quick = quick
        vc.delegate = self
        
        present(vc, animated: true)
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

extension POSelectViewController: AddQuickPODelegate {
    
    func addProduct(mode: Int, quick: QuickAddPO, category: [InventoryCategory], p_id: String) {
        
        if mode == 1 {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "filtercategory") as! FilterCategoryViewController
            
            quickAddSelect = quick
            
            vc.delegatePOSelected = self
            vc.catMode = "poQuickVc"
            vc.selectCategory = category
            vc.apiMode = "category"
            present(vc, animated: true)
        }
        else {
            searchBarName.text = ""
            searchBarUPC.text = ""
            searchBarName.resignFirstResponder()
            searchBarUPC.resignFirstResponder()
            searching = false
            if p_id != "" {
                new_id = p_id
            }
            else {
                new_id = ""
            }
            variantListApi()
        }
    }
}

extension POSelectViewController: SelectedCategoryProductsDelegate {
    
    func getProductsCategory(categoryArray: [InventoryCategory]) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "quick") as! QuickAddPOViewController
        
        vc.categoryPO = categoryArray
        vc.quick = quickAddSelect
        vc.delegate = self
        self.present(vc, animated: true)
    }
}

extension POSelectViewController: BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate {
    
    func scanner(_ controller: BarcodeScanner.BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        
        searchBarUPC.text = code
        searchMode = 1
        searchBarUPC.becomeFirstResponder()
        controller.dismiss(animated: true)
        performSearch(searchText: code)
    }
    
    func scanner(_ controller: BarcodeScanner.BarcodeScannerViewController, didReceiveError error: any Error) {
        print("failed")
        controller.dismiss(animated: true)
    }
    
    func scannerDidDismiss(_ controller: BarcodeScanner.BarcodeScannerViewController) {
        print("failed")
        controller.dismiss(animated: true)
    }
}

extension POSelectViewController : UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar == searchBarName {
            searchMode = 0
            searchBarName.isHidden = false
            searchBarUPC.isHidden = true
            searchBarName.showsCancelButton = true
            searchBarUPC.showsCancelButton = false
        }
        else {
            searchMode = 1
            searchBarName.isHidden = true
            searchBarUPC.isHidden = false
            searchBarName.showsCancelButton = false
            searchBarUPC.showsCancelButton = true
            scanBtn.isHidden = false
            scanWidth.constant = 64
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if searchBar == searchBarName {
            searchBarUPC.isHidden = false
            searchBarName.showsCancelButton = false
        }
        else {
            searchBarName.isHidden = false
            searchBarUPC.showsCancelButton = false
            scanWidth.constant = 0
            scanBtn.isHidden = true
        }
        searchBar.text = ""
        searchBar.resignFirstResponder()
        performSearch(searchText: "")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
         performSearch(searchText: searchText)
    }
    
    func performSearch(searchText: String) {
        
        if searchText == "" {
            searching = false
            
            if variantPOList.count == 0 {
                tableview.isHidden = true
                if mode == "add" {
                    noProductView.isHidden = false
                    noProductLbl.isHidden = true
                }
                else {
                    noProductView.isHidden = true
                    noProductLbl.isHidden = false
                }
            }
            else {
                tableview.isHidden = false
                noProductView.isHidden = true
                noProductLbl.isHidden = true
            }
        }
        else {
            searching = true
            
            searchVariantPOList = subVariantPOList.filter({ product in
                let searchTextLowercased = searchText.lowercased()
                let isTitleMatch = product.po.title.lowercased().contains(searchTextLowercased)
                let isUPCMatch = product.po.upc.lowercased() == searchTextLowercased
                let isVariantTitle = product.po.variant.lowercased() == searchTextLowercased
                let isVariantUPCMatch = product.po.var_upc.lowercased() == searchTextLowercased
                
                return isTitleMatch || isUPCMatch || isVariantTitle || isVariantUPCMatch })
            
            if searchVariantPOList.count == 0 {
                tableview.isHidden = true
                if mode == "add" {
                    noProductView.isHidden = false
                    noProductLbl.isHidden = true
                }
                else {
                    noProductView.isHidden = true
                    noProductLbl.isHidden = false
                }
            }
            else {
                tableview.isHidden = false
                noProductView.isHidden = true
                noProductLbl.isHidden = true
            }
        }
        tableview.reloadData()
    }
}



extension POSelectViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching {
            return searchVariantPOList.count
        }
        else {
            return variantPOList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if searching {
            
            let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SelectBogoVariantCell
            
            let variant = searchVariantPOList[indexPath.row]
            
            if variant.po.isvarient == "1" {
                
                let title = variant.po.title
                let variantName = variant.po.variant
                
//                if let range = title.range(of: variantName) {
//                    
//                    let separatedTitle = title.replacingCharacters(in: range, with: "").trimmingCharacters(in: .whitespaces)
//                    cell.titleLbl.text = separatedTitle
//                }
                cell.titleLbl.text = title
                cell.priceLbl.text = "UPC: \(variant.po.var_upc)" //$ \(variant.po.var_price)"
                cell.upcLabel.text = "" // variant.po.var_upc
                cell.varientLbl.text =  "Qty: \(variant.po.quantity)"
                cell.varientLbl.textColor = .black
                cell.priceLbl.font = UIFont(name: "Manrope-SemiBold", size: 12.0)
                
                let currentVarId = variant.po.var_id
                
                if variant.isSelect {
                    
                    cell.checkMarkImage.image = UIImage(named: "check inventory")
                }
                else if poSelectedVariants.contains(where: {$0.po.var_id == currentVarId}) {
                    cell.checkMarkImage.image = UIImage(named: "check inventory")
                }
                else {
                    cell.checkMarkImage.image = UIImage(named: "uncheck inventory")
                }
            }
            else {
                cell.titleLbl.text = variant.po.title
                cell.priceLbl.text = "UPC: \(variant.po.upc)" //$\(variant.po.price)"
                cell.upcLabel.text = "" //variant.po.upc
                cell.varientLbl.text = "Qty: \(variant.po.quantity)"
                cell.varientLbl.textColor = .black
                cell.priceLbl.font = UIFont(name: "Manrope-SemiBold", size: 12.0)
                
                let currentProdId = variant.po.id
                
                if variant.isSelect {
                    
                    cell.checkMarkImage.image = UIImage(named: "check inventory")
                }
                else if poSelectedVariants.contains(where: {$0.po.id == currentProdId})  {
                    
                    cell.checkMarkImage.image = UIImage(named: "check inventory")
                }
                else {
                    
                    cell.checkMarkImage.image = UIImage(named: "uncheck inventory")
                }
            }
            
            cell.contentView.backgroundColor = UIColor.white
            
            return cell
        }
        else {
            
            let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SelectBogoVariantCell
            
            let variant = variantPOList[indexPath.row]
            
            if variant.po.isvarient == "1" {
                                
                let title = variant.po.title
                let variantName = variant.po.variant
                
//                if let range = title.range(of: variantName) {
//                    
//                    let separatedTitle = title.replacingCharacters(in: range, with: "").trimmingCharacters(in: .whitespaces)
//                    cell.titleLbl.text = separatedTitle
//                }
                cell.titleLbl.text = title
                cell.priceLbl.text = "UPC: \(variant.po.var_upc)" //$\(variant.po.var_price)"
                cell.upcLabel.text = "" //variant.po.var_upc
                cell.varientLbl.text = "Qty: \(variant.po.quantity)"
                cell.varientLbl.textColor = .black
                cell.priceLbl.font = UIFont(name: "Manrope-SemiBold", size: 12.0)
                
                let currentVarId = variant.po.var_id
                
                if subVariantPOList[indexPath.row].isSelect {
                    
                    cell.checkMarkImage.image = UIImage(named: "check inventory")
                }
                else if poSelectedVariants.contains(where: {$0.po.var_id == currentVarId}) {
                    
                    cell.checkMarkImage.image = UIImage(named: "check inventory")
                }
                else {
                    
                    cell.checkMarkImage.image = UIImage(named: "uncheck inventory")
                }
            }
            else {
                
                cell.titleLbl.text = variant.po.title
                cell.priceLbl.text = "UPC: \(variant.po.upc)" //$\(variant.po.price)"
                cell.upcLabel.text = "" //variant.po.upc
                cell.varientLbl.text = "Qty: \(variant.po.quantity)"
                cell.varientLbl.textColor = .black
                cell.priceLbl.font = UIFont(name: "Manrope-SemiBold", size: 12.0)
                
                let currentProdId = variant.po.id
                
                if subVariantPOList[indexPath.row].isSelect  {
                    
                    cell.checkMarkImage.image = UIImage(named: "check inventory")
                }
                else if poSelectedVariants.contains(where: {$0.po.id == currentProdId}) {
                    
                    cell.checkMarkImage.image = UIImage(named: "check inventory")
                }
                else {
                    
                    cell.checkMarkImage.image = UIImage(named: "uncheck inventory")
                }
            }
            cell.contentView.backgroundColor = UIColor.white
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if searching {
            
            let cell = tableview.cellForRow(at: indexPath) as! SelectBogoVariantCell
            tableview.deselectRow(at: indexPath, animated: true)
            
            var variant = searchVariantPOList[indexPath.row]
            
            if  cell.checkMarkImage.image == UIImage(named: "uncheck inventory") {
                
                cell.checkMarkImage.image = UIImage(named: "check inventory")
                
                variant.isSelect = true
                selectSubVariant(match: variant, offset: true)
                poSelectedVariants.append(variant)
            }
            else {
                
                cell.checkMarkImage.image = UIImage(named: "uncheck inventory")
                
                variant.isSelect = false
                selectSubVariant(match: variant, offset: false)
                unSelectVarient(match: variant)
            }
        }
        else {
            
            let cell = tableview.cellForRow(at: indexPath) as! SelectBogoVariantCell
            tableview.deselectRow(at: indexPath, animated: true)
            
            var variant = variantPOList[indexPath.row]
            
            if  cell.checkMarkImage.image == UIImage(named: "uncheck inventory") {
                
                cell.checkMarkImage.image = UIImage(named: "check inventory")
                
                variant.isSelect = true
                selectSubVariant(match: variant, offset: true)
                poSelectedVariants.append(variant)
            }
            else {
                
                cell.checkMarkImage.image = UIImage(named: "uncheck inventory")
                
                variant.isSelect = false
                selectSubVariant(match: variant, offset: false)
                unSelectVarient(match: variant)
            }
        }
    }
}

struct QuickAddPO {
    
    var upc: String
    var name: String
    var price: String
    var cost: String
    var quantity: String
    var category: String
    var tax: String
}
