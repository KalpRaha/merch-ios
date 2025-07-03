//
//  VariantViewController.swift
//
//
//  Created by Jamaluddin Syed on 9/7/23.
//

import UIKit

class VariantViewController: UIViewController {
    
    @IBOutlet weak var lblSelectCat: UILabel!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var var_LabelFilter: UILabel!
    
    @IBOutlet weak var filterView: UIView!
    
    @IBOutlet weak var filterHeight: NSLayoutConstraint!
    @IBOutlet weak var noDataLbl: UILabel!
    
    @IBOutlet weak var noData: UIImageView!
    
    var variantList = [InventoryVariant]()
    var subVarArray = [InventoryVariant]()
    var filterVarArray = [InventoryVariant]()
    var searchVarArray = [InventoryVariant]()
    
    var varUpc = [String]()
    var searching = false
    var selectArray = [InventoryCategory]()
    
    var nameVar = ""
    var var_id = ""
    var is_single = ""
    var prodId = ""
    
    var searchpage = 0
    var page = 0
    var searchTxt = ""
    var nameupcvar = ""
    var searchMode = false
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cat_tap = UITapGestureRecognizer(target: self, action: #selector(openCatScreen))
        var_LabelFilter.addGestureRecognizer(cat_tap)
        cat_tap.numberOfTapsRequired = 1
        var_LabelFilter.isUserInteractionEnabled = true
        
        tableview.showsVerticalScrollIndicator = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UserDefaults.standard.set(true, forKey: "var_api_hit")
        
        lblSelectCat.layer.cornerRadius = 6.0
        lblSelectCat.layer.masksToBounds = true
        
        tableview.isHidden = true
        noData.isHidden = true
        noData.image = UIImage(named: "No Data")
        noDataLbl.isHidden = true
        noDataLbl.text = "No Variant Added"
        
        subVarArray = []
        searchVarArray = []
        searching = false
        setupUI()
        loadingIndicator.isAnimating = true
        
        UserDefaults.standard.set(false, forKey: "incategory")
        UserDefaults.standard.set(false, forKey: "inproducts")
        UserDefaults.standard.set(false, forKey: "inattribute")
        UserDefaults.standard.set(true, forKey: "invariant")
        UserDefaults.standard.set(false, forKey: "inbrands")
        UserDefaults.standard.set(false, forKey: "intags")

        
        setupVariantApi()
        lblSelectCat.text = ""
        
    }
    
    @objc func openCatScreen() {
        openCat()
        
    }
    
    func openCat() {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "filtercategory") as! FilterCategoryViewController
        vc.catMode = "VariantVc"
        vc.delegateVariants = self
        vc.selectCategory = selectArray
        vc.variantList = variantList
        vc.apiMode = "category"
        
