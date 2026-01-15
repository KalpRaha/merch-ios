//
//  ProductAndCategorySelectionVC.swift
//  QuickveeApp
//
//  Created by Pallavi on 08/01/26.
//

import UIKit
import BarcodeScanner

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


final class ProductAndCategorySelectionVC: UIViewController,Navigatable{
    
    static var storyboard: UIStoryboard {.productAndCategoryDiscount}
    
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var scanBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    
    var scannerDelegateHandler: BarcodeScannerDelegateHandler?
    
    var viewModel : ViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        viewModel.loadData()
        captureUPC()
        configureSearchBar()
        viewModel.isSearching = false
        
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
    
    private func updateUIForSearchFlag(){
        searchBtn.alpha =  viewModel.isSearching ? 0 : 1
        searchBar.alpha = viewModel.isSearching ? 1 : 0
        backBtn.alpha = viewModel.isSearching ? 0 : 1
        scanBtn.alpha = viewModel.isSearching ? 0 : 1
        
    }
    
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

}

extension ProductAndCategorySelectionVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.tableViewDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductAndCategorySelectionTBLCell") as! ProductAndCategorySelectionTBLCell
       
        cell.cellData = viewModel.tableViewDataSource[indexPath.row]
        
        cell.categoryData = viewModel.getCategoryData(indexPath.row)
        cell.mixMatchData = viewModel.getMixNMatchData(indexPath.row)
        cell.bogoData = viewModel.getBogoData(indexPath.row)
        
        cell.isSelectedCell = viewModel.selectedIndexPath.contains(indexPath)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if  viewModel.selectedIndexPath.contains(indexPath)  {
            viewModel.selectedIndexPath.removeAll(where: { $0 == indexPath})
            
        } else {
            
            viewModel.selectedIndexPath.append(indexPath)
            print(viewModel.variantList[indexPath.row])
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



extension ProductAndCategorySelectionVC: ProductAndCategorySelectionViewModelDelegate {
    
    func didUpdatedTableViewData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didUpdateSearchFlag() {
        updateUIForSearchFlag()
    }
    
}



