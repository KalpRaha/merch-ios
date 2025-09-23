//
//  FilterCategoryViewController.swift
//
//
//  Created by Jamaluddin Syed on 9/27/23.
//

import UIKit
import Alamofire

protocol BrandsTagsAddDelegate: AnyObject {
    
    func callBrandTagFilter(brandtag: String)
}

class FilterCategoryViewController: UIViewController {
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var applyBtn: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var selectText: UILabel!
    
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var noCategoryLbl: UILabel!
    
    @IBOutlet weak var addView: UIView!
    
    @IBOutlet weak var addBtnHeight: NSLayoutConstraint!
    
    @IBOutlet weak var selectView: UIView!
    @IBOutlet weak var selectLbl: UILabel!
    @IBOutlet weak var selectBtm: NSLayoutConstraint!
    @IBOutlet weak var selectTop: NSLayoutConstraint!
    
    //category arrays
    var selectCategory = [InventoryCategory]()
    var selectAddCategory = [InventoryCategory]()
    
    var categories = [InventoryCategory]()
    var subCategory = [InventoryCategory]()
    var searchCategory = [InventoryCategory]()
    
    //brandstags arrays
    var selectBrandsTags = [String]()
    var selectAddBrandsTags = [String]()
    
    var brandsTags = [BrandsTags]()
    var subBrandsTags = [BrandsTags]()
    var searchBrandsTags = [BrandsTags]()
    
    //taxes arrays
    var selectTaxes = [SetupTaxes]()
    var selectAddTaxes = [SetupTaxes]()
    
    var taxes = [SetupTaxes]()
    var subTaxes = [SetupTaxes]()
    var searchTaxes = [SetupTaxes]()
    
    //its arrays
    var selectIts = [Store]()
    var selectAddIts = [Store]()
    
    var its = [Store]()
    var subIts = [Store]()
    var searchIts = [Store]()
    
    var tapBlue = [String]()
    
    var newBrandTag = false
    var newBrandTagName = ""
    
    var itsSelectAll = false
    
    weak var delegateProducts: SelectedCategoryProductsDelegate?
    weak var delegatePlus: PlusSelectedCategory?
    weak var delegateDuplicate: PlusSelectedCategory?
    weak var delegateVariants: SelectedCategoryProductsDelegate?
    
    weak var delegateLottery: SelectedCategoryProductsDelegate?
    weak var delegateMixSelected: SelectedCategoryProductsDelegate?
    weak var delegateBogoSelected: SelectedCategoryProductsDelegate?
    weak var delegateCouponSelected: SelectedCategoryProductsDelegate?
    
    weak var delegateMixStores: AddMixnMatchStoresDelegate?
    weak var delegateBogoStores: AddBogoStoresDelegate?
    
    weak var delegateBrandTagsSelected: BrandsTagsAddDelegate?
    
    
    var catMode = ""
    var apiMode = ""
    var searching = false
    var variantMixList = [MixVariantModel]()
    var alredCatselect = [VariantMixMatchModel]()
    var productsList = [InventoryProductModel]()
    var bogoVarientList = [BogoVariantModel]()
    var variantList = [InventoryVariant]()
    
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetBtn.layer.cornerRadius = 10
        applyBtn.layer.cornerRadius = 10
        resetBtn.layer.borderWidth = 1.0
        resetBtn.layer.borderColor = UIColor.black.cgColor
        
        collection.showsVerticalScrollIndicator = false
        
        searchBar.searchTextField.backgroundColor = .white
        searchBar.searchTextField.leftViewMode = .never
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        button.setImage(UIImage(named: "Search"), for: .normal)
        searchBar.searchTextField.rightView = button
        searchBar.searchTextField.rightViewMode = .always
        
        let columnLayout = CustomFlowLayout()
        collection.collectionViewLayout = columnLayout
        columnLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        addView.isHidden = true
        addBtn.isHidden = true
        addBtnHeight.constant = 0
        noCategoryLbl.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        selectView.addGestureRecognizer(tap)
        selectView.isUserInteractionEnabled = true
        tap.numberOfTapsRequired = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
        subCategory = []
        subBrandsTags = []
        subTaxes = []
        
        addBtn.setTitle("Add New", for: .normal)
        addBtn.layer.cornerRadius = 10
        addBtn.layer.borderColor = UIColor(hexString: "#0A64F9").cgColor
        addBtn.layer.borderWidth = 1.0
        
        selectView.isHidden = true
        selectLbl.isHidden = true
        selectLbl.text = ""
        selectBtm.constant = 0
        selectTop.constant = 0
        
