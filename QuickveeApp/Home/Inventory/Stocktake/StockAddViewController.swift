//
//  StockAddViewController.swift
//  
//
//  Created by Jamaluddin Syed on 11/11/24.
//

import UIKit
import BarcodeScanner


protocol StockAddDelegate: AnyObject {
    
    func stockAddCheck(variants: [InventoryVariant], addNewQty: [String],
                       disAdd: [String], noteAdd: [String])
}

protocol SelectedCategoryBrandsTagsProductsDelegate: AnyObject {
    
    func getProductsCategoryBrandTag(categoryArray: [InventoryCategory], brandArray: [String], tagArray: [String], filter: String)
}

class StockAddViewController: UIViewController {

    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tablview: UITableView!
    @IBOutlet weak var topview: UIView!
    
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var nextBtn: UIButton!
    
    
    @IBOutlet weak var noVariantView: UIView!
    
    @IBOutlet weak var noVarLbl: UILabel!
    
    @IBOutlet weak var scanBtn: UIButton!
    
    @IBOutlet weak var filterBlackView: UIView!
    @IBOutlet weak var filterInnerView: UIView!
    @IBOutlet weak var filterStack: UIStackView!
    
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var brandBtn: UIButton!
    @IBOutlet weak var tagBtn: UIButton!
    
    @IBOutlet weak var cancelFilterBtn: UIButton!
    @IBOutlet weak var applyFilterBtn: UIButton!
    
    var isCat = false
    var isBrand = false
    var isTag = false
    var isFilter = false
    
    var variantList = [InventoryVariant]()
    var subVariantList = [InventoryVariant]()
    var searchVariantList = [InventoryVariant]()
    var categoryVariantList = [InventoryVariant]()
    
    var selectAddStock = [InventoryVariant]()
    var newAddQty = [String]()
    var discrepancyAdd = [String]()
    var stock_Item_Id = [String]()
    var note = [String]()
    
    var stockList = [StockItem]()
    var substockList = [StockItem]()
    var searchStockList = [StockItem]()
    
    var searching = false
    var mode = ""
    
    var selectMode = ""
    var selectArray = [InventoryCategory]()
    var selectBrand = [String]()
    var selectTag = [String]()
        
    weak var delegate: StockDelegate?
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Start Typing UPC or Item Name"
        
        nextBtn.layer.cornerRadius = 10
        cancelBtn.layer.cornerRadius = 10
        
        cancelBtn.layer.borderWidth = 1
        cancelBtn.layer.borderColor = UIColor.black.cgColor
        
        cancelFilterBtn.layer.cornerRadius = 10
        applyFilterBtn.layer.cornerRadius = 10
        
        cancelFilterBtn.layer.borderWidth = 1
        cancelFilterBtn.layer.borderColor = UIColor.black.cgColor
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
        subVariantList = []
        categoryVariantList = []
        filterBlackView.isHidden = true
        categoryBtn.setTitleColor(.black, for: .normal)
        categoryBtn.layer.borderColor = UIColor.black.cgColor
        categoryBtn.layer.borderWidth = 1
        categoryBtn.layer.cornerRadius = 10
        brandBtn.setTitleColor(.black, for: .normal)
        brandBtn.layer.borderColor = UIColor.black.cgColor
        brandBtn.layer.borderWidth = 1
        brandBtn.layer.cornerRadius = 10
        tagBtn.setTitleColor(.black, for: .normal)
        tagBtn.layer.borderColor = UIColor.black.cgColor
        tagBtn.layer.borderWidth = 1
        tagBtn.layer.cornerRadius = 10
        
