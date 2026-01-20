//
//  ProductAndCategoryDiscountListVC.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 07/01/26.
//

import UIKit

typealias PNCDListVC = ProductAndCategoryDiscountListVC

class ProductAndCategoryDiscountListVCFactory {
    
    static func make() -> PNCDListVC {
        let vc = ProductAndCategoryDiscountListVC.instantiate()
        
        vc.viewModel = .init(
            pncdRepository: ProductAndCategoryDiscountAPIRepository(
                apiService: APIServiceFactory.make()
            )
            
        )
        vc.viewModel.delegate = vc
        
        return vc
    }
    
}

final class ProductAndCategoryDiscountListVC: UIViewController, Navigatable {

    static var storyboard: UIStoryboard { .productAndCategoryDiscount }
    
    
    @IBOutlet private weak var vwNavigationHeader: CustomNavigationHeaderView!
    
    // Empty List View // No Discount View
    @IBOutlet private weak var vwNoDiscountView: UIView!
    @IBOutlet private weak var btnCreateDiscount: UIButton!
    
    
    // Discount List Table
    @IBOutlet private weak var vwDiscountListTableContainerView: UIView!
    @IBOutlet private weak var tblDiscountListView: UITableView!
    
    
    var viewModel : ViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        configureDiscountListTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getDiscountList()
    }
    
    private func updateUI(){
        vwNavigationHeader.delegate = self
        
        btnCreateDiscount.backgroundColor = ._0A64F9
        btnCreateDiscount.titleLabel?.font = FontFamily.ManropeMedium.size(15)
        btnCreateDiscount.applyCornerRadius(cornerRadius: 8)
    }

    private func configureDiscountListTableView() {
        tblDiscountListView.showsVerticalScrollIndicator = false
        tblDiscountListView.contentInset.top = 15
        tblDiscountListView.dataSource = self
        tblDiscountListView.delegate = self
        
        let nib = UINib(nibName: PNCDListItemTBLCell.className, bundle: nil)
        tblDiscountListView.register(nib, forCellReuseIdentifier: PNCDListItemTBLCell.className)
        
        viewModel.discountList = []
    }

    @IBAction private func onClickBtnCreateDiscount(_ sender: UIButton) {
        CreateProductAndCategoryDiscountVCFactory.make().push(in: self)
        Logger.log(#function)
    }
    
    
}

extension ProductAndCategoryDiscountListVC : CustomNavigationHeaderViewDelegate{
    
    func onClickBack() {
        popVC()
    }
    
    func setHeaderTitle() -> String {
        "Product or Category Discount"
    }
 
}

extension ProductAndCategoryDiscountListVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.discountList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PNCDListItemTBLCell.className, for: indexPath) as? PNCDListItemTBLCell else {
            return UITableViewCell()
        }
        
        cell.cellData = viewModel.discountList[indexPath.row]
        cell.onClickEditPNCD = { [weak self] in
            guard let self else { return }
            handleOnClickEditPNCD(indexPath: indexPath)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    private func handleOnClickEditPNCD(indexPath : IndexPath) {
        CreateProductAndCategoryDiscountVCFactory.make(
            discountItem: viewModel.discountList[indexPath.row]
        ).push(
            in: self
        )
    }
    
}

extension ProductAndCategoryDiscountListVC : ProductAndCategoryDiscountListVMProtocol {
 
    func didUpdatedDiscountList() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            if viewModel.discountList.isEmpty {
                
                vwNoDiscountView.isHidden = false
                vwDiscountListTableContainerView.isHidden = true
                
            }else{
                vwNoDiscountView.isHidden = true
                vwDiscountListTableContainerView.isHidden = false
                
                tblDiscountListView.reloadData()
            }
            
        }
    }
    
}
