//
//  CreateOREditPNCDVC.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 07/01/26.
//

import UIKit

typealias CreatePNCDVC = CreateOREditPNCDVC

class CreateOREditPNCDVCFactory {
    
    static func make(
        discountItem : PNCDDiscountListItem? = nil
        
    ) -> CreateOREditPNCDVC {
    
        let vc = CreateOREditPNCDVC.instantiate()
        
        vc.viewModel = CreateOREditPNCDVC.ViewModel(
            editableDiscountItem: discountItem,
            builder: .init(merchantId: UDHelper.shared.merchantId)
        )

        return vc
    }
}


final class CreateOREditPNCDVC: UIViewController, Navigatable {

    static var storyboard: UIStoryboard { .productAndCategoryDiscount }
    
    
    @IBOutlet private weak var vwNavigationHeader: CustomNavigationHeaderView!
    @IBOutlet private weak var srcScrollView: UIScrollView!
    
    
    // Discount Type Selection View
    @IBOutlet weak var vwProductDiscountTypeSelectionView: UIView!
    @IBOutlet weak var lblProductDiscountTypeSelectionViewTitle: UILabel!
    @IBOutlet weak var lblProductDiscountTypeSelectionViewSubTitle: UILabel!
    
    @IBOutlet weak var vwCategoryDiscountTypeSelectionView: UIView!
    @IBOutlet weak var lblCategoryDiscountTypeSelectionViewTitle: UILabel!
    @IBOutlet weak var lblCategoryDiscountTypeSelectionViewSubTitle: UILabel!

    
    // DiscountDetails
    @IBOutlet private weak var swtAllowDiscountStackWithOtherDiscounts: CustomSwitch!
    
    
    // Discount Name and Discount per item
    @IBOutlet weak var lblDiscountName: UILabel!
    @IBOutlet weak var txtDiscountName: UITextField!
    
    @IBOutlet weak var lblDiscountInputValueTypeTitle: UILabel!
    @IBOutlet weak var txtDiscountInputValueType: UITextField!
    
    
    @IBOutlet weak var segCtrlDiscountInputValueType : CustomSegmentedControl!
    @IBOutlet weak var segCtrlDiscountScheduleType : CustomSegmentedControl!
    @IBOutlet weak var swtDealHasNoEndDate: CustomSwitch!
    
    // Date picker
    @IBOutlet weak var dtPickerDealStartDate: DatePickerInputView!
    @IBOutlet weak var dtPickerDealEndDate: DatePickerInputView!
    
    // Weekly date picker
    @IBOutlet private weak var vwWeeklySelectionView : WeeklySelectionView!
    
    // Deal is active for full day
    @IBOutlet private weak var swtDealIsActiveForFullDay : CustomSwitch!
    
    // Time picker
    @IBOutlet weak var dtPickerDealStartTime: DatePickerInputView!
    @IBOutlet weak var dtPickerDealEndTime: DatePickerInputView!
    
    // Add Product OR Category Button
    @IBOutlet private weak var vwAddProductORCategoryBtnSuperView: UIView!
    @IBOutlet weak var lblAddProductORCategoryBtn: UILabel!
    @IBOutlet weak var btnAddProductORCategory: CustomButton!
    
    
    // Edit Products or categories inlcuded in this Discount
    @IBOutlet private weak var vwEditProductORCategorySuperView: UIView!
    @IBOutlet private weak var vwEditProductORCategoryBtnSuperView: UIView!
    @IBOutlet weak var lblEditProductORCategoryBtn: UILabel!
    
    @IBOutlet private weak var tblProductORCategoryItemsIncludedView: PNCDItemsIncludedInDiscountTableView!
    
    // Bottom Buttons
    @IBOutlet private weak var btnCancel: CustomButton!
    @IBOutlet private weak var btnSave: CustomButton!
    
    
    var viewModel : ViewModel!
    
    var isViewLoadedFlag : Bool = false
    var isExisitngPropertiesUpdatedOnUI : Bool = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if viewModel.editableDiscountItem != nil {
            
            if !isExisitngPropertiesUpdatedOnUI {
                updateUIWithExitingValues()
            }
            
        }else {
            updateUIWithDefaultInitialValues()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isViewLoadedFlag = true
    }
    
    private func configure() {
        vwNavigationHeader.delegate = self
        viewModel.flagsPropertyManager.delegate = self
        
    }
    