        present(vc, animated: true, completion: {
            vc.presentationController?.presentedView?.gestureRecognizers?[0].isEnabled = false
        })
    }
   
    
    func setupVariantApi() {
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        page = 1

        var catid = ""
        var idarr = [String]()
        if selectArray.count > 0 {
            
            for select in selectArray {
                idarr.append(select.id)
            }
            catid = idarr.joined(separator: ",")
        }
        else {
            catid = ""
        }
        
        ApiCalls.sharedCall.variantListCallPage(merchant_id: id, search_by_name: "",
                                                search_by_upc: "", cat_ids: catid,
                                                page: 1) { isSuccess, responseData in
            
            if isSuccess {
                
                guard let list = responseData["result"] else {
                    return
                }
                self.getResponseValues(list: list)
                
            }else{
                print("Api Error")
            }
        }
    }
    
    
    func getResponseValues(list: Any) {
        
        let response = list as! [[String:Any]]
        var smallres = [InventoryVariant]()
        for res in response {
            
            let variant = InventoryVariant(id: "\(res["id"] ?? "")", costperItem: "\(res["costperItem"] ?? "")", title: "\(res["title"] ?? "")",
                                           isvarient: "\(res["isvarient"] ?? "")", upc: "\(res["upc"] ?? "")",
                                           cotegory: "\(res["cotegory"] ?? "")",
                                           var_id: "\(res["var_id"] ?? "")",
                                           var_upc: "\(res["var_upc"] ?? "")",
                                           quantity: "\(res["quantity"] ?? "")", price: "\(res["price"] ?? "")",
                                           custom_code: "\(res["custom_code"] ?? "")", variant: "\(res["variant"] ?? "")",
                                           var_price: "\(res["var_price"] ?? "")", is_lottery: "\(res["is_lottery"] ?? "")",
                                           var_costperItem: "\(res["var_costperItem"] ?? "")")
            
            
            smallres.append(variant)
        }
        
        variantList = smallres.reversed()
        subVarArray = variantList
        searchVarArray = variantList
        filterVarArray = variantList
        
        setupUpc()
        
    }
    
    func setupUpc() {
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        ApiCalls.sharedCall.variantListCall(merchant_id: id) { isSuccess, responseData in
            
            if isSuccess {
                
                guard let list = responseData["result"] else {
                    return
                }
            
                let response = list as! [[String:Any]]
                var varupc = [String]()
                for res in response {
                    
                    let variant = InventoryVariant(id: "\(res["id"] ?? "")", costperItem: "\(res["costperItem"] ?? "")", title: "\(res["title"] ?? "")",
                                                   isvarient: "\(res["isvarient"] ?? "")", upc: "\(res["upc"] ?? "")",
                                                   cotegory: "\(res["cotegory"] ?? "")",
                                                   var_id: "\(res["var_id"] ?? "")",
                                                   var_upc: "\(res["var_upc"] ?? "")",
                                                   quantity: "\(res["quantity"] ?? "")", price: "\(res["price"] ?? "")",
                                                   custom_code: "\(res["custom_code"] ?? "")", variant: "\(res["variant"] ?? "")",
                                                   var_price: "\(res["var_price"] ?? "")", is_lottery: "\(res["is_lottery"] ?? "")",
                                                   var_costperItem: "\(res["var_costperItem"] ?? "")")
                    
                    
                    
                    varupc.append(variant.upc)
                    varupc.append(variant.var_upc)
                }
                
                self.varUpc = varupc
                
                UserDefaults.standard.set(self.varUpc, forKey: "variant_upcs")
                   
            }else{
                print("Api Error")
            }
            
            DispatchQueue.main.async {
                
                if self.variantList.count == 0 {
                    
                    self.tableview.isHidden = true
                    self.loadingIndicator.isAnimating = false
                    self.filterView.isHidden = true
                    self.filterHeight.constant = 0
                    self.noData.isHidden = false
                    self.noDataLbl.isHidden = false
                    self.noDataLbl.text = "No Variants Added"
                }
                
                else {
                    self.tableview.isHidden = false
                    self.loadingIndicator.isAnimating = false
                    self.filterView.isHidden = false
                    self.filterHeight.constant = 25
                    self.noData.isHidden = true
                    self.noDataLbl.isHidden = true
                    self.noDataLbl.text = "No Variants Added"
                    self.tableview.reloadData()
                }
            }
        }
    }
    
    func getResponsePageValues(response: Any) {
        
        let responsevalues = response as! [[String:Any]]
        
        var variantArr = [InventoryVariant]()
        
        for res in responsevalues {
            
            let variant = InventoryVariant(id: "\(res["id"] ?? "")", costperItem: "\(res["costperItem"] ?? "")", title: "\(res["title"] ?? "")",
                                           isvarient: "\(res["isvarient"] ?? "")", upc: "\(res["upc"] ?? "")",
                                           cotegory: "\(res["cotegory"] ?? "")",
                                           var_id: "\(res["var_id"] ?? "")",
                                           var_upc: "\(res["var_upc"] ?? "")",
                                           quantity: "\(res["quantity"] ?? "")", price: "\(res["price"] ?? "")",
                                           custom_code: "\(res["custom_code"] ?? "")", variant: "\(res["variant"] ?? "")",
                                           var_price: "\(res["var_price"] ?? "")", is_lottery: "\(res["is_lottery"] ?? "")",
                                           var_costperItem: "\(res["var_costperItem"] ?? "")")
            
            variantArr.append(variant)
            
        }
        
        if searching {
            if variantArr.count == 0 {
                searchpage -= 1
            }
            else {
                searchVarArray.append(contentsOf: variantArr)
            }
        }
        else {
            if variantArr.count == 0 {
                page -= 1
            }
            else {
                variantList.append(contentsOf: variantArr)
                subVarArray.append(contentsOf: variantArr)
                filterVarArray.append(contentsOf: variantArr)
            }
        }
        tableview.reloadData()
    }
    
    func searchApi(search: String, nameupc: String) {
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        searchpage = 1
        page = 1
        
        var name = ""
        var upc = ""
        
        if nameupc == "1" {
            name = search
            upc = ""
        }
        else {
            name = ""
            upc = search
        }
        
        var catid = ""
        var idarr = [String]()
        if selectArray.count > 0 {
            
            for select in selectArray {
                idarr.append(select.id)
            }
            catid = idarr.joined(separator: ",")
        }
        else {
            catid = ""
        }
        
        ApiCalls.sharedCall.variantListCallSearch(merchant_id: id, search_by_name: name,
                                                  search_by_upc: upc, cat_ids: catid, page: 1, limit: 30)
        { isSuccess, responseData in
        
            if isSuccess {
                
                self.getResponseValues(list: responseData["result"])
                
                DispatchQueue.main.async {
                    
                    if self.variantList.count == 0 {
                        
                        self.tableview.isHidden = true
                        self.loadingIndicator.isAnimating = false
                        self.filterView.isHidden = true
                        self.noData.isHidden = false
                        self.noDataLbl.isHidden = false
                        self.noDataLbl.text = "No Variants Added"
                    }
                    
                    else {
                        self.tableview.isHidden = false
                        self.loadingIndicator.isAnimating = false
                        self.filterView.isHidden = false
                        self.noData.isHidden = true
                        self.noDataLbl.isHidden = true
                        self.noDataLbl.text = "No Variants Added"
                    }
                }
                
                if self.searchMode {
                    self.searching = true
                    self.filterView.isHidden = true
                    self.filterHeight.constant = 0
                }
                else {
                    self.searching = false
                    self.filterView.isHidden = false
                    self.filterHeight.constant = 25
                }
                self.tableview.reloadData()
            }
            
            else{
                print("Api Error")
            }
        }
    }
    
    
    func performSearch(searchText: String, nameupc: String) {
        
        if searchMode {
            
            if searchText == "" {
                tableview.isHidden = true
                loadingIndicator.isAnimating = false
                searchTxt = searchText
                nameupcvar = nameupc
            }
            else {
                tableview.isHidden = true
                loadingIndicator.isAnimating = true
                searchTxt = searchText
                nameupcvar = nameupc
                searchApi(search: searchText, nameupc: nameupc)
            }
        }
        else {
            tableview.isHidden = true
            loadingIndicator.isAnimating = true
            setupVariantApi()
        }
        tableview.reloadData()
    }
    
    
    func setupFilterApi() {
        
        var semi_variants = [InventoryVariant]()
        
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
        
        filterVarArray = semi_variants
        
        tableview.isHidden = false
        loadingIndicator.isAnimating = false
        tableview.reloadData()
    }
    
    @IBAction func filterCategoryClick(_ sender: UIButton) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "filtercategory") as! FilterCategoryViewController
        vc.catMode = "VariantVc"
        vc.selectCategory = selectArray
        vc.delegateVariants = self
        vc.variantList = variantList
        vc.apiMode = "category"
        
        present(vc, animated: true, completion: {
            vc.presentationController?.presentedView?.gestureRecognizers?[0].isEnabled = false
        })
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination as! VariantInfoViewController
        vc.v_name = nameVar
        vc.v_id = var_id
        vc.is_v = is_single
        vc.p_id = prodId
        
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
    
    @objc func keyboardWillShow(notification:NSNotification) {
        
        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.tableview.contentInset
        contentInset.bottom = keyboardFrame.size.height
        tableview.contentInset.bottom = contentInset.bottom
    }
    
    @objc func keyboardWillHide(notification:NSNotification) {
        
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        tableview.contentInset = contentInset
        
    }
}


