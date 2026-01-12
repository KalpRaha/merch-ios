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
        vc.viewModel = .init(
            repository: VariantListRepository(
                apiService: APIServiceFactory.make()
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
        viewModel.variantListApicall()
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
        
      //  cell.isSelectedCell = false
    }
    
}

extension ProductAndCategorySelectionVC: ProductAndCategorySelectionViewModelDelegate {
    
    func variantListApicall() {
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        
    }
    
}



