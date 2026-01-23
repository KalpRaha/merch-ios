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
    
    
    @IBOutlet private weak var swtPNCDState: CustomSwitch!
    
    
    var onClickEditPNCD: ( () -> Void )?
    var onClickEnableDisable: ( () -> Void )?
    
    var isLoading: Bool = false {
        didSet{
            isLoading ? swtPNCDState.startLoading() : swtPNCDState.stopLoading()
        }
    }
    
    var cellData: PNCDDiscountListItem! {
        didSet{
            updateUIWithData()
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Ensure no stale loader or animated flips during reuse
        isLoading = false
        swtPNCDState.stopLoading()
        // Don’t force a specific on/off here; it will be set by updateUIWithData without animation.
        // But do ensure no pending animation is visible by reapplying current layout without animation.
        swtPNCDState.updateIsOnFlag(swtPNCDState.isOn, animated: false)
    }
 
    @IBAction private func onClickEditPNCDBtn(_ sender: UIButton) {
        onClickEditPNCD?()
        Logger.log(#function)
    }
    
    @IBAction private func onClickEnableDisablePNCD(_ sender: CustomSwitch) {
        // Do not start/stop loading here; VM drives it via enableDisableLoadingStateIds -> cell.isLoading
        onClickEnableDisable?()
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
        
        
        updateUIForWeeklySelectionView()
        
        let isEnabled = data.isDiscountDisable ? false : true
        
        updateUIForEnableDisableState(isEnabled: isEnabled)
    }
    
    private func updateUIForEnableDisableState(isEnabled: Bool){
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
        
        // Critical: no animation during cell configuration to avoid flicker from reuse
        swtPNCDState.updateIsOnFlag(isEnabled, animated: false)
    }
    
}

private extension PNCDListItemTBLCell {

    func updateUIForWeeklySelectionView(){
        let selectedWeekItems: Set<WeekDayItem> = Set(cellData?.selectedWeekDays ?? [])
        let isEnabled = cellData.isDiscountDisable ? false : true
        
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