    private func updateUI(){
        setupUIForDiscountTextFields()

        segCtrlDiscountInputValueType.configure(
            with: viewModel.flagsPropertyManager.discountPerItemDiscountTypeSegments.compactMap({ $0.stringValue }),
            configuration: .default
        )
        
        configureScheduleType()
        
        dtPickerDealStartDate.configureView(pickerType: .date, delegate: self)
        dtPickerDealEndDate.configureView(pickerType: .date, delegate: self)
        
        vwWeeklySelectionView.configure(
            titleConfig: .init(title: "Repeat Weekly")
        )
        
        dtPickerDealStartTime.configureView(pickerType: .time, delegate: self)
        dtPickerDealEndTime.configureView(pickerType: .time, delegate: self)

        
        tblProductORCategoryItemsIncludedView.configure(with: [])
    }
    
    private func updateUIWithExitingValues(){
        guard let editableDiscountItem = viewModel.editableDiscountItem else { return }
        
        viewModel.configureInitialValuesFromExistingData()
        
        txtDiscountName.text = editableDiscountItem.discountName
        txtDiscountInputValueType.text = editableDiscountItem.discount ?? "0"
        
        
        txtDiscountInputValueType.text = DiscountPerItemDiscountTextFormatter.format(
            editableDiscountItem.discount ?? "",
            type: viewModel.flagsPropertyManager.discountInputValueType
        )
        
        dtPickerDealStartDate.setSelectedDate(
            date: editableDiscountItem.startDate,
            time: editableDiscountItem.startTime
        )
        
        dtPickerDealStartTime.setSelectedDate(
            date: editableDiscountItem.startDate,
            time: editableDiscountItem.startTime
        )
        
        dtPickerDealEndDate.setSelectedDate(
            date: editableDiscountItem.endDate,
            time: editableDiscountItem.endTime
        )
        
        dtPickerDealEndTime.setSelectedDate(
            date: editableDiscountItem.endDate,
            time: editableDiscountItem.endTime
        )
        
        // For inital UI update
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: { [weak self] in
            guard let self else { return }
            updateUIForDiscountTypeSelectionValueChange()
        })
        
