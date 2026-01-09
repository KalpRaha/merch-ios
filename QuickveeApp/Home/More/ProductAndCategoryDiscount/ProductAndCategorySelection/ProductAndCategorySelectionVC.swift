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
        
        return vc
    }
}


final class ProductAndCategorySelectionVC: UIViewController,Navigatable{
    
    static var storyboard: UIStoryboard {.productAndCategoryDiscount}
    
    
    @IBOutlet weak var tableview: UITableView!
    
    
    
    var viewModel : ViewModel!
    var variantListArr = [InventoryVariant]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        viewModel.getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    private func configureTableView(){
        tableview.delegate = self
        tableview.dataSource = self
        
        let nib = UINib(nibName:ProductAndCategorySelectionTBLCell.className , bundle: nil)
        tableview.register(nib, forCellReuseIdentifier: "ProductAndCategorySelectionTBLCell")
    }
      
}

extension ProductAndCategorySelectionVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductAndCategorySelectionTBLCell") as! ProductAndCategorySelectionTBLCell
        return cell
    }
    
    
}

extension ProductAndCategorySelectionVC: ProductAndCategorySelectionViewModelDelegate {
    
    func getVariasntList() {
        Logger.log(viewModel.variantList)
    }
    
}

