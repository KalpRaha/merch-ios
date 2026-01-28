//
//  PNCDListVC.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 07/01/26.
//

import UIKit

typealias ProductAndCategoryDiscountListVC = PNCDListVC

class PNCDListVCFactory {
    
    static func make() -> PNCDListVC {
        let vc = PNCDListVC.instantiate()
        
        vc.viewModel = .init(
            pncdRepository: PNCDAPIRepository(
                dataEnvironment: .live,
                apiService: APIServiceFactory.make(),
                mockDataService: .init()
            )
            
        )
        vc.viewModel.delegate = vc
        
        return vc
    }
    
}

final class PNCDListVC: UIViewController, Navigatable {

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
        
        
        tblDiscountListView.addPullToRefresh(configControl: { [weak self] control in
            guard let _ = self else { return }
            
            control.tintColor = .black
            
        }, action: { [weak self] action in
            guard let self else { return }
            
            viewModel.getDiscountList()
        })
        
    }

    private func configureDiscountListTableView() {
        tblDiscountListView.showsVerticalScrollIndicator = false
        tblDiscountListView.contentInset.top = 15
        tblDiscountListView.contentInset.bottom = 50
        tblDiscountListView.dataSource = self
        tblDiscountListView.delegate = self
        
        tblDiscountListView.register(PNCDListItemTBLCell.nib, forCellReuseIdentifier: PNCDListItemTBLCell.className)
        
        updateDiscountListTableView()
    }
    
    private func updateDiscountListTableView(){
        if viewModel.discountList.isEmpty {
            
            vwNoDiscountView.isHidden = false
            vwDiscountListTableContainerView.isHidden = true
            
        }else{
            vwNoDiscountView.isHidden = true
            vwDiscountListTableContainerView.isHidden = false
            
            tblDiscountListView.refreshControl?.endRefreshing()
            tblDiscountListView.reloadData()
        }
    }
    
    @IBAction private func onClickBtnCreateDiscount(_ sender: UIButton) {
        CreateOREditPNCDVCFactory.make().push(in: self)
        Logger.log(#function)
    }
    
    
    @IBAction private func onClickBtnAddDiscount(_ sender: AddItemButton) {
        CreateOREditPNCDVCFactory.make().push(in: self)
        Logger.log(#function)
    }
    
    
}

extension PNCDListVC : CustomNavigationHeaderViewDelegate{
    
    func onClickBack() {
        popVC()
    }
    
    func setHeaderTitle() -> String {
        "Product or Category Discount"
    }
 
}

extension PNCDListVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.discountList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PNCDListItemTBLCell.className, for: indexPath) as? PNCDListItemTBLCell else {
            return UITableViewCell()
        }
        
        cell.cellData = viewModel.discountList[indexPath.row]
        cell.isLoading = viewModel.enableDisableLoadingStateIds.contains(cell.cellData.id ?? "")
        
        cell.onClickEditPNCD = { [weak self] in
            guard let self else { return }
            handleOnClickEditPNCD(indexPath: indexPath)
        }
        
        cell.onClickEnableDisable = { [weak self] in
            guard let self else { return }
            if let pncdID = cell.cellData.id {
                // Prefer id-based method (avoids reuse/index issues)
                viewModel.enableDisableDiscountList(pncdID: pncdID)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    private func handleOnClickEditPNCD(indexPath : IndexPath) {
        CreateOREditPNCDVCFactory.make(
            discountItem: viewModel.discountList[indexPath.row]
        ).push(
            in: self
        )
    }
    
}

extension PNCDListVC : ProductAndCategoryDiscountListVMProtocol {
 
    func didUpdatedDiscountList() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            updateDiscountListTableView()
        }
    }
    
    func didUpdatedEnableDisableLoadingStateIds() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            updateDiscountListTableView()
        }
    }
    
}