        variantListApi()
    }
    
    
    func variantListApi() {
        
        loadingIndicator.isAnimating = true
        tablview.isHidden = true
        noVarLbl.isHidden = true
        noVariantView.isHidden = true
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        ApiCalls.sharedCall.variantListCall(merchant_id: id) { isSuccess, responseData in
            
            if isSuccess {
                
                guard let list = responseData["result"] else {
                    return
                }
                self.getResponseValues(varient: list)
                
                DispatchQueue.main.async {
                    
                    self.loadingIndicator.isAnimating = false
                    self.tablview.isHidden = false
                    self.tablview.reloadData()
                }
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
            
            let variant = InventoryVariant(id: "\(res["id"] ?? "")", costperItem: "\(res["costperItem"] ?? "")", title: "\(res["title"] ?? "")",
                                           isvarient: "\(res["isvarient"] ?? "")", upc: "\(res["upc"] ?? "")",
                                           cotegory: "\(res["cotegory"] ?? "")",
                                           var_id: "\(res["var_id"] ?? "")",
                                           var_upc: "\(res["var_upc"] ?? "")",
                                           quantity: "\(res["quantity"] ?? "")", price: "\(res["price"] ?? "")",
                                           custom_code: "\(res["custom_code"] ?? "")", variant: "\(res["variant"] ?? "")",
                                           var_price: "\(res["var_price"] ?? "")", is_lottery: "\(res["is_lottery"] ?? "")",
                                           var_costperItem: "\(res["var_costperItem"] ?? "")", brand: "\(res["brand"] ?? "")",
                                           brand_id: "\(res["brand_id"] ?? "")", tags: "\(res["tags"] ?? "")")
            
            small.append(variant)
        }
        
        variantList = small
        subVariantList = small
        categoryVariantList = small
    }
    
    func removeVariant(variant: InventoryVariant) {
        
        if variant.isvarient == "1" {
            let pos = selectAddStock.firstIndex(where: {$0.var_id == variant.var_id})
            selectAddStock.remove(at: pos ?? 0)
            newAddQty.remove(at: pos ?? 0)
            discrepancyAdd.remove(at: pos ?? 0)
            note.remove(at: pos ?? 0)
            stock_Item_Id.remove(at: pos ?? 0)
        }
        else {
            let pos = selectAddStock.firstIndex(where: {$0.id == variant.id})
            selectAddStock.remove(at: pos ?? 0)
            newAddQty.remove(at: pos ?? 0)
            discrepancyAdd.remove(at: pos ?? 0)
            note.remove(at: pos ?? 0)
            stock_Item_Id.remove(at: pos ?? 0)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toStockSave" {
            let vc = segue.destination as! StockSaveViewController
            vc.stockItemsList = selectAddStock
            vc.addNewQty = newAddQty
            vc.discrepancyAdd = discrepancyAdd
            vc.note = note
            vc.mode = "add"
            vc.delegate = self
        }
    }
    
    
    @IBAction func nextBtnClick(_ sender: UIButton) {
        
        if selectMode == "select" {
            if selectAddStock.count == 0 {
                ToastClass.sharedToast.showToast(message: "No Variants Selected", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            }
            else {
                delegate?.stockCheck(variants: selectAddStock, addNew: newAddQty,
                                     discrepancy: discrepancyAdd, item_id: stock_Item_Id, notes: note)
                dismiss(animated: true)
            }
        }
        else {
            if selectAddStock.count == 0 {
                ToastClass.sharedToast.showToast(message: "No Variants Selected", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            }
            else {
                mode = "add"
                performSegue(withIdentifier: "toStockSave", sender: nil)
            }
        }
    }
    

    @IBAction func backBtnClick(_ sender: UIButton) {
        
        if selectMode == "select" {
            dismiss(animated: true)
        }
        else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    
    @IBAction func homeBtnClick(_ sender: UIButton) {
        
        
        if selectMode == "select" {
            dismiss(animated: true)
        }
        else {
            var destiny = 0
            
            let viewcontrollerArray = navigationController?.viewControllers
            
            if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is HomeViewController }) {
                destiny = destinationIndex
            }
            
            navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
        }
    }
    
    
    @IBAction func scanBtnClick(_ sender: UIButton) {
        
        let vc = BarcodeScannerViewController()
        vc.codeDelegate = self
        vc.errorDelegate = self
        vc.dismissalDelegate = self
        
        self.present(vc, animated: true)
        
    }
    
    
    @IBAction func filterBtnClick(_ sender: UIButton) {
        filterBlackView.isHidden.toggle()
    }
    
    
    @IBAction func categoryFilterClick(_ sender: UIButton) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "filtercategory") as! FilterCategoryViewController
        vc.catMode = "StockVc"
        vc.delegateStockTakeAdd = self
        vc.selectCategory = selectArray
        vc.apiMode = "category"
        vc.stockFilter = "cat"
        present(vc, animated: true)
    }
    
    
    @IBAction func brandFilterClick(_ sender: UIButton) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "filtercategory") as! FilterCategoryViewController
        vc.catMode = "StockVc"
        vc.delegateStockTakeAdd = self
        vc.selectBrandsTags = selectBrand
        vc.apiMode = "brands"
        vc.stockFilter = "brand"
        present(vc, animated: true)
    }
    
    
    @IBAction func tagFilterClick(_ sender: UIButton) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "filtercategory") as! FilterCategoryViewController
        vc.catMode = "StockVc"
        vc.delegateStockTakeAdd = self
        vc.selectBrandsTags = selectTag
        vc.apiMode = "tags"
        vc.stockFilter = "tag"
        present(vc, animated: true)
    }
    
    
    @IBAction func cancelFilterBtnClick(_ sender: UIButton) {
        filterBlackView.isHidden.toggle()
    }
    
    
    @IBAction func applyFilterBtnClick(_ sender: UIButton) {
        
        filterBlackView.isHidden.toggle()
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


extension StockAddViewController: BarcodeScannerCodeDelegate, BarcodeScannerDismissalDelegate, BarcodeScannerErrorDelegate {
    
    
    func scanner(_ controller: BarcodeScanner.BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        
        searchBar.text = code
        
        searchBar.becomeFirstResponder()
        controller.dismiss(animated: true)
        
        performSearch(searchText: code)

    }
    
    func scannerDidDismiss(_ controller: BarcodeScanner.BarcodeScannerViewController) {
        print("dismiss")
    }
    
    func scanner(_ controller: BarcodeScanner.BarcodeScannerViewController, didReceiveError error: any Error) {
        print(error.localizedDescription)
    }
}




extension StockAddViewController: StockAddDelegate {
    
    func stockAddCheck(variants: [InventoryVariant], addNewQty: [String], disAdd: [String], noteAdd: [String]) {
        
        selectAddStock = variants
        newAddQty = addNewQty
        discrepancyAdd = disAdd
        note = noteAdd
        
        tablview.reloadData()
        
    }
}

extension StockAddViewController: SelectedCategoryBrandsTagsProductsDelegate {
    
    func getProductsCategoryBrandTag(categoryArray: [InventoryCategory], brandArray: [String], tagArray: [String], filter: String) {
        
        if filter == "cat" {
            selectArray = categoryArray
        }
        else if filter == "brand" {
            selectBrand = brandArray
        }
        else {
            selectTag = tagArray
        }
        
        if selectArray.count == 0 {
            isCat = false
            categoryBtn.setTitleColor(.black, for: .normal)
            categoryBtn.layer.borderColor = UIColor.black.cgColor
        }
        else {
            isCat = true
            categoryBtn.setTitleColor(UIColor(named: "SelectCat"), for: .normal)
            categoryBtn.layer.borderColor = UIColor(named: "SelectCat")?.cgColor
        }
        
        if selectBrand.count == 0 {
            isBrand = false
            brandBtn.setTitleColor(.black, for: .normal)
            brandBtn.layer.borderColor = UIColor.black.cgColor
        }
        else {
            isBrand = true
            brandBtn.setTitleColor(UIColor(named: "SelectCat"), for: .normal)
            brandBtn.layer.borderColor = UIColor(named: "SelectCat")?.cgColor
        }
        
        if selectTag.count == 0 {
            isTag = false
            tagBtn.setTitleColor(.black, for: .normal)
            tagBtn.layer.borderColor = UIColor.black.cgColor
        }
        else {
            isTag = true
            tagBtn.setTitleColor(UIColor(named: "SelectCat"), for: .normal)
            tagBtn.layer.borderColor = UIColor(named: "SelectCat")?.cgColor
        }
        
        if selectArray.count == 0 && selectBrand.count == 0 && selectTag.count == 0 {
            isFilter = false
            variantListApi()
        }
        else {
            tablview.isHidden = true
            loadingIndicator.isAnimating = true
            isFilter = true
            setupFilterApi()
        }
    }
    
    func setupFilterApi() {
        
        var semi_variants = [InventoryVariant]()
        var semi_semi_variants = [InventoryVariant]()
        var semi_semi_semi_variants = [InventoryVariant]()
        
        if isCat && isBrand && isTag {
            
            for variant in variantList {
                if variant.cotegory.contains(",") {
                    
                    let comma_cat = variant.cotegory.components(separatedBy: ",")
                    
                    for comma in comma_cat {
                        if selectArray.contains(where: {$0.id == comma}) {
                            semi_variants.append(variant)
                        }
                    }
                }
                else {
                    if selectArray.contains(where: {$0.id == variant.cotegory}) {
                        semi_variants.append(variant)
                    }
                }
            }

            for variant in semi_variants {
                if variant.brand.contains(selectBrand[0]) {
                    semi_semi_variants.append(variant)
                }
            }
            
            for variant in semi_semi_variants {
                
                if variant.tags.contains(",") {
                    
                    let comma_cat = variant.tags.components(separatedBy: ",")
                    
                    for comma in comma_cat {
                        if selectTag.contains(where: {$0 == comma}) {
                            semi_semi_semi_variants.append(variant)
                        }
                    }
                }
                else {
                    if selectTag.contains(where: {$0 == variant.tags}) {
                        semi_semi_semi_variants.append(variant)
                    }
                }
            }
            categoryVariantList = semi_semi_semi_variants
        }
        
        else if isCat && isBrand {
            
            for variant in variantList {
                if variant.cotegory.contains(",") {
                    
                    let comma_cat = variant.cotegory.components(separatedBy: ",")
                    
                    for comma in comma_cat {
                        if selectArray.contains(where: {$0.id == comma}) {
                            semi_variants.append(variant)
                        }
                    }
                }
                else {
                    if selectArray.contains(where: {$0.id == variant.cotegory}) {
                        semi_variants.append(variant)
                    }
                }
            }

            for variant in semi_variants {
                if variant.brand.contains(selectBrand[0]) {
                    semi_semi_variants.append(variant)
                }
            }
            
            categoryVariantList = semi_semi_variants
        }
        
        else if isCat && isTag {
            
            for variant in variantList {
                if variant.cotegory.contains(",") {
                    
                    let comma_cat = variant.cotegory.components(separatedBy: ",")
                    
                    for comma in comma_cat {
                        if selectArray.contains(where: {$0.id == comma}) {
                            semi_variants.append(variant)
                        }
                    }
                }
                else {
                    if selectArray.contains(where: {$0.id == variant.cotegory}) {
                        semi_variants.append(variant)
                    }
                }
            }
            
            for variant in semi_variants {
                
                if variant.tags.contains(",") {
                    
                    let comma_cat = variant.tags.components(separatedBy: ",")
                    
                    for comma in comma_cat {
                        if selectTag.contains(where: {$0 == comma}) {
                            semi_semi_variants.append(variant)
                        }
                    }
                }
                else {
                    if selectTag.contains(where: {$0 == variant.tags}) {
                        semi_semi_variants.append(variant)
                    }
                }
            }
            categoryVariantList = semi_semi_variants
        }
        
        else if isBrand && isTag {
            
            for variant in variantList {
                if variant.brand.contains(selectBrand[0]) {
                    semi_variants.append(variant)
                }
            }
            
            for variant in semi_variants {
                
                if variant.tags.contains(",") {
                    
                    let comma_cat = variant.tags.components(separatedBy: ",")
                    
                    for comma in comma_cat {
                        if selectTag.contains(where: {$0 == comma}) {
                            semi_semi_variants.append(variant)
                        }
                    }
                }
                else {
                    if selectTag.contains(where: {$0 == variant.tags}) {
                        semi_semi_variants.append(variant)
                    }
                }
            }
            categoryVariantList = semi_semi_variants
        }
        
        else if isCat {
            
            for variant in variantList {
                if variant.cotegory.contains(",") {
                    
                    let comma_cat = variant.cotegory.components(separatedBy: ",")
                    
                    for comma in comma_cat {
                        if selectArray.contains(where: {$0.id == comma}) {
                            semi_variants.append(variant)
                        }
                    }
                }
                else {
                    if selectArray.contains(where: {$0.id == variant.cotegory}) {
                        semi_variants.append(variant)
                    }
                }
            }
            
            categoryVariantList = semi_variants
        }
        
        else if isBrand {
            
            for variant in variantList {
                if variant.brand.contains(selectBrand[0]) {
                    semi_variants.append(variant)
                }
            }
            categoryVariantList = semi_variants
        }
        
        else if isTag {
            
            for variant in variantList {
                
                if variant.tags.contains(",") {
                    
                    let comma_cat = variant.tags.components(separatedBy: ",")
                    
                    for comma in comma_cat {
                        if selectTag.contains(where: {$0 == comma}) {
                            semi_variants.append(variant)
                        }
                    }
                }
                else {
                    if selectTag.contains(where: {$0 == variant.tags}) {
                        semi_variants.append(variant)
                    }
                }
            }
            
            categoryVariantList = semi_variants
        }
        
        tablview.isHidden = false
        loadingIndicator.isAnimating = false
        tablview.reloadData()
    }
}

extension StockAddViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        performSearch(searchText: searchText)
    }
    
    
    
    func performSearch(searchText: String) {
        
        if searchText == "" {
            searching = false
            tablview.isHidden = false
            noVarLbl.isHidden = true
            noVariantView.isHidden = true
        }
        else {
            searching = true
            searchVariantList = subVariantList.filter {
                
                let searchTextLowercased = searchText.lowercased()
                let isName = $0.title.lowercased().contains(searchTextLowercased)
                let isUPC = $0.upc.lowercased().contains(searchTextLowercased)
                let isVUPC = $0.var_upc.lowercased().contains(searchTextLowercased)
                
                return isName || isUPC || isVUPC
            }
            
            if searchVariantList.count == 0 {
                tablview.isHidden = true
                noVarLbl.isHidden = false
                noVariantView.isHidden = false
            }
            else {
                tablview.isHidden = false
                noVarLbl.isHidden = true
                noVariantView.isHidden = true
            }
        }
        tablview.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searching = false
        tablview.reloadData()
    }
}