        if apiMode == "category" {
            collection.isHidden = true
            loadingIndicator.isAnimating = true
            setupCatApi()
            selectText.text = "Select Category"
            searchBar.placeholder = "Search Category"
            noCategoryLbl.text = "No Category Found"
        }
        else if apiMode == "brands" || apiMode == "tags" {
            
            setupBrandsApi()
        }
        else if apiMode == "its" || apiMode == "mts" || apiMode == "bts" {
            collection.isHidden = true
            loadingIndicator.isAnimating = true
            setupStoreApi()
            selectText.text = "Select Store"
            searchBar.placeholder = "Search Store"
            noCategoryLbl.text = "No Store Found"
            selectBtm.constant = 10
            selectTop.constant = 10
        }
        else {
            selectText.text = "Select Taxes"
            searchBar.placeholder = "Search Taxes"
            noCategoryLbl.text = "No Tax Found"
            
            if selectTaxes.count > 0 {
                
                for select in selectTaxes {
                    selectAddTaxes.append(select)
                }
            }
        }
        
        
    }
    
    func setupCatApi() {
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        ApiCalls.sharedCall.categoryListCall(merchant_id: id) { isSuccess, responseData in
            
            if isSuccess {
                
                guard let list = responseData["result"] else {
                    self.loadingIndicator.isAnimating = false
                    return
                }
                self.getResponseCatValues(list: list)
                
                DispatchQueue.main.async {
                    self.collection.isHidden = false
                    self.loadingIndicator.isAnimating = false
                    self.collection.reloadData()
                }
                
            }else{
                print("Api Error")
            }
        }
    }
    
    func getResponseCatValues(list: Any) {
        
        let response = list as! [[String:Any]]
        var smallres = [InventoryCategory]()
        
        for res in response {
            
            let category = InventoryCategory(id: "\(res["id"] ?? "")", title: "\(res["title"] ?? "")",
                                             description: "\(res["description"] ?? "")", categoryBanner: "\(res["categoryBanner"] ?? "")",
                                             show_online: "\(res["show_online"] ?? "")", show_status: "\(res["show_status"] ?? "")",
                                             cat_show_status: "\(res["cat_show_status"] ?? "")", is_lottery: "\(res["is_lottery"] ?? "")",
                                             alternateName: "\(res["alternateName"] ?? "")",
                                             merchant_id: "\(res["merchant_id"] ?? "")", is_deleted: "\(res["is_deleted"] ?? "")",
                                             user_id: "\(res["user_id"] ?? "")", created_on: "\(res["created_on"] ?? "")",
                                             updated_on: "\(res["updated_on"] ?? "")", admin_id: "\(res["admin_id"] ?? "")",
                                             use_point: "\(res["use_point"] ?? "")", earn_point: "\(res["earn_point"] ?? "")")
            
            
            
            if catMode == "addProductVc" {
                if category.is_lottery == "0" {
                    smallres.append(category)
                }
            }
            
            else if catMode == "dupProductVC" {
                if category.is_lottery == "0" {
                    smallres.append(category)
                }
            }
            
            else if catMode == "ProductsVc" {
//                if productsList.contains(where: { $0.cotegory == category.id }) {
//                    smallres.append(category)
//                }
                if category.is_lottery == "0" {
                    smallres.append(category)
                }
            }
            else if catMode == "VariantVc" {
//                if variantList.contains(where: { $0.cotegory == category.id }) {
//                    smallres.append(category)
//                }
                if category.is_lottery == "0" {
                    smallres.append(category)
                }
                
            }
            
            else if catMode == "mixMatchVc" {
                if variantMixList.contains(where: { $0.cotegory == category.id }) {
                    smallres.append(category)
                }
            }
            
            else if catMode == "BogoVc" {
                if bogoVarientList.contains(where: { $0.cotegory == category.id }) {
                    smallres.append(category)
                }
            }
            
            else if catMode == "couponVc" {
                
            }
            
            else if catMode == "lotteryVc" {
                
                if category.is_lottery == "1" {
                    
                    smallres.append(category)
                }
            }
            
            else {
                
            }
        }
        
        
        
        
        categories = smallres
        subCategory = smallres
        
        if selectCategory.count > 0 {
            
            for select in selectCategory {
                
                selectAddCategory.append(select)
            }
        }
    }
    
    func removeCategory(variantName: String) {
        
        selectAddCategory.removeAll(where: {$0.id == variantName})
        tapBlue.removeAll(where: {$0 == variantName})
    }
    
    func removeTags(tagName: String) {
        
        selectAddBrandsTags.removeAll(where: {$0 == tagName})
        tapBlue.removeAll(where: {$0 == tagName})
    }
    
    func removeIts(storeName: String) {
        
        selectAddIts.removeAll(where: {$0.merchant_id == storeName})
        tapBlue.removeAll(where: {$0 == storeName})
    }
    
    func removeTaxes(taxesName: String) {
        
        selectAddTaxes.removeAll(where: {$0.id == taxesName})
        tapBlue.removeAll(where: {$0 == taxesName})
    }
    
    func setupBrandsApi() {
        
        collection.isHidden = true
        loadingIndicator.isAnimating = true
        
        addView.isHidden = true
        addBtn.isHidden = true
        addBtnHeight.constant = 0
        noCategoryLbl.isHidden = true
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        var type = ""
        
        if apiMode == "brands" {
            type = "1"
            selectText.text = "Select Brands"
            searchBar.placeholder = "Search Brands"
            
            noCategoryLbl.text = "No Brands Found"
            addBtn.setTitle("+ Add New Brand", for: .normal)
        }
        else {
            type = "0"
            selectText.text = "Select Tags"
            searchBar.placeholder = "Search Tags"
            
            noCategoryLbl.text = "No Tags Found"
            addBtn.setTitle("+ Add New Tag", for: .normal)
        }
        
        ApiCalls.sharedCall.getBrandsTags(merchant_id: id, type: type) { isSuccess, responseData in
            
            if isSuccess {
                
                guard let list = responseData["data"] else {
                    self.loadingIndicator.isAnimating = false
                    return
                }
                self.getResponseBrandsValues(list: list)
            }else{
                print("Api Error")
                self.loadingIndicator.isAnimating = false
            }
        }
    }
    
    func getResponseBrandsValues(list: Any) {
        
        let response = list as! [[String:Any]]
        var smallres = [BrandsTags]()
        
        for res in response {
            
            let category = BrandsTags(id: "\(res["id"] ?? "")", title: "\(res["title"] ?? "")",
                                      type: "\(res["type"] ?? "")",
                                      merchant_id: "\(res["merchant_id"] ?? "")",
                                      updated_on: "\(res["updated_on"] ?? "")")
            
            smallres.append(category)
            
        }
        
        brandsTags = smallres
        subBrandsTags = smallres
        
        if newBrandTag {
            
            if apiMode == "brands" {
                selectBrandsTags = [newBrandTagName]
            }
            else {
                selectBrandsTags.append(newBrandTagName)
            }
            newBrandTag = false
        }
        
        if selectBrandsTags.count > 0 {
            
            if apiMode == "brands" {
                selectAddBrandsTags = selectBrandsTags
            }
            else {
                for select in selectBrandsTags {
                    selectAddBrandsTags.append(select)
                }
            }
        }
        
        if brandsTags.count == 0 {
            collection.isHidden = true
            addView.isHidden = false
            
            noCategoryLbl.isHidden = false
        }
        else {
            collection.isHidden = false
            addView.isHidden = true
            
            noCategoryLbl.isHidden = true
        }
        addBtn.isHidden = false
        addBtnHeight.constant = 45
        loadingIndicator.isAnimating = false
        
        DispatchQueue.main.async {
            self.collection.reloadData()
        }
    }
    
    func setupStoreApi() {
        
        let email = UserDefaults.standard.string(forKey: "merchant_email") ?? ""
        let password = UserDefaults.standard.string(forKey: "merchant_password") ?? ""
        let emp_log = UserDefaults.standard.string(forKey: "login_emp_res") ?? ""
        
        let parameters: [String: Any] = [
            "email_id": email,
            "password": password,
            "employee_login": emp_log
        ]
        
        let url = AppURLs.ALL_STORES
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseData { (response) in
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    if json["result"] == nil {
                        self.collection.isHidden = false
                        self.loadingIndicator.isAnimating = false
                    }
                    else {
                        self.getResponseStoreValues(response: json["result"])
                        
                        DispatchQueue.main.async {
                            self.collection.isHidden = false
                            self.loadingIndicator.isAnimating = false
                            self.collection.reloadData()
                        }
                    }
                }
                catch {
                    self.collection.isHidden = false
                    self.loadingIndicator.isAnimating = false
                }
                break
                
            case .failure(let error):
                print(error.localizedDescription)
                self.collection.isHidden = false
                self.loadingIndicator.isAnimating = false
                
            }
        }
    }
    
    func getResponseStoreValues(response: Any) {
        
        let responseArray = response as! [[String:Any]]
        var storeList = [Store]()
        
        for response in responseArray {
            
            let store = Store(a_city: "\(response["a_city"] ?? "")",
                              a_country: "\(response["a_country"] ?? "")",
                              a_phone: "\(response["a_phone"] ?? "")",
                              a_state: "\(response["a_state"] ?? "")",
                              a_zip: "\(response["a_zip"] ?? "")",
                              email: "\(response["email"] ?? "")",
                              logo: "\(response["logo"] ?? "")",
                              merchant_id: "\(response["merchant_id"] ?? "")",
                              merchant_name: "\(response["merchant_name"] ?? "")",
                              password: "\(response["password"] ?? "")",
                              store_name: "\(response["store_name"] ?? "")",
                              login_store_name: "\(response["login_store_name"] ?? "")",
                              a_address_line_1: "\(response["a_address_line_1"] ?? "")",
                              a_address_line_2: "\(response["a_address_line_2"] ?? "")")
            
            storeList.append(store)
        }
        
        let stores = UserDefaults.standard.string(forKey: "assigned_store") ?? ""
        let current_store = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        var storeArray = [Store]()
        
        for store in storeList {
            
            if stores.lowercased().contains(store.merchant_id.lowercased()) {
                storeArray.append(store)
            }
        }
        
        storeArray.removeAll(where: { $0.merchant_id.lowercased() == current_store.lowercased()})
        
        if storeArray.count > 0 {
            selectView.isHidden = false
            selectLbl.isHidden = false
            selectLbl.text = "Select All"
        }
        else {
            selectView.isHidden = true
            selectLbl.isHidden = true
            selectLbl.text = ""
        }
        
        its = storeArray
        subIts = storeArray
        
        if selectIts.count > 0 {
            
            for select in selectIts {
                
                selectAddIts.append(select)
            }
            
            if storeArray.count == selectIts.count {
                selectView.layer.borderColor = UIColor(named: "SelectCat")?.cgColor
                selectView.layer.borderWidth = 1
                selectView.layer.cornerRadius = 5.0
                selectLbl.textColor = UIColor(named: "SelectCat")
                itsSelectAll = true
            }
            else {
                selectLbl.textColor = .black
                selectView.layer.borderColor = UIColor(named: "CategoryBorder")?.cgColor
                selectView.layer.borderWidth = 1
                selectView.layer.cornerRadius = 5.0
                itsSelectAll = false
            }
        }
        else {
            selectLbl.textColor = .black
            selectView.layer.borderColor = UIColor(named: "CategoryBorder")?.cgColor
            selectView.layer.borderWidth = 1
            selectView.layer.cornerRadius = 5.0
            itsSelectAll = false
        }
        self.collection.isHidden = false
        self.loadingIndicator.isAnimating = false
    }
    
    @objc func handleTap() {
        
        if selectView.layer.borderColor == UIColor(named: "SelectCat")?.cgColor {
            selectLbl.textColor = .black
            selectView.layer.borderColor = UIColor(named: "CategoryBorder")?.cgColor
            selectView.layer.cornerRadius = 5.0
            selectView.layer.borderWidth = 1
            itsSelectAll = false
            
            collection.isHidden = true
            loadingIndicator.isHidden = true
            
            selectIts = []
            tapBlue = []
            selectAddIts = []
           
            collection.isHidden = false
            loadingIndicator.isHidden = false
            collection.reloadData()
        }
        else {
            
            selectView.layer.borderColor = UIColor(named: "SelectCat")?.cgColor
            selectView.layer.cornerRadius = 5.0
            selectView.layer.borderWidth = 1
            selectLbl.textColor = UIColor(named: "SelectCat")
            itsSelectAll = true
            
            collection.isHidden = true
            loadingIndicator.isHidden = true
            
            tapBlue = []
            
            if searching {
                for i in searchIts {
                    tapBlue.append(i.merchant_id)
                }
            }
            else {
                for i in its {
                    tapBlue.append(i.merchant_id)
                }
            }
            collection.isHidden = false
            loadingIndicator.isHidden = false
            collection.reloadData()
        }
    }
    
    @IBAction func closeBtnClick(_ sender: UIButton) {
        
        if catMode == "addProductVc" {
            dismiss(animated: true)
        }
        
        else if catMode == "dupProductVC" {
            dismiss(animated: true)
        }
        
        else if catMode == "ProductsVc" {
            dismiss(animated: true)
        }
        
        else if catMode == "mixMatchVc" {
            dismiss(animated: true)
        }
        
        else if catMode == "BogoVc" {
            dismiss(animated: true)
        }
        
        else if catMode == "couponVc" {
            dismiss(animated: true)
        }
        
        else if catMode == "lotteryVc" {
            dismiss(animated: true)
        }
        
        else {
            dismiss(animated: true)
        }
    }
    
    
    @IBAction func resetBtnClick(_ sender: UIButton) {
        
        if catMode == "addProductVc" {
            loadingIndicator.isAnimating = true
            selectCategory = []
            tapBlue = []
            selectAddCategory = []
            collection.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                
                self.loadingIndicator.isAnimating = false
                self.delegatePlus?.getSelectedCats(reverseCategory: [], reverseBrandsTags: [],
                                                   reverseTaxes: [], reverseITS: [], apiMode: self.apiMode)
                self.dismiss(animated: true)
            }
        }
        
        else if catMode == "ProductsVc" {
            loadingIndicator.isAnimating = true
            selectCategory = []
            tapBlue = []
            selectAddCategory = []
            collection.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.loadingIndicator.isAnimating = false
                self.delegateProducts?.getProductsCategory(categoryArray: [])
                self.dismiss(animated: true)
            }
        }
        
        else if catMode == "dupProductVC" {
            loadingIndicator.isAnimating = true
            selectCategory = []
            tapBlue = []
            selectAddCategory = []
            collection.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.loadingIndicator.isAnimating = false
                self.delegateDuplicate?.getSelectedCats(reverseCategory: [], reverseBrandsTags: [], 
                                                        reverseTaxes: [], reverseITS: [], apiMode: self.apiMode)
                self.dismiss(animated: true)
            }
        }
        
        else if catMode == "mixMatchVc" {
            
            loadingIndicator.isAnimating = true
            selectCategory = []
            tapBlue = []
            selectAddCategory = []
            collection.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.loadingIndicator.isAnimating = false
                self.delegateMixSelected?.getProductsCategory(categoryArray: [])
                self.dismiss(animated: true)
            }
        }
        else if catMode == "BogoVc" {
            
            loadingIndicator.isAnimating = true
            selectCategory = []
            tapBlue = []
            selectAddCategory = []
            collection.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.loadingIndicator.isAnimating = false
                self.delegateBogoSelected?.getProductsCategory(categoryArray: [])
                self.dismiss(animated: true)
            }
            
        }
        
        else if catMode == "couponVc" {
            
            loadingIndicator.isAnimating = true
            selectCategory = []
            tapBlue = []
            selectAddCategory = []
            collection.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.loadingIndicator.isAnimating = false
                self.delegateCouponSelected?.getProductsCategory(categoryArray: [])
                self.dismiss(animated: true)
            }
        }
        
        else if catMode == "lotteryVc" {
            
            loadingIndicator.isAnimating = true
            selectCategory = []
            tapBlue = []
            selectAddCategory = []
            collection.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.loadingIndicator.isAnimating = false
                self.delegateLottery?.getProductsCategory(categoryArray: [])
                self.dismiss(animated: true)
            }
        }
        
        else if catMode == "mixMatchStores" {
            
            loadingIndicator.isAnimating = true
            selectIts = []
            tapBlue = []
            selectAddIts = []
            collection.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.loadingIndicator.isAnimating = false
                self.delegateMixStores?.setSelectedStores(reverseStores: [])
                self.dismiss(animated: true)
            }
        }
        
        else if catMode == "bogoStores" {
            
            loadingIndicator.isAnimating = true
            selectIts = []
            tapBlue = []
            selectAddIts = []
            collection.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.loadingIndicator.isAnimating = false
                self.delegateBogoStores?.setSelectedStores(reverseStores: [])
                self.dismiss(animated: true)
            }
        }
        
        else {
            loadingIndicator.isAnimating = true
            selectCategory = []
            tapBlue = []
            selectAddCategory = []
            collection.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                
                self.loadingIndicator.isAnimating = false
                self.delegateVariants?.getProductsCategory(categoryArray: [])
                self.dismiss(animated: true)
            }
        }
    }
    
    @IBAction func applyBtnClick(_ sender: UIButton) {
        
        if catMode == "addProductVc" {
            
            if apiMode == "tags" {
                
                if selectAddBrandsTags.count > 15 {
                    ToastClass.sharedToast.showToast(message: "You cannot select more than 15 items",
                                                     font: UIFont(name: "Manrope-SemiBold", size: 15.0)!)
                }
                else {
                    delegatePlus?.getSelectedCats(reverseCategory: selectAddCategory,
                                                  reverseBrandsTags: selectAddBrandsTags,
                                                  reverseTaxes: selectAddTaxes, reverseITS: selectAddIts, apiMode: apiMode)
                    dismiss(animated: true)
                }
            }
            else {
                delegatePlus?.getSelectedCats(reverseCategory: selectAddCategory,
                                              reverseBrandsTags: selectAddBrandsTags,
                                              reverseTaxes: selectAddTaxes, reverseITS: selectAddIts, apiMode: apiMode)
                dismiss(animated: true)
            }
        }
        
        else if catMode == "ProductsVc" {
            
            delegateProducts?.getProductsCategory(categoryArray: selectAddCategory)
            dismiss(animated: true)
        }
        
        else if catMode == "dupProductVC" {
            
            if apiMode == "tags" {
                
                if selectAddBrandsTags.count > 15 {
                    ToastClass.sharedToast.showToast(message: "You cannot select more than 15 items",
                                                     font: UIFont(name: "Manrope-SemiBold", size: 15.0)!)
                }
                else {
                    
                    
                    delegateDuplicate?.getSelectedCats(reverseCategory: selectAddCategory,
                                                       reverseBrandsTags: selectAddBrandsTags,
                                                       reverseTaxes: selectAddTaxes, reverseITS: [], apiMode: apiMode)
                    dismiss(animated: true)
                }
            }
            else {
                delegateDuplicate?.getSelectedCats(reverseCategory: selectAddCategory,
                                                   reverseBrandsTags: selectAddBrandsTags,
                                                   reverseTaxes: selectAddTaxes, reverseITS: [], apiMode: apiMode)
                dismiss(animated: true)
            }
        }
        
        else if catMode == "mixMatchVc" {
            
            delegateMixSelected?.getProductsCategory(categoryArray: selectAddCategory)
            dismiss(animated: true)
            
        }
        else if catMode == "BogoVc" {
            
            delegateBogoSelected?.getProductsCategory(categoryArray: selectAddCategory)
            dismiss(animated: true)
        }
        
        else if catMode == "couponVc" {
            
            delegateCouponSelected?.getProductsCategory(categoryArray: selectAddCategory)
            dismiss(animated: true)
        }
        
        else if catMode == "lotteryVc" {
            
            delegateLottery?.getProductsCategory(categoryArray: selectAddCategory)
            dismiss(animated: true)
        }
        
        else if catMode == "mixMatchStores" {
            
            delegateMixStores?.setSelectedStores(reverseStores: selectAddIts)
            dismiss(animated: true)
        }
        
        else if catMode == "bogoStores" {
            
            delegateBogoStores?.setSelectedStores(reverseStores: selectAddIts)
            dismiss(animated: true)
        }
        
        else {
            
            delegateVariants?.getProductsCategory(categoryArray: selectAddCategory)
            dismiss(animated: true)
        }
    }
    
    
    @IBAction func addBtnClick(_ sender: UIButton) {
        
        if apiMode == "brands" {
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "addbrandtag") as! AddBrandTagViewController
            
            vc.clickMode = "filter"
            vc.brandFilter = self
            vc.type = "1"
            vc.mode = "add"
            
            if searching {
                vc.old = searchBar.text ?? ""
            }
            else {
                vc.old = ""
            }
            
            self.present(vc, animated: true)
        }
        else if apiMode == "tags" {
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "addbrandtag") as! AddBrandTagViewController
            
            vc.clickMode = "filter"
            vc.tagFilter = self
            vc.type = "0"
            vc.mode = "add"
            
            if searching {
                vc.old = searchBar.text ?? ""
            }
            else {
                vc.old = ""
            }
            
            present(vc, animated: true)
        }
        else {
            
        }
    }
}

