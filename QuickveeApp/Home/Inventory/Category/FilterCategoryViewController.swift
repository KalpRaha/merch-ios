//
//  FilterCategoryViewController.swift
//
//
//  Created by Jamaluddin Syed on 9/27/23.
//

import UIKit

protocol BrandsTagsAddDelegate: AnyObject {
    
    func callBrandTagFilter(brandtag: String)
}

class FilterCategoryViewController: UIViewController {
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var applyBtn: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var selectText: UILabel!
    
    @IBOutlet weak var selectView: UIView!
    @IBOutlet weak var selectStatus: UILabel!
    @IBOutlet weak var selectVendor: UILabel!
    
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var noCategoryLbl: UILabel!
    
    @IBOutlet weak var addView: UIView!
    
    @IBOutlet weak var searchBarHeight: NSLayoutConstraint!
    @IBOutlet weak var addBtnHeight: NSLayoutConstraint!
    
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
    
    //Vendors arrays
    var selectVendors = [VendorsPO]()
    var selectAddVendors = [VendorsPO]()
    
    var vendors = [VendorsPO]()
    var subVendors = [VendorsPO]()
    var searchVendors = [VendorsPO]()
    
    var selectPOStatus = [String]()
    var selectAddPOStatus = [String]()
    
    var poStatus = ["Active", "Partial", "Received", "Draft", "Void"]
    var subPOStatus = [String]()
    var searchPOStatus = [String]()
    
    var tapBlue = [String]()
    
    var newBrandTag = false
    var newBrandTagName = ""
    
    weak var delegateProducts: SelectedCategoryProductsDelegate?
    weak var delegatePlus: PlusSelectedCategory?
    weak var delegateDuplicate: PlusSelectedCategory?
    weak var delegateVariants: SelectedCategoryProductsDelegate?
    
    weak var delegateLottery: SelectedCategoryProductsDelegate?
    weak var delegateMixSelected: SelectedCategoryProductsDelegate?
    weak var delegateBogoSelected: SelectedCategoryProductsDelegate?
    weak var delegateCouponSelected: SelectedCategoryProductsDelegate?
    
    weak var delegatePOSelected: SelectedCategoryProductsDelegate?
    
    weak var delegateBrandTagsSelected: BrandsTagsAddDelegate?
    
    weak var delegateVendorsSelected: POListDelegate?
    weak var delegateVendorSelected: PODelegate?
    
    
    var catMode = ""
    var apiMode = ""
    var searching = false
    var variantMixList = [MixVariantModel]()
    var alredCatselect = [VariantMixMatchModel]()
    var productsList = [InventoryProductModel]()
    var bogoVarientList = [BogoVariantModel]()
    var variantList = [InventoryVariant]()
    