        isExisitngPropertiesUpdatedOnUI = true
    }
    
    private func updateUIWithDefaultInitialValues(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: { [weak self] in
            guard let self else { return }
            updateUIForDiscountTypeSelectionValueChange()
        })
        
        updateUIForDiscountInputValueTypeChange()
        updateUIForScheduleTypeValueChange()
        
        viewModel.flagsPropertyManager.discountInputValueType = .amountValue
        swtAllowDiscountStackWithOtherDiscounts.updateIsOnFlag(true)
        swtDealHasNoEndDate.updateIsOnFlag(false)
        swtDealIsActiveForFullDay.updateIsOnFlag(false)
        
        viewModel.flagsPropertyManager.includedProductOrCategories.removeAll()
    }

    
    private func configureScheduleType(){
        var configuration : CustomSegmentedControl.Configuration = .default
        
        configuration.paddingBetweenThumbAndControl = 5
        
        configuration.control.font = FontFamily.ManropeMedium.size(15)
        configuration.control.textColor = .black
        configuration.control.bgColor = .white
        
        configuration.thumb.font = FontFamily.ManropeSemiBold.size(15)
        configuration.thumb.textColor = .white
        configuration.thumb.bgColor = .black
        
        segCtrlDiscountScheduleType.configure(
            with: viewModel.flagsPropertyManager.scheduleTypeSegments.map({ $0.stringValue }),
            configuration: configuration
        )
    }

    // MARK: - IBAction
    
    @IBAction private func onClickDiscountTypeSelection(_ sender : UIButton) {
        let discountType : PNCDType = (sender.tag == 0) ? .product : .category
        
        if viewModel.flagsPropertyManager.productOrCategoryDiscountType != discountType {
            viewModel.flagsPropertyManager.productOrCategoryDiscountType = discountType
        }
        updateUIForDiscountTypeSelectionValueChange()
        Logger.log(#function)
    }
    
    @IBAction private func didChangeValueOfAllowDiscountStackWithOtherDiscounts(_ sender: CustomSwitch) {
        viewModel.flagsPropertyManager.isAllowDiscountToStackWithOtherDiscounts = sender.isOn
        Logger.log(#function)
    }
    
    
    @IBAction private  func onClickChangeDiscountInputValueType(_ sender: CustomSegmentedControl) {
        if let tappedIndex = sender.tappedIndex {
            viewModel.flagsPropertyManager.discountInputValueType = DiscountInputValueType.getFromIndex(tappedIndex)
        }
        Logger.log(#function)
    }
    
    @IBAction private func onClickChangeScheduleType(_ sender: CustomSegmentedControl) {
        if let tappedIndex = sender.tappedIndex {
            viewModel.flagsPropertyManager.scheduleType = PNCDScheduleType.getFromIndex(tappedIndex)
        }
        Logger.log(#function)
    }
    
    @IBAction private func didChangeValueOfDealIsActiveForFullDay(_ sender: CustomSwitch) {
        viewModel.flagsPropertyManager.isDealIsActiveForFullDay = sender.isOn
        Logger.log(#function)
    }
    
    
    @IBAction private func onClickBtnAddProductAndCategory(_ sender: CustomButton) {
        ProductAndCategorySelectionVCFactory.make().push(
            in: navigationController,
            passData: { [weak self]  vc in
                guard let self else { return }
                vc.viewModel.discounttype = viewModel.flagsPropertyManager.productOrCategoryDiscountType 
                vc.delegate = self
                
            }, animated: false
        )
        
        Logger.log(#function)
    }
    
    
    // Bottom Actions
    @IBAction private func onClickBtnCancel(_ sender: CustomButton) {
        
        Logger.log(#function)
    }
    
    
    @IBAction private func onClickBtnSave(_ sender: CustomButton) {
        if btnSave.isLoading {
            btnSave.hideLoader()
        }else{
            btnSave.showLoader()
        }
        Logger.log(#function)
    }
    
    
}

extension CreateOREditPNCDVC : CustomNavigationHeaderViewDelegate{
    
    func onClickBack() {
        popVC()
    }
    
    func setHeaderTitle() -> String {
        "Product or Category Discount"
    }
    
}


extension CreateOREditPNCDVC {
    
    private func updateUIForDiscountTypeSelectionValueChange(){
        updateUIForPNCDSelectionType()
    }
}


extension CreateOREditPNCDVC {
    
    private func updateUIForScheduleTypeValueChange() {
        let isOneTime = viewModel.flagsPropertyManager.scheduleType == .oneTime
        
        vwWeeklySelectionView.isHidden = isOneTime
        swtDealIsActiveForFullDay.superview?.isHidden = isOneTime
        dtPickerDealStartTime.superview?.isHidden = isOneTime
        
        segCtrlDiscountScheduleType.select(
            index: viewModel.flagsPropertyManager.scheduleType.getIndex()
        )
        
    }
    
    
    private func updateUIForIncludedProductsOrCategories() {
        
        let isShowTblList = viewModel.flagsPropertyManager.includedProductOrCategories.isEmpty == false
        
        vwAddProductORCategoryBtnSuperView.isHidden = isShowTblList
        vwEditProductORCategorySuperView.isHidden = !isShowTblList
        tblProductORCategoryItemsIncludedView.reloadData(with: viewModel.flagsPropertyManager.includedProductOrCategories)
        
    }
    
}

extension CreateOREditPNCDVC : UITextFieldDelegate {
    
}

extension CreateOREditPNCDVC : DatePickerInputViewDelegate {
    
    func configureView(_ datePickerView: DatePickerInputView) -> DatePickerInputView.Configuration {
        return makeDatePickerConfiguration(
            datePickerView: datePickerView
        )
    }
    
    func onClickCancel(_ datePickerView : DatePickerInputView) {
        Logger.log(#function)
    }
    
    func onClickDone(_ datePickerView : DatePickerInputView, selectedDate: Date) {
        
        switch datePickerView {
            
        case dtPickerDealStartDate, dtPickerDealEndDate:
            Logger.log("Start/End Date : \(selectedDate)")
            
        case dtPickerDealStartTime, dtPickerDealEndTime:
            Logger.log("Start/End Time : \(selectedDate)")
            
        default: break
            
        }
        Logger.log(#function)
    }
    
}


extension CreateOREditPNCDVC : CreateOREditPNCDFlagsPropertyManagerDelegate {
    
    func didUpdateProductOrCategoryDiscountType() {
        updateUIForDiscountTypeSelectionValueChange()
    }
    
    func didUpdateIsAllowDiscountToStackWithOtherDiscounts() {
        
    }
    
    func didUpdateDiscountInputValueType() {
        updateUIForDiscountInputValueTypeChange()
    }
    
    
    func didUpdateScheduleType() {
        updateUIForScheduleTypeValueChange()
    }
    
    func didUpdatedSelectedWeekDates() {
        vwWeeklySelectionView.updateSelectedItemsDataSource(viewModel.flagsPropertyManager.selectedDates)
    }
    
    
    func didUpdateIsDealIsActiveForFullDay() {
        
    }
    
    func didUpdatedIncludedProductORCategories() {
        updateUIForIncludedProductsOrCategories()
    }
    
    
    func didUpdateIsThisDealHasNoEndDateFlag() {
        
    }
}


extension CreateOREditPNCDVC : ProductAndCategorySelectionVCProtocol {
    
    func didSelectVariants(_ variants: [VariantDataModel]) {
        viewModel.flagsPropertyManager.includedProductOrCategories = variants
    }
    
}