extension FilterCategoryViewController: BrandsTagsAddDelegate {
    
    func callBrandTagFilter(brandtag: String) {
        
        searching = false
        searchBar.text = ""
        
        newBrandTagName = brandtag
        newBrandTag = true
        selectAddBrandsTags = []
        setupBrandsApi()
    }
}

extension FilterCategoryViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {
            searching = false
        }
        else {
            
            if apiMode == "category" {
                searchCategory = subCategory.filter { $0.title.lowercased().prefix(searchText.count) == searchText.lowercased() }
                searching = true
            }
            else if apiMode == "brands" || apiMode == "tags" {
                searchBrandsTags = subBrandsTags.filter { $0.title.lowercased().prefix(searchText.count) == searchText.lowercased() }
                searching = true
            }
            else if apiMode == "its" || apiMode == "mts" || apiMode == "bts" {
                searchIts = subIts.filter { $0.store_name.lowercased().prefix(searchText.count) == searchText.lowercased() }
                searching = true
            }
            else {
                searchTaxes = subTaxes.filter { $0.title.lowercased().prefix(searchText.count) == searchText.lowercased() }
                searching = true
            }
        }
        collection.reloadData()
        
        if apiMode == "brands" || apiMode == "tags" {
            
            if searching {
                
                if searchBrandsTags.count == 0 {
                    
                    collection.isHidden = true
                    
                    addView.isHidden = false
                    addBtn.setTitle("+ Add \(searchText) as new \(apiMode.dropLast())", for: .normal)
                    noCategoryLbl.isHidden = false
                }
                else {
                    
                    collection.isHidden = false
                    addView.isHidden = true
                    addBtn.setTitle("+ Add New \(apiMode.dropLast())", for: .normal)
                    noCategoryLbl.isHidden = true
                }
            }
            else {
                
                collection.isHidden = false
                addView.isHidden = true
                addBtn.setTitle("+ Add New \(apiMode.dropLast())", for: .normal)
                noCategoryLbl.isHidden = true
            }
        }
        else {
            if searching {
                
                if apiMode == "category" {
                    if searchCategory.count == 0 {
                        collection.isHidden = true
                        addView.isHidden = false
                        noCategoryLbl.isHidden = false
                    }
                    else {
                        collection.isHidden = false
                        addView.isHidden = true
                        noCategoryLbl.isHidden = true
                    }
                }
                else if apiMode == "its" || apiMode == "mts" || apiMode == "bts" {
                    if searchIts.count == 0 {
                        collection.isHidden = true
                        addView.isHidden = false
                        noCategoryLbl.isHidden = false
                        
                        selectView.isHidden = true
                        selectLbl.isHidden = true
                        selectLbl.text = ""
                        selectBtm.constant = 0
                        selectTop.constant = 0
                    }
                    else {
                        collection.isHidden = false
                        addView.isHidden = true
                        noCategoryLbl.isHidden = true
                        
                        selectView.isHidden = false
                        selectLbl.isHidden = false
                        selectLbl.text = "Select All"
                        selectBtm.constant = 10
                        selectTop.constant = 10
                    }
                }
                else {
                    if searchTaxes.count == 0 {
                        collection.isHidden = true
                        addView.isHidden = false
                        noCategoryLbl.isHidden = false
                    }
                    else {
                        collection.isHidden = false
                        addView.isHidden = true
                        noCategoryLbl.isHidden = true
                    }
                }
            }
            else {
                if apiMode == "its" || apiMode == "mts" || apiMode == "bts" {
                    selectView.isHidden = false
                    selectLbl.isHidden = false
                    selectLbl.text = "Select All"
                    selectBtm.constant = 10
                    selectTop.constant = 10
                }
                collection.isHidden = false
                addView.isHidden = true
                noCategoryLbl.isHidden = true
            }
        }
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

