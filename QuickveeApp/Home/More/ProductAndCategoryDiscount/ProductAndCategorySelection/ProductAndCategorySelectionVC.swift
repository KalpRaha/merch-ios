//
//  ProductAndCategorySelectionVC.swift
//  QuickveeApp
//
//  Created by Pallavi on 08/01/26.
//

import UIKit

class ProductAndCategorySelectionVCFactory {
    
    static func make() -> ProductAndCategorySelectionVC {
        
        let vc = ProductAndCategorySelectionVC.instantiate()
        let apiService = APIServiceFactory.make()
        vc.viewModel = .init(
            
            repository: VariantListRepository(
                apiService: apiService
            ),
            categoryRepository: CategoryListRepository(
                apiService: apiService
            ),
            bogoRepository: BogoListRepository (
                apiService: apiService
            ),
            minMatchRepository:  MixnMatchListRepository (
                apiService: apiService
            )
        )
        vc.viewModel.delegate = vc
        
        
        return vc
    }
}


final class ProductAndCategorySelectionVC: UIViewController,Navigatable{
    
    static var storyboard: UIStoryboard {.productAndCategoryDiscount}
    
    
    @IBOutlet private weak var tableView: UITableView!
    
    
    
    var viewModel : ViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        // viewModel.variantListApicall()
        // viewModel.getVariantData()
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
    
    
    @IBAction func backBtnClick(_ sender: UIButton) {
        
    }
}

extension ProductAndCategorySelectionVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.variantList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductAndCategorySelectionTBLCell") as! ProductAndCategorySelectionTBLCell
        
        
        cell.cellData = viewModel.variantList[indexPath.row]
      
        let categoryData = viewModel.categoryList.first(where: { $0.id == viewModel.variantList[indexPath.row].category })
        cell.categoryData = categoryData
        
        let itemId = viewModel.variantList[indexPath.row].isVarient ? viewModel.variantList[indexPath.row].variantId : viewModel.variantList[indexPath.row].id
        
        let mixMatchData = viewModel.mixMatchList.filter({ $0.itemIds.contains(where:{$0 == itemId} ) }).first
        cell.mixMatchData = mixMatchData
       
       
        let bogoData = viewModel.bogoList.filter({ $0.items.contains(where:{$0 == itemId} ) }).first
        cell.bogoData = bogoData
        
        
        
        cell.isSelectedCell = viewModel.selectedIndexPath.contains(indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if  viewModel.selectedIndexPath.contains(indexPath)  {
            
            viewModel.selectedIndexPath.removeAll(where: { $0 == indexPath})
            print(viewModel.selectedIndexPath.removeAll(where: { $0 == indexPath}))
        }
        else {
            
            viewModel.selectedIndexPath.append(indexPath)
            print(viewModel.variantList[indexPath.row])
        }
        tableView.reloadRows(at: [indexPath], with: .none)
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ProductAndCategorySelectionTBLCell else { return }
    
    }
    
}

extension ProductAndCategorySelectionVC: ProductAndCategorySelectionViewModelDelegate {
    
    func loadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}