extension VariantViewController {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)  {
        
        if searching {
            
            if let visiblePaths = tableview.indexPathsForVisibleRows,
               visiblePaths.contains([0, searchVarArray.count - 1]) {
                
                let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
                
                searchpage += 1
                
                var name = ""
                var upc = ""
                
                if nameupcvar == "1" {
                    name = searchTxt
                    upc = ""
                }
                else {
                    name = ""
                    upc = searchTxt
                }
                
                var catid = ""
                var idarr = [String]()
                if selectArray.count > 0 {
                    
                    for select in selectArray {
                        idarr.append(select.id)
                    }
                    catid = idarr.joined(separator: ",")
                }
                else {
                    catid = ""
                }
                
                ApiCalls.sharedCall.variantListCallSearch(merchant_id: id, search_by_name: name,
                                                          search_by_upc: upc, cat_ids: catid, page: searchpage, limit: 30)
                 { isSuccess, responseData in
                    
                    if isSuccess {
                        
                        self.getResponsePageValues(response: responseData["result"])
                    }else{
                        print("Api Error")
                    }
                }
            }
            
        }
        
        else {
            
            
            if let visiblePaths = tableview.indexPathsForVisibleRows,
               visiblePaths.contains([0, variantList.count - 1]) {
                
                let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
                
                page += 1
                
                var catid = ""
                var idarr = [String]()
                if selectArray.count > 0 {
                    
                    for select in selectArray {
                        idarr.append(select.id)
                    }
                    catid = idarr.joined(separator: ",")
                }
                else {
                    catid = ""
                }
                
                ApiCalls.sharedCall.variantListCallPage(merchant_id: id, search_by_name: "",
                                                        search_by_upc: "", cat_ids: catid,
                                                        page: page) { isSuccess, responseData in
                    
                    if isSuccess {
                        
                        self.getResponsePageValues(response: responseData["result"])
                    }else{
                        print("Api Error")
                    }
                }
            }
        }
    }
}

