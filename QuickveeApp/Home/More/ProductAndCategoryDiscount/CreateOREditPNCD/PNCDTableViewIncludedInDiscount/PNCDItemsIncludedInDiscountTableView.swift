//
//  PNCDItemsIncludedInDiscountTableView.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 14/01/26.
//

import UIKit

class PNCDItemsIncludedInDiscountTableView: UITableView {
    
   
    var type : PNCDType = .product
    
    var variantItems: [VariantDataModel] = []
    var categoriesItems: [CategoryDataModel] = []
    
    
    
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(
            width: UIView.noIntrinsicMetric,
            height: contentSize.height
        )
    }
    
    func configure(with dataItems: [VariantDataModel]) {
        self.variantItems = dataItems
        
    }
    
    
    func configure(with dataItems: [CategoryDataModel]) {
        self.categoriesItems = dataItems
        
    }
    
    
    func configure() {
        
        
        self.delegate = self
        self.dataSource = self
        self.isScrollEnabled = false
        
        self.register(
            PNCDItemIncludedInDiscountTBLCell.nib,
            forCellReuseIdentifier: PNCDItemIncludedInDiscountTBLCell.className
        )
    }
    
    func reloadData(with dataItems: [VariantDataModel]) {
        self.variantItems = dataItems
        reloadData()
    }
    
    func reloadData(with dataItems: [CategoryDataModel]) {
        self.categoriesItems = dataItems
        reloadData()
    }
    
    private func setupUI() {
        // initial UI config
        
    }
}

extension PNCDItemsIncludedInDiscountTableView : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if type == .product {
            variantItems.count
        }
        else {
            categoriesItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        typealias CellType = PNCDItemIncludedInDiscountTBLCell
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellType.className, for: indexPath) as? CellType else {
            
            
            return UITableViewCell()
        }
        
        if type == .product {
            cell.cellData = variantItems[indexPath.row]
        }
        else {
            cell.categoryCellData = categoriesItems[indexPath.row]
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
