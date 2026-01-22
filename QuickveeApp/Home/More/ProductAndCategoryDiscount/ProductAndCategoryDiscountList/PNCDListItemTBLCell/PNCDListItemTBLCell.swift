//
//  PNCDListItemTBLCell.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 20/01/26.
//

import UIKit

class PNCDListItemTBLCell: UITableViewCell {

    
    @IBOutlet private weak var vwMainContainerView: UIView!
    @IBOutlet private weak var vwDiscountDetailBorderBGView: UIView!
    
    
    @IBOutlet private weak var lblDiscountName: ManropeBoldLabel!
    @IBOutlet private weak var lblDiscountAmount: ManropeExtraBoldLabel!
    
    @IBOutlet private weak var lblDiscountScheduleDate: ManropeBoldLabel!
    @IBOutlet private weak var lblDiscountScheduleTime: ManropeBoldLabel!
    
    
    @IBOutlet private weak var stkWeeklySelectionView: UIStackView!
    @IBOutlet private var vwWeeklyCapsulesView: [UIView]!
    @IBOutlet private var lblWeeklyCapsulesTitle: [UILabel]!
    
    
    var onClickEditPNCD: ( () -> Void )?
    
    var cellData: PNCDDiscountListItem! {
        didSet{
            updateUIWithData()
        }
    }
    
    var isEnabled : Bool = false {
        didSet{
            updateUIForEnableDisableState()
        }
    }

     var selectedWeekItems: Set<WeekDayItem> = [] {
        didSet{
            updateUIForWeeklySelectionView()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
 
    @IBAction private func onClickEditPNCDBtn(_ sender: UIButton) {
        onClickEditPNCD?()
        Logger.log(#function)
    }
    
    
}

private extension PNCDListItemTBLCell {
    
    func updateUIWithData() {
        guard let data = cellData else { return }
        
        lblDiscountName.text = "\(data.discountName) - (\(data.type.titleValue) Discount)"
        lblDiscountAmount.text = data.getDisplayValue() + " OFF"
        
        
        let startDate = PNCDDateFormatter.shared.getStringToDisplay(data.startDate)
        let endDate = PNCDDateFormatter.shared.getStringToDisplay(data.endDate)
        lblDiscountScheduleDate.text = "\(startDate) - \((endDate))"
        
        
        let startTime = PNCDTimeFormatter.shared.getStringToDisplay(data.startTime)
        let endTime = PNCDTimeFormatter.shared.getStringToDisplay(data.endTime)
        lblDiscountScheduleTime.text = "\(startTime) - \(endTime)"
        
        isEnabled = data.isDiscountDisable ? false : true
        
        updateUIForWeeklySelectionView()
    }
    
    private func updateUIForEnableDisableState(){
        vwMainContainerView.applyCornerRadius(cornerRadius: 8.0)
        
        vwMainContainerView.applyBorder(
            borderWidth: 1,
            borderColor: ._2DC574,
            borderOpacity: isEnabled ? 1 : 0
        )
        vwDiscountDetailBorderBGView.applyCornerRadius(cornerRadius: 8.0)
        vwDiscountDetailBorderBGView.applyBorder(
            borderWidth: 1,
            borderColor: .E4E8EF,
            borderOpacity: isEnabled ? 0 : 1
        )
    }
    
}

private extension PNCDListItemTBLCell {

    func updateUIForWeeklySelectionView(){
        let selectedWeekItems: Set<WeekDayItem> = Set(cellData?.selectedWeekDays ?? [])
        
        for (index, view )in vwWeeklyCapsulesView.enumerated() {
            
            let item = WeekDayItem.getItemFromIndex(index)
            let isSelected = selectedWeekItems.contains(item)
            
            view.backgroundColor = isSelected ? (._0A64F9.withAlphaComponent(isEnabled ? 1 : 0.6) ): .clear
            view.circularShape()
            view.applyBorder(
                borderWidth: isSelected ? 0 : 1,
                borderColor: isSelected ? ._575757 : .clear,
                borderOpacity: 1
            )
            if let lbl = view.subviews.first as? UILabel {
                lbl.textColor = isSelected ? .white : .black
            }
            
        }
        
    }

    
}