extension StockAddViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching {
            return searchVariantList.count

        }
        else {
            if isFilter {
                return categoryVariantList.count
            }
            else {
                return variantList.count
            }

        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if searching {
            
            let cell = tablview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StockAddTableViewCell
            
            let variant = searchVariantList[indexPath.row]
            cell.nameLbl.text = variant.title
            
            if variant.isvarient == "1" {
                cell.upcLbl.text = "UPC: \(variant.var_upc)"
                
                if selectAddStock.contains(where: {$0.var_id == variant.var_id}) {
                    cell.check.image = UIImage(named: "check inventory")
                }
                else {
                    cell.check.image = UIImage(named: "uncheck inventory")
                }
            }
            else {
                cell.upcLbl.text = "UPC: \(variant.upc)"
                
                if selectAddStock.contains(where: {$0.id == variant.id}) {
                    cell.check.image = UIImage(named: "check inventory")
                }
                else {
                    cell.check.image = UIImage(named: "uncheck inventory")
                }
            }
            
            return cell
        }
        
        else {
            
            if isFilter {
                
                let cell = tablview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StockAddTableViewCell
                
                let variant = categoryVariantList[indexPath.row]
                cell.nameLbl.text = variant.title
                
                if variant.isvarient == "1" {
                    cell.upcLbl.text = "UPC: \(variant.var_upc)"
                    
                    if selectAddStock.contains(where: {$0.var_id == variant.var_id}) {
                        cell.check.image = UIImage(named: "check inventory")
                    }
                    else {
                        cell.check.image = UIImage(named: "uncheck inventory")
                    }
                }
                else {
                    cell.upcLbl.text = "UPC: \(variant.upc)"
                    
                    if selectAddStock.contains(where: {$0.id == variant.id}) {
                        cell.check.image = UIImage(named: "check inventory")
                    }
                    else {
                        cell.check.image = UIImage(named: "uncheck inventory")
                    }
                }
                
                return cell
            }
            else {
                
                let cell = tablview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StockAddTableViewCell
                
                let variant = variantList[indexPath.row]
                cell.nameLbl.text = variant.title
                
                if variant.isvarient == "1" {
                    cell.upcLbl.text = "UPC: \(variant.var_upc)"
                    
                    if selectAddStock.contains(where: {$0.var_id == variant.var_id}) {
                        cell.check.image = UIImage(named: "check inventory")
                    }
                    else {
                        cell.check.image = UIImage(named: "uncheck inventory")
                    }
                }
                else {
                    cell.upcLbl.text = "UPC: \(variant.upc)"
                    
                    if selectAddStock.contains(where: {$0.id == variant.id}) {
                        cell.check.image = UIImage(named: "check inventory")
                    }
                    else {
                        cell.check.image = UIImage(named: "uncheck inventory")
                    }
                }
                
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tablview.deselectRow(at: indexPath, animated: true)
        
        let cell = tablview.cellForRow(at: indexPath) as! StockAddTableViewCell
        
        if searching {
            
            if cell.check.image == UIImage(named: "uncheck inventory") {
                cell.check.image = UIImage(named: "check inventory")
                selectAddStock.append(searchVariantList[indexPath.row])
                newAddQty.append("")
                discrepancyAdd.append("")
                note.append("")
                stock_Item_Id.append("")
            }
            else {
                cell.check.image = UIImage(named: "uncheck inventory")
                removeVariant(variant: searchVariantList[indexPath.row])
            }
        }
        
        else {
            
            if isFilter {
                
                if cell.check.image == UIImage(named: "uncheck inventory") {
                    cell.check.image = UIImage(named: "check inventory")
                    selectAddStock.append(categoryVariantList[indexPath.row])
                    newAddQty.append("")
                    discrepancyAdd.append("")
                    note.append("")
                    stock_Item_Id.append("")
                }
                else {
                    cell.check.image = UIImage(named: "uncheck inventory")
                    removeVariant(variant: categoryVariantList[indexPath.row])
                }
            }
            else {
                
                if cell.check.image == UIImage(named: "uncheck inventory") {
                    cell.check.image = UIImage(named: "check inventory")
                    selectAddStock.append(variantList[indexPath.row])
                    newAddQty.append("")
                    discrepancyAdd.append("")
                    note.append("")
                    stock_Item_Id.append("")
                }
                else {
                    cell.check.image = UIImage(named: "uncheck inventory")
                    removeVariant(variant: variantList[indexPath.row])
                }
            }
        }
    }
}