extension VariantViewController: SelectedCategoryProductsDelegate {
    
    func getProductsCategory(categoryArray: [InventoryCategory]) {
        
        selectArray = categoryArray
        
        tableview.isHidden = true
        loadingIndicator.isAnimating = true
        
        if selectArray.count == 0 {
            setupVariantApi()
            lblSelectCat.text = ""
        }
        else {
            //setupFilterApi()
            setupVariantApi()
            lblSelectCat.text = "   \(selectArray.count)   "
        }
    }
}

extension VariantViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching {
            return searchVarArray.count
        }
        
        
        else {
            
            if selectArray.count == 0 {
                
                return variantList.count
            }
            
            else {
                return filterVarArray.count
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if searching {
            
            
            let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! VariantTableViewCell
            
            cell.variantName.text = searchVarArray[indexPath.row].title
            
            cell.borderView.layer.cornerRadius = 7.0
            cell.borderView.layer.borderColor = UIColor(red: 223.0/255.0, green: 223.0/255.0, blue: 223.0/255.0, alpha: 1.0).cgColor
            cell.borderView.layer.borderWidth = 1.0
            return cell
        }
        // searching = false
        else {
            
            if selectArray.count == 0 {
                
                let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! VariantTableViewCell
                
                cell.variantName.text = variantList[indexPath.row].title
                
                cell.borderView.layer.cornerRadius = 7.0
                cell.borderView.layer.borderColor = UIColor(red: 223.0/255.0, green: 223.0/255.0, blue: 223.0/255.0, alpha: 1.0).cgColor
                cell.borderView.layer.borderWidth = 1.0
                return cell
            }
            
            else {
                
                let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! VariantTableViewCell
                
                cell.variantName.text = filterVarArray[indexPath.row].title
                
                cell.borderView.layer.cornerRadius = 7.0
                cell.borderView.layer.borderColor = UIColor(red: 223.0/255.0, green: 223.0/255.0, blue: 223.0/255.0, alpha: 1.0).cgColor
                cell.borderView.layer.borderWidth = 1.0
                return cell
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if searching {
            
            let cell = tableview.cellForRow(at: indexPath) as! VariantTableViewCell
            nameVar = cell.variantName.text!
            
            let is_var = searchVarArray[indexPath.row].isvarient
            
            if is_var == "1" {
                var_id = searchVarArray[indexPath.row].var_id
                prodId = searchVarArray[indexPath.row].id
                is_single = "0"
            }
            
            else {
                var_id = searchVarArray[indexPath.row].id
                prodId = ""
                is_single = "1"
            }
        }
        // searching = false
        else {
            let cell = tableview.cellForRow(at: indexPath) as! VariantTableViewCell
            nameVar = cell.variantName.text!
            
            if selectArray.count == 0 {
                
                let is_var = variantList[indexPath.row].isvarient
                
                if is_var == "1" {
                    var_id = variantList[indexPath.row].var_id
                    prodId = variantList[indexPath.row].id
                    is_single = "0"
                }
                
                else {
                    var_id = variantList[indexPath.row].id
                    prodId = ""
                    is_single = "1"
                }
            }
            
            else {
                
                let is_var = filterVarArray[indexPath.row].isvarient
                
                if is_var == "1" {
                    var_id = filterVarArray[indexPath.row].var_id
                    prodId = filterVarArray[indexPath.row].id
                    is_single = "0"
                }
                
                else {
                    var_id = filterVarArray[indexPath.row].id
                    prodId = ""
                    is_single = "1"
                }
            }
        }
        UserDefaults.standard.set("tovariant", forKey: "toInstantPO")
        performSegue(withIdentifier: "toVariantInfo", sender: nil)
    }
}

struct InventoryVariant: Codable {
    
    let id: String
    let costperItem: String
    let title: String
    let isvarient: String
    let upc: String
    let cotegory: String
    let var_id: String
    let var_upc: String
    let quantity: String
    let price: String
    let custom_code: String
    let variant: String
    let var_price: String
    let is_lottery: String
    let var_costperItem: String
}

struct MixVariantModel {
    
    let id: String
    let title: String
    let isvarient: String
    let upc: String
    let cotegory: String
    let var_id: String
    let var_upc: String
    let quantity: String
    let price: String
    let custom_code: String
    let variant: String
    let var_price: String
    let product_id: String
    let costperItem: String
    let is_lottery: String
    let var_costperItem: String
}

struct VariantMixMatchModel {
    
    var mix: MixVariantModel
    var isSelect: Bool
}

struct VariantBogoModel {
    
    var bogo: BogoVariantModel
    var isSelect: Bool
}


struct InventoryVariantId {
    
    let HS_code: String
    let admin_id: String
    let alternateName: String
    let assigned_vendors: String
    let barcode: String
    let buy_with_product: String
    let compare_price: String
    let costperItem: String
    let cotegory: String
    let country_region: String
    let created_on: String
    let custom_code: String
    let description: String
    let disable: String
    let food_stampable: String
    let env: String
    let featured_product: String
    let id: String
    let is_tobacco: String
    let ischargeTax: String
    let ispysical_product: String
    let isstockcontinue: String
    let isvarient: String
    let loyalty_product_id: String
    let margin: String
    let media: String
    let merchant_id: String
    let other_taxes: String
    let prefferd_vendor: String
    let price: String
    let product_doc:String
    let product_id:String
    let profit:String
    let quantity:String
    let reorder_cost:String
    let reorder_level:String
    let reorder_qty:String
    let show_stats:String
    let show_type:String
    let sku:String
    let starting_quantity:String
    let title:String
    let trackqnty:String
    let upc:String
    let updated_on:String
    let user_id:String
}
