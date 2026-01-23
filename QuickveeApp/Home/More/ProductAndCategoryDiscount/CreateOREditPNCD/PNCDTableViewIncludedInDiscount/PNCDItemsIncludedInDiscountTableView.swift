//
//  PNCDItemsIncludedInDiscountTableView.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 14/01/26.
//

import UIKit

class PNCDItemsIncludedInDiscountTableView: UITableView {
    
    typealias ItemDataType = VariantDataModel
    
    var dataItems: [ItemDataType] = []
    
    
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
    
    func configure(with dataItems: [ItemDataType]) {
        self.dataItems = dataItems
        
        self.delegate = self
        self.dataSource = self
        self.isScrollEnabled = false
        
        self.register(
            PNCDItemIncludedInDiscountTBLCell.nib,
            forCellReuseIdentifier: PNCDItemIncludedInDiscountTBLCell.className
        )
    }
    
    func reloadData(with dataItems: [ItemDataType]) {
        self.dataItems = dataItems
        reloadData()
    }
    
    private func setupUI() {
        // initial UI config
        
    }
}

extension PNCDItemsIncludedInDiscountTableView : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        typealias CellType = PNCDItemIncludedInDiscountTBLCell
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellType.className, for: indexPath) as? CellType else {
            
            
            return UITableViewCell()
        }
        cell.cellData = dataItems[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