    var isPOStatus = false
    
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
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(vendorClick))
        selectVendor.addGestureRecognizer(tap1)
        tap1.numberOfTapsRequired = 1
        selectVendor.isUserInteractionEnabled = true
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(statusClick))
        selectStatus.addGestureRecognizer(tap2)
        tap2.numberOfTapsRequired = 1
        selectStatus.isUserInteractionEnabled = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
        subCategory = []
        subBrandsTags = []
        subTaxes = []
        
        selectView.isHidden = true
        selectVendor.text = ""
        selectStatus.text = ""
        selectVendor.isHidden = true
        selectStatus.isHidden = true
        selectText.isHidden = false
        searchBar.isHidden = false
        searchBarHeight.constant = 50
        
        addBtn.setTitle("Add New", for: .normal)
        addBtn.layer.cornerRadius = 10
        addBtn.layer.borderColor = UIColor(hexString: "#0A64F9").cgColor
        addBtn.layer.borderWidth = 1.0
        
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
        else if apiMode == "vendors" || apiMode == "vendor" {
            if apiMode == "vendor" {
                selectText.text = "Select Vendor"
                selectText.isHidden = false
                selectView.isHidden = true
                selectVendor.text = ""
                selectStatus.text = ""
                selectVendor.isHidden = true
                selectStatus.isHidden = true
            }
            else {
                selectText.text = ""
                selectText.isHidden = true
                selectView.isHidden = false
                selectVendor.text = "Select Vendor"
                selectStatus.text = "Select Status"
                selectVendor.isHidden = false
                selectStatus.isHidden = false
                selectVendor.textColor = UIColor(named: "SelectCat")
                searchBar.isHidden = true
                searchBarHeight.constant = 0
            }
            searchBar.placeholder = "Search Vendor"
            noCategoryLbl.text = "No Vendor Found"
            setupVendorsApi()
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
            
            else if catMode == "poQuickVc" {
                if category.is_lottery == "0" {
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
    
    func removeVendors(tagName: String) {
        
        selectAddVendors.removeAll(where: {$0.name == tagName})
        tapBlue.removeAll(where: {$0 == tagName})
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
    
    func setupVendorsApi() {
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        ApiCalls.sharedCall.getVendorList(merchant_id: id) { isSuccess, responseData in
            
            if isSuccess {
                
                guard let list = responseData["result"] else {
                    self.loadingIndicator.isAnimating = false
                    return
                }
                
                self.getResponsePOValues(list: list)
                
                DispatchQueue.main.async {
                    self.collection.reloadData()
                }
                
            }else{
                print("Api Error")
                self.loadingIndicator.isAnimating = false
            }
        }
    }
    
    func getResponsePOValues(list: Any) {
        
        let response = list as! [[String:Any]]
        var smallres = [VendorsPO]()
        
        for res in response {
            
            let vendor = VendorsPO(vendor_id: "\(res["vendor_id"] ?? "")", name: "\(res["name"] ?? "")",
                                   phone: "\(res["phone"] ?? "")", email: "\(res["email"] ?? "")",
                                   city: "\(res["city"] ?? "")", state: "\(res["state"] ?? "")",
                                   zip_code: "\(res["zip_code"] ?? "")", full_address: "\(res["full_address"] ?? "")",
                                   pay_count: "\(res["pay_count"] ?? "")", total_pay: "\(res["total_pay"] ?? "")",
                                   recent_pay_amount: "\(res["recent_pay_amount"] ?? "")",
                                   recent_payment_datetime: "\(res["recent_payment_datetime"] ?? "")",
                                   enabled: "\(res["enabled"] ?? "")")
            
            if vendor.name == "Select Vendor" {
                
            }
            else {
                smallres.append(vendor)
            }
        }
        
        let sortedNames = smallres.sorted { $0.name < $1.name }
        
        vendors = sortedNames
        subVendors = sortedNames
        
        if selectVendors.count > 0 {
            
            for select in selectVendors {
                
                selectAddVendors.append(select)
            }
        }
    }
    
    @objc func vendorClick() {
        isPOStatus = false
        selectVendor.textColor = UIColor(named: "SelectCat")
        selectStatus.textColor = .black
        collection.reloadData()
    }
    
    @objc func statusClick() {
        isPOStatus = true
        selectVendor.textColor = .black
        selectStatus.textColor = UIColor(named: "SelectCat")
        collection.reloadData()
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
        
        else if catMode == "POVc" {
            dismiss(animated: true)
        }
        
        else if catMode == "AddPOVc" {
            dismiss(animated: true)
        }
        
        else if catMode == "lotteryVc" {
            dismiss(animated: true)
        }
        
        else if catMode == "poQuickVc" {
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
                                                   reverseTaxes: [], apiMode: self.apiMode)
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
                self.delegateDuplicate?.getSelectedCats(reverseCategory: [], reverseBrandsTags: [], reverseTaxes: [], apiMode: self.apiMode)
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
        
        else if catMode == "POVc" {
            
            loadingIndicator.isAnimating = true
            selectVendors = []
            tapBlue = []
            selectAddVendors = []
            selectPOStatus = []
            selectAddPOStatus = []
            collection.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.loadingIndicator.isAnimating = false
                self.delegateVendorsSelected?.getPOVendors(vendors: [], status: [])
                self.dismiss(animated: true)
            }
        }
        
        else if catMode == "AddPOVc" {
            
            loadingIndicator.isAnimating = true
            selectVendors = []
            tapBlue = []
            selectAddVendors = []
            collection.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.loadingIndicator.isAnimating = false
                self.delegateVendorSelected?.getPOVendor(vendor: [])
                self.dismiss(animated: true)
            }
        }
        
        else if catMode == "poQuickVc" {
            
            loadingIndicator.isAnimating = true
            selectCategory = []
            tapBlue = []
            selectAddCategory = []
            collection.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.loadingIndicator.isAnimating = false
                self.delegatePOSelected?.getProductsCategory(categoryArray: [])
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
                                                  reverseTaxes: selectAddTaxes, apiMode: apiMode)
                    dismiss(animated: true)
                }
            }
            else {
                delegatePlus?.getSelectedCats(reverseCategory: selectAddCategory,
                                              reverseBrandsTags: selectAddBrandsTags,
                                              reverseTaxes: selectAddTaxes, apiMode: apiMode)
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
                                                       reverseTaxes: selectAddTaxes, apiMode: apiMode)
                    dismiss(animated: true)
                }
            }
            else {
                delegateDuplicate?.getSelectedCats(reverseCategory: selectAddCategory,
                                                   reverseBrandsTags: selectAddBrandsTags,
                                                   reverseTaxes: selectAddTaxes, apiMode: apiMode)
                dismiss(animated: true)
            }
        }
        else if catMode == "POVc" {
            
            if isPOStatus {
                delegateVendorsSelected?.getPOVendors(vendors: [], status: selectAddPOStatus)
            }
            else {
                delegateVendorsSelected?.getPOVendors(vendors: selectAddVendors, status: [])
            }
            dismiss(animated: true)
        }
        else if catMode == "AddPOVc" {
            
            delegateVendorSelected?.getPOVendor(vendor: selectAddVendors)
            dismiss(animated: true)
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
        
        else if catMode == "poQuickVc" {
            
            self.dismiss(animated: true) {
                self.delegatePOSelected?.getProductsCategory(categoryArray: self.selectAddCategory)
            }
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
            else if apiMode == "vendors" || apiMode == "vendor" {
                searchVendors = subVendors.filter { $0.name.lowercased().prefix(searchText.count) == searchText.lowercased() }
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
            
            if apiMode == "category" {
                if searchCategory.count == 0 {
                    collection.isHidden = true
                    addView.isHidden = true
                    addBtn.isHidden = true
                    noCategoryLbl.isHidden = false
                }
                else {
                    collection.isHidden = false
                    addView.isHidden = true
                    addBtn.isHidden = true
                    noCategoryLbl.isHidden = true
                }
            }
            else if apiMode == "vendors" || apiMode == "vendor" {
                if searchVendors.count == 0 {
                    collection.isHidden = true
                    addView.isHidden = true
                    addBtn.isHidden = true
                    noCategoryLbl.isHidden = false
                }
                else {
                    collection.isHidden = false
                    addView.isHidden = true
                    addBtn.isHidden = true
                    noCategoryLbl.isHidden = true
                }
            }
            else {
                if searchTaxes.count == 0 {
                    collection.isHidden = true
                    addView.isHidden = true
                    addBtn.isHidden = true
                    noCategoryLbl.isHidden = false
                }
                else {
                    collection.isHidden = false
                    addView.isHidden = true
                    addBtn.isHidden = true
                    noCategoryLbl.isHidden = true
                }
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
            else if apiMode == "vendors" || apiMode == "vendor" {
                if isPOStatus {
                    return searchPOStatus.count
                }
                else {
                    return searchVendors.count
                }
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
            else if apiMode == "vendors" || apiMode == "vendor" {
                if isPOStatus {
                    return poStatus.count
                }
                else {
                    return vendors.count
                }
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
            else if apiMode == "vendors" {
                
                if isPOStatus {
                    cell.categoryName.text = poStatus[indexPath.row]
                    
                    if selectPOStatus.contains(where: {$0 == searchPOStatus[indexPath.row]})
                        || tapBlue.contains(where: {$0 == searchPOStatus[indexPath.row]}) {
                        cell.contentView.layer.borderColor = UIColor(named: "SelectCat")?.cgColor
                        cell.categoryName.textColor = UIColor(named: "SelectCat")
                        selectAddPOStatus.append(searchPOStatus[indexPath.row])
                    }
                    else {
                        cell.categoryName.textColor = .black
                        cell.contentView.layer.borderColor = UIColor(named: "CategoryBorder")?.cgColor
                    }
                }
                else {
                    cell.categoryName.text = searchVendors[indexPath.row].name
                    
                    if selectVendors.contains(where: {$0.name == searchVendors[indexPath.row].name})
                        || tapBlue.contains(where: {$0 == searchVendors[indexPath.row].name}) {
                        cell.contentView.layer.borderColor = UIColor(named: "SelectCat")?.cgColor
                        cell.categoryName.textColor = UIColor(named: "SelectCat")
                    }
                    else {
                        cell.categoryName.textColor = .black
                        cell.contentView.layer.borderColor = UIColor(named: "CategoryBorder")?.cgColor
                    }
                }
            }
            else if apiMode == "vendor" {
                
                cell.categoryName.text = searchVendors[indexPath.row].name
                
                if selectVendors.contains(where: {$0.name == searchVendors[indexPath.row].name})
                    || tapBlue.contains(where: {$0 == searchVendors[indexPath.row].name}) {
                    cell.contentView.layer.borderColor = UIColor(named: "SelectCat")?.cgColor
                    cell.categoryName.textColor = UIColor(named: "SelectCat")
                    selectAddVendors.append(searchVendors[indexPath.row])
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
            else if apiMode == "vendors" {
                
                if isPOStatus {
                    cell.categoryName.text = poStatus[indexPath.row]
                    
                    if selectPOStatus.contains(where: {$0 == poStatus[indexPath.row]})
                        || tapBlue.contains(where: {$0 == poStatus[indexPath.row]}) {
                        cell.contentView.layer.borderColor = UIColor(named: "SelectCat")?.cgColor
                        cell.categoryName.textColor = UIColor(named: "SelectCat")
                        selectAddPOStatus.append(poStatus[indexPath.row])
                    }
                    else {
                        cell.categoryName.textColor = .black
                        cell.contentView.layer.borderColor = UIColor(named: "CategoryBorder")?.cgColor
                    }
                }
                else {
                    cell.categoryName.text = vendors[indexPath.row].name
                    
                    if selectVendors.contains(where: {$0.name == vendors[indexPath.row].name}) {
                        cell.contentView.layer.borderColor = UIColor(named: "SelectCat")?.cgColor
                        cell.categoryName.textColor = UIColor(named: "SelectCat")
                    }
                    
                    else if tapBlue.contains(where: {$0 == vendors[indexPath.row].name}) {
                        cell.contentView.layer.borderColor = UIColor(named: "SelectCat")?.cgColor
                        cell.categoryName.textColor = UIColor(named: "SelectCat")
                        selectAddVendors.append(vendors[indexPath.row])
                    }
                    else {
                        cell.categoryName.textColor = .black
                        cell.contentView.layer.borderColor = UIColor(named: "CategoryBorder")?.cgColor
                    }
                }
            }
            else if apiMode == "vendor" {
                
                cell.categoryName.text = vendors[indexPath.row].name
                
                if selectVendors.contains(where: {$0.name == vendors[indexPath.row].name})
                    || tapBlue.contains(where: {$0 == vendors[indexPath.row].name}) {
                    cell.contentView.layer.borderColor = UIColor(named: "SelectCat")?.cgColor
                    cell.categoryName.textColor = UIColor(named: "SelectCat")
                    selectAddVendors.append(vendors[indexPath.row])
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
                else if apiMode == "tags" {
                    let title = searchBrandsTags[indexPath.row].title
                    removeTags(tagName: title)
                }
                else if apiMode == "vendors" {
                    if isPOStatus {
                        selectAddPOStatus = []
                        tapBlue = []
                        selectPOStatus = []
                        collection.reloadData()
                    }
                    else {
                        let title = searchVendors[indexPath.row].name
                        removeVendors(tagName: title)
                    }
                }
                else if apiMode == "vendor" {
                    selectAddVendors = []
                    tapBlue = []
                    selectVendors = []
                    collection.reloadData()
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
                else if apiMode == "tags" {
                    let name = brandsTags[indexPath.row]
                    selectAddBrandsTags.append(name.title)
                    tapBlue.append(name.title)
                }
                else if apiMode == "vendors" {
                    if isPOStatus {
                        let name = searchPOStatus[indexPath.row]
                        selectPOStatus = [name]
                        selectAddPOStatus = []
                        tapBlue = [name]
                        collection.reloadData()
                    }
                    else {
                        let name = searchVendors[indexPath.row]
                        selectAddVendors.append(name)
                        tapBlue.append(name.name)
                    }
                }
                else if apiMode == "vendor" {
                    let name = searchVendors[indexPath.row]
                    selectVendors = [name]
                    selectAddVendors = []
                    tapBlue = [name.name]
                    collection.reloadData()
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
                else if apiMode == "vendors" {
                    if isPOStatus {
                        selectPOStatus = []
                        selectAddPOStatus = []
                        tapBlue = []
                        collection.reloadData()
                    }
                    else {
                        let name = vendors[indexPath.row]
                        removeVendors(tagName: name.name)
                    }
                }
                else if apiMode == "vendor" {
                    selectVendors = []
                    selectAddVendors = []
                    tapBlue = []
                    collection.reloadData()
                }
                else if apiMode == "tags" {
                    let title = brandsTags[indexPath.row].title
                    removeVendors(tagName: title)
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
                else if apiMode == "tags" {
                    let name = brandsTags[indexPath.row]
                    selectAddBrandsTags.append(name.title)
                    tapBlue.append(name.title)
                }
                else if apiMode == "vendors" {
                    if isPOStatus {
                        let name = poStatus[indexPath.row]
                        selectPOStatus = [name]
                        selectAddPOStatus = []
                        tapBlue = [name]
                        collection.reloadData()
                    }
                    else {
                        let name = vendors[indexPath.row]
                        selectAddVendors.append(name)
                        tapBlue.append(name.name)
                    }
                }
                else if apiMode == "vendor" {
                    let name = vendors[indexPath.row]
                    selectVendors = [name]
                    selectAddVendors = []
                    tapBlue = [name.name]
                    collection.reloadData()
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
