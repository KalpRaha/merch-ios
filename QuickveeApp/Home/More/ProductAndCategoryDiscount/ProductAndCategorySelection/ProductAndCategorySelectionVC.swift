//
//  ProductAndCategorySelectionVC.swift
//  QuickveeApp
//
//  Created by Pallavi on 08/01/26.
//

import UIKit
import BarcodeScanner

protocol ProductAndCategorySelectionVCProtocol: AnyObject{
    func didSelectVariants(_ variants: [VariantDataModel])
    
}

class ProductAndCategorySelectionVCFactory {
    
    static func make() -> ProductAndCategorySelectionVC {
        
        let vc = ProductAndCategorySelectionVC.instantiate()
        let apiService = APIServiceFactory.make()
        
        vc.viewModel = .init(
            repository: VariantListAPIRepository(
                apiService: apiService
            ),
            categoryRepository: CategoryListAPIRepository(
                apiService: apiService
            ),
            bogoRepository: BogoListAPIRepository (
                apiService: apiService
            ),
            minMatchRepository:  MixnMatchAPIListRepository (
                apiService: apiService
            )
        )
        vc.viewModel.delegate = vc
        vc.scannerDelegateHandler = BarcodeScannerDelegateHandler()
        
        return vc
    }
}


final class ProductAndCategorySelectionVC: UIViewController,Navigatable {

    static var storyboard: UIStoryboard {.productAndCategoryDiscount}
    
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var scanBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var filterLbl: UILabel!
    
    var scannerDelegateHandler: BarcodeScannerDelegateHandler?
    
    var viewModel : ViewModel!
 
    weak var delegate: ProductAndCategorySelectionVCProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        captureUPC()
        configureSearchBar()
        updateUI()
        viewModel.isSearching = false
        viewModel.loadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    private func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName:ProductAndCategorySelectionTBLCell.className , bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ProductAndCategorySelectionTBLCell")
    }
    
    func captureUPC() {
        scannerDelegateHandler?.didCaptureCode = { [weak self] code,type in
            print(code)
        }
    }
    
    func configureSearchBar(){
        searchBar.showsCancelButton = true
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
    }
    
    func updateUI(){
        filterView.isHidden = true
        filterView.layer.cornerRadius = 12.5
        filterView.backgroundColor =  UIColor(named: "SelectCat")
        filterLbl.font = UIFont(name: "Manrope-Medium", size: 12.0)!
        filterLbl.textColor = UIColor.white
    }
    
    func updateCategoryCountUI() {
        let count = viewModel.selectedCategories.count
        print("DEBUG count:", count)
        
        if count > 0 {
            filterView.isHidden = false
            filterLbl.isHidden = false
            filterLbl.text = "\(count)"

        } else {
            filterView.isHidden = true
            filterLbl.isHidden = true
        }
    }

    private func updateUIForSearchFlag(){
        searchBtn.alpha =  viewModel.isSearching ? 0 : 1
        searchBar.alpha = viewModel.isSearching ? 1 : 0
        backBtn.alpha = viewModel.isSearching ? 0 : 1
        scanBtn.alpha = viewModel.isSearching ? 0 : 1
    }
    
    // MARK: - IBAction
    
    @IBAction func backBtnClick(_ sender: UIButton) {
        popVC()
    }
    
    
    @IBAction func searchBtnClick(_ sender: UIButton) {
        viewModel.isSearching = true
    }
    
    @IBAction func scanBtnClick(_ sender: UIButton) {
        
        let vc = BarcodeScannerViewController()
        vc.codeDelegate = scannerDelegateHandler
        vc.errorDelegate = scannerDelegateHandler
        vc.dismissalDelegate = scannerDelegateHandler
        self.present(vc, animated: true)
    }

    @IBAction func categoryfilterBtnClick(_ sender: UIButton) {
        
        FilterCategoryViewController.present(in: self, passData: { [weak self] vc in
            guard let self else { return }
            vc.delegateProductAndCategorySelected = self
            vc.catMode = "prodAndCatVc"
            vc.apiMode = "category"
            vc.selectCategory = viewModel.selectedCategories
        } ,completion: {
            // vc.presentationController?.presentedView?.gestureRecognizers?[0].isEnabled = false
            
        })
    }
    
    
    @IBAction func cancelBtnClick(_ sender: CustomButton) {
        dismiss(animated: true)
    }
    
        
    @IBAction func confirmBtnClick(_ sender: CustomButton) {
        
        let result = viewModel.selectedIndexPath.map {
            viewModel.variantList[$0.row]
        }
        delegate?.didSelectVariants(result)
        popVC()
    }
}

extension ProductAndCategorySelectionVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.discounttype == .product {
            viewModel.tableViewDataSource.count

        }else{
            viewModel.categoryList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductAndCategorySelectionTBLCell") as! ProductAndCategorySelectionTBLCell
        
        if viewModel.discounttype == .product {
            
            cell.cellData = viewModel.tableViewDataSource[indexPath.row]
            
            cell.categoryData = viewModel.getCategoryData(indexPath.row)
            cell.mixMatchData = viewModel.getMixNMatchData(indexPath.row)
            cell.bogoData = viewModel.getBogoData(indexPath.row)
            
            cell.isSelectedCell = viewModel.selectedIndexPath.contains(indexPath)
            
        }else {
            
            let categoryData = viewModel.categoryList[indexPath.row]
            let promotionalVariants = viewModel.variantList.filter({ $0.category == categoryData.id })
            
            
            var mixNmatchPromotionVariants : [VariantDataModel] = []
            for mixMatchData in viewModel.mixMatchList {
                let mixNmatch = promotionalVariants.filter({ mixMatchData.itemIds.contains($0.itemId) })
                mixNmatchPromotionVariants.append(contentsOf: mixNmatch)
                
                print(mixNmatchPromotionVariants)
            }
            
            var bogoPromotionVariants : [VariantDataModel] = []
            for bogoData in viewModel.bogoList {
                let bogoPromotion = promotionalVariants.filter({ bogoData.items.contains($0.itemId) })
                bogoPromotionVariants.append(contentsOf: bogoPromotion)
            }
            
            let type: ProductAndCategorySelectionTBLCell.PromotionType = {
                
                let finalData = mixNmatchPromotionVariants + bogoPromotionVariants
                
                if finalData.isEmpty {
                    return .none
                }else if finalData.count == 1 {
                    
                    let dealName: String = {
                        if let variant =  finalData.first {
                            if mixNmatchPromotionVariants.count == 1 {
                                return viewModel.mixMatchList.filter({ $0.itemIds.contains( variant.itemId) }).first?.dealName ?? ""
                            }
                            else {
                                return viewModel.bogoList.filter({ $0.items.contains( variant.itemId) }).first?.dealName ?? ""
                            }
                        }
                        else {
                            return ""
                        }
                        
                    }()
                    
                    return .singlePromotion(dealName)
                }else {
                    return .MultiplePromotion
                }
                
            }()
            
            Logger.log("Found some. ")
            
            cell.updateUIForCategoryData(
                title: categoryData.title ?? "Title",
                productCount: promotionalVariants.count.toString(),
                promotionType: type
            )
            cell.isSelectedCell = viewModel.selectedIndexPath.contains(indexPath)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if  viewModel.selectedIndexPath.contains(indexPath)  {
            viewModel.selectedIndexPath.removeAll(where: { $0 == indexPath})
        } else {
            viewModel.selectedIndexPath.append(indexPath)
        }
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}


extension ProductAndCategorySelectionVC : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchQuery = searchText
        print(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchQuery = ""
        searchBar.text = ""
        viewModel.isSearching = false
        view.endEditing(true)
    }
}

extension ProductAndCategorySelectionVC : SelectedCategoryProductsDelegate {
    func getProductsCategory(categoryArray: [InventoryCategory]) {
        viewModel.selectedCategories = categoryArray
    }
}

extension ProductAndCategorySelectionVC: ProductAndCategorySelectionViewModelDelegate {
    func didUpdateSelectedCategories() {
        viewModel.selectedCategories.count
        DispatchQueue.main.async {
            self.updateCategoryCountUI()
        }
    }
    
    func didUpdatedTableViewData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didUpdateSearchFlag() {
        updateUIForSearchFlag()
    }
    
}