extension FilterCategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if searching {
            
            if apiMode == "category" {
                return searchCategory.count
            }
            else if apiMode == "brands" || apiMode == "tags" {
                return searchBrandsTags.count
            }
            else if apiMode == "its" || apiMode == "mts" || apiMode == "bts" {
                return searchIts.count
            }
            else {
                return searchTaxes.count
            }
        }
        
        else {
            if apiMode == "category" {
                return categories.count
            }
            else if apiMode == "brands" || apiMode == "tags" {
                return brandsTags.count
            }
            else if apiMode == "its" || apiMode == "mts" || apiMode == "bts" {
                return its.count
            }
            else {
                return taxes.count
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collection.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FilterCategoryCollectionViewCell
        
        if searching {
            
            if apiMode == "category" {
                
                cell.categoryName.text = searchCategory[indexPath.row].title
                
                if selectCategory.contains(where: {$0.id == searchCategory[indexPath.row].id})
                    || tapBlue.contains(where: {$0 == searchCategory[indexPath.row].id}) {
                    cell.contentView.layer.borderColor = UIColor(named: "SelectCat")?.cgColor
                    cell.categoryName.textColor = UIColor(named: "SelectCat")
                }
                else {
                    cell.categoryName.textColor = .black
                    cell.contentView.layer.borderColor = UIColor(named: "CategoryBorder")?.cgColor
                }
            }
            else if apiMode == "brands" {
                
                cell.categoryName.text = searchBrandsTags[indexPath.row].title
                
                if selectBrandsTags.contains(where: {$0 == searchBrandsTags[indexPath.row].title})
                    || tapBlue.contains(where: {$0 == searchBrandsTags[indexPath.row].title}) {
                    
                    cell.contentView.layer.borderColor = UIColor(named: "SelectCat")?.cgColor
                    cell.categoryName.textColor = UIColor(named: "SelectCat")
                    selectAddBrandsTags.append(searchBrandsTags[indexPath.row].title)
                }
                else {
                    cell.categoryName.textColor = .black
                    cell.contentView.layer.borderColor = UIColor(named: "CategoryBorder")?.cgColor
                }
            }
            
            else if apiMode == "tags" {
                
                cell.categoryName.text = searchBrandsTags[indexPath.row].title
                
                if selectBrandsTags.contains(where: {$0 == searchBrandsTags[indexPath.row].title})
                    || tapBlue.contains(where: {$0 == searchBrandsTags[indexPath.row].title}) {
                    cell.contentView.layer.borderColor = UIColor(named: "SelectCat")?.cgColor
                    cell.categoryName.textColor = UIColor(named: "SelectCat")
                }
                else {
                    cell.categoryName.textColor = .black
                    cell.contentView.layer.borderColor = UIColor(named: "CategoryBorder")?.cgColor
                }
            }
            else if apiMode == "its" || apiMode == "mts" || apiMode == "bts" {
                
                cell.categoryName.text = searchIts[indexPath.row].store_name
                
                if selectIts.contains(where: {$0.merchant_id == searchIts[indexPath.row].merchant_id})
                    || tapBlue.contains(where: {$0 == searchIts[indexPath.row].merchant_id}) {
                    cell.contentView.layer.borderColor = UIColor(named: "SelectCat")?.cgColor
                    cell.categoryName.textColor = UIColor(named: "SelectCat")
                }
                else {
                    cell.categoryName.textColor = .black
                    cell.contentView.layer.borderColor = UIColor(named: "CategoryBorder")?.cgColor
                }
            }
            else {
                
                cell.categoryName.text = searchTaxes[indexPath.row].title
                
                if selectTaxes.contains(where: {$0.id == searchTaxes[indexPath.row].id})
                    || tapBlue.contains(where: {$0 == searchTaxes[indexPath.row].id}) {
                    cell.contentView.layer.borderColor = UIColor(named: "SelectCat")?.cgColor
                    cell.categoryName.textColor = UIColor(named: "SelectCat")
                }
                else {
                    cell.categoryName.textColor = .black
                    cell.contentView.layer.borderColor = UIColor(named: "CategoryBorder")?.cgColor
                }
            }
        }
        
        else {
            
            if apiMode == "category" {
                
                cell.categoryName.text = categories[indexPath.row].title
                
                if selectCategory.contains(where: {$0.id == categories[indexPath.row].id}) {
                    
                    cell.contentView.layer.borderColor = UIColor(named: "SelectCat")?.cgColor
                    cell.categoryName.textColor = UIColor(named: "SelectCat")
                }
                    
                else if tapBlue.contains(where: {$0 == categories[indexPath.row].id}) {
                    
                    cell.contentView.layer.borderColor = UIColor(named: "SelectCat")?.cgColor
                    cell.categoryName.textColor = UIColor(named: "SelectCat")
                    selectAddCategory.append(categories[indexPath.row])
                }
                else {
                    cell.categoryName.textColor = .black
                    cell.contentView.layer.borderColor = UIColor(named: "CategoryBorder")?.cgColor
                }
            }
            else if apiMode == "brands" {
                
                cell.categoryName.text = brandsTags[indexPath.row].title
                
                if selectBrandsTags.contains(where: {$0 == brandsTags[indexPath.row].title})
                    || tapBlue.contains(where: {$0 == brandsTags[indexPath.row].title}) {
                    cell.contentView.layer.borderColor = UIColor(named: "SelectCat")?.cgColor
                    cell.categoryName.textColor = UIColor(named: "SelectCat")
                    selectAddBrandsTags.append(brandsTags[indexPath.row].title)
                }
                else {
                    cell.categoryName.textColor = .black
                    cell.contentView.layer.borderColor = UIColor(named: "CategoryBorder")?.cgColor
                }
            }
            
            else if apiMode == "tags" {
                
                cell.categoryName.text = brandsTags[indexPath.row].title
                
                if selectBrandsTags.contains(where: {$0 == brandsTags[indexPath.row].title}) {
                    cell.contentView.layer.borderColor = UIColor(named: "SelectCat")?.cgColor
                    cell.categoryName.textColor = UIColor(named: "SelectCat")
                }
                
                else if tapBlue.contains(where: {$0 == brandsTags[indexPath.row].title}) {
                    cell.contentView.layer.borderColor = UIColor(named: "SelectCat")?.cgColor
                    cell.categoryName.textColor = UIColor(named: "SelectCat")
                    selectAddBrandsTags.append(brandsTags[indexPath.row].title)
                }
                else {
                    cell.categoryName.textColor = .black
                    cell.contentView.layer.borderColor = UIColor(named: "CategoryBorder")?.cgColor
                }
            }
            else if apiMode == "its" || apiMode == "mts" || apiMode == "bts" {
                
                cell.categoryName.text = its[indexPath.row].store_name
                
                if selectIts.contains(where: {$0.merchant_id == its[indexPath.row].merchant_id}) {
                    cell.contentView.layer.borderColor = UIColor(named: "SelectCat")?.cgColor
                    cell.categoryName.textColor = UIColor(named: "SelectCat")
                }
                
                else if tapBlue.contains(where: {$0 == its[indexPath.row].merchant_id}) {
                    cell.contentView.layer.borderColor = UIColor(named: "SelectCat")?.cgColor
                    cell.categoryName.textColor = UIColor(named: "SelectCat")
                    if selectAddIts.contains(where: {$0.merchant_id == its[indexPath.row].merchant_id}) {
                        
                    }
                    else {
                        selectAddIts.append(its[indexPath.row])
                    }
                }
                else {
                    cell.categoryName.textColor = .black
                    cell.contentView.layer.borderColor = UIColor(named: "CategoryBorder")?.cgColor
                }
            }
            else {
                
                cell.categoryName.text = taxes[indexPath.row].title
                
                if selectTaxes.contains(where: {$0.id == taxes[indexPath.row].id}) {
                    cell.contentView.layer.borderColor = UIColor(named: "SelectCat")?.cgColor
                    cell.categoryName.textColor = UIColor(named: "SelectCat")
                }
                
                else if tapBlue.contains(where: {$0 == taxes[indexPath.row].id}) {
                    
                    cell.contentView.layer.borderColor = UIColor(named: "SelectCat")?.cgColor
                    cell.categoryName.textColor = UIColor(named: "SelectCat")
                    selectAddTaxes.append(taxes[indexPath.row])
                }
                else {
                    cell.categoryName.textColor = .black
                    cell.contentView.layer.borderColor = UIColor(named: "CategoryBorder")?.cgColor
                }
            }
        }
        
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.cornerRadius = 5.0
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collection.cellForItem(at: indexPath) as! FilterCategoryCollectionViewCell
        
        if searching {
            
            if cell.contentView.layer.borderColor == UIColor(named: "SelectCat")?.cgColor {
                
                cell.categoryName.textColor = .black
                cell.contentView.layer.borderColor = UIColor(named: "CategoryBorder")?.cgColor
                
                if apiMode == "category" {
                    let id = searchCategory[indexPath.row].id
                    removeCategory(variantName: id)
                }
                else if apiMode == "brands" {
                    selectAddBrandsTags = []
                    tapBlue = []
                    selectBrandsTags = []
                    collection.reloadData()
                }
                else if apiMode == "its" || apiMode == "mts" || apiMode == "bts" {
                    let id = searchIts[indexPath.row].merchant_id
                    removeIts(storeName: id)
                    selectLbl.textColor = .black
                    selectView.layer.borderColor = UIColor(named: "CategoryBorder")?.cgColor
                    selectView.layer.cornerRadius = 5.0
                    selectView.layer.borderWidth = 1
                }
                else if apiMode == "tags" {
                    let title = searchBrandsTags[indexPath.row].title
                    removeTags(tagName: title)
                }
                else {
                    let id = searchTaxes[indexPath.row].id
                    removeTaxes(taxesName: id)
                }
            }
            
            else {
                cell.contentView.layer.borderColor = UIColor(named: "SelectCat")?.cgColor
                cell.categoryName.textColor = UIColor(named: "SelectCat")
                
                if apiMode == "category" {
                    let name = searchCategory[indexPath.row]
                    selectAddCategory.append(name)
                    tapBlue.append(name.id)
                }
                else if apiMode == "brands" {
                    let name = searchBrandsTags[indexPath.row]
                    selectBrandsTags = [name.title]
                    selectAddBrandsTags = []
                    tapBlue = [name.title]
                    collection.reloadData()
                }
                else if apiMode == "its" || apiMode == "mts" || apiMode == "bts" {
                    let name = searchIts[indexPath.row]
                    selectAddIts.append(name)
                    tapBlue.append(name.merchant_id)
                    if its.count == selectAddIts.count  {
                        itsSelectAll = true
                        selectView.layer.borderColor = UIColor(named: "SelectCat")?.cgColor
                        selectView.layer.cornerRadius = 5.0
                        selectView.layer.borderWidth = 1
                        selectLbl.textColor = UIColor(named: "SelectCat")
                    }
                    else {
                        itsSelectAll = false
                    }
                }
                else if apiMode == "tags" {
                    let name = brandsTags[indexPath.row]
                    selectAddBrandsTags.append(name.title)
                    tapBlue.append(name.title)
                }
                else {
                    let name = searchTaxes[indexPath.row]
                    selectAddTaxes.append(name)
                    tapBlue.append(name.id)
                }
            }
        }
        // searching = false
        else {
            
            if cell.contentView.layer.borderColor == UIColor(named: "SelectCat")?.cgColor {
                
                cell.categoryName.textColor = .black
                cell.contentView.layer.borderColor = UIColor(named: "CategoryBorder")?.cgColor
                
                if apiMode == "category" {
                    let id = categories[indexPath.row].id
                    removeCategory(variantName: id)
                }
                else if apiMode == "brands" {
                    selectAddBrandsTags = []
                    tapBlue = []
                    selectBrandsTags = []
                    collection.reloadData()
                }
                else if apiMode == "its" || apiMode == "mts" || apiMode == "bts" {
                    itsSelectAll = false
                    let id = its[indexPath.row].merchant_id
                    removeIts(storeName: id)
                    selectLbl.textColor = .black
                    selectView.layer.borderColor = UIColor(named: "CategoryBorder")?.cgColor
                    selectView.layer.cornerRadius = 5.0
                    selectView.layer.borderWidth = 1
                }
                else if apiMode == "tags" {
                    let title = brandsTags[indexPath.row].title
                    removeTags(tagName: title)
                }
                else {
                    let id = taxes[indexPath.row].id
                    removeTaxes(taxesName: id)
                }
            }
            
            else {
                cell.contentView.layer.borderColor = UIColor(named: "SelectCat")?.cgColor
                cell.categoryName.textColor = UIColor(named: "SelectCat")
                
                if apiMode == "category" {
                    let name = categories[indexPath.row]
                    selectAddCategory.append(name)
                    tapBlue.append(name.id)
                }
                else if apiMode == "brands" {
                    let name = brandsTags[indexPath.row]
                    selectBrandsTags = [name.title]
                    selectAddBrandsTags = []
                    tapBlue = [name.title]
                    collection.reloadData()
                }
                else if apiMode == "its" || apiMode == "mts" || apiMode == "bts" {
                    let name = its[indexPath.row]
                    selectAddIts.append(name)
                    tapBlue.append(name.merchant_id)
                    if its.count == selectAddIts.count  {
                        itsSelectAll = true
                        selectView.layer.borderColor = UIColor(named: "SelectCat")?.cgColor
                        selectView.layer.cornerRadius = 5.0
                        selectView.layer.borderWidth = 1
                        selectLbl.textColor = UIColor(named: "SelectCat")
                    }
                    else {
                        itsSelectAll = false
                    }
                }
                else if apiMode == "tags" {
                    let name = brandsTags[indexPath.row]
                    selectAddBrandsTags.append(name.title)
                    tapBlue.append(name.title)
                }
                else {
                    let name = taxes[indexPath.row]
                    selectAddTaxes.append(name)
                    tapBlue.append(name.id)
                }
            }
        }
    }
}
