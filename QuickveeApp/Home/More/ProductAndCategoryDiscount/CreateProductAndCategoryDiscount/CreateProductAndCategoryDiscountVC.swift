//
//  CreateProductAndCategoryDiscountVC.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 07/01/26.
//

import UIKit

typealias CreatePNCDVC = CreateProductAndCategoryDiscountVC

class CreateProductAndCategoryDiscountVCFactory {
    
    static func make(
        discountItem : PNCDDiscountListItem? = nil
        
    ) -> CreateProductAndCategoryDiscountVC {
    
        let vc = CreateProductAndCategoryDiscountVC.instantiate()
        
        vc.viewModel = CreateProductAndCategoryDiscountVC.ViewModel(
            editableDiscountItem: discountItem,
            builder: .init(merchantId: UDHelper.shared.merchantId)
        )
        
        vc.discountTypeSwitchUIUpdateHelper = .init()
        vc.datePickerInputViewConfigurationBuilder = .init()
        
        return vc
    }
}


final class CreateProductAndCategoryDiscountVC: UIViewController, Navigatable {

    static var storyboard: UIStoryboard { .productAndCategoryDiscount }
    
    
    @IBOutlet private weak var vwNavigationHeader: CustomNavigationHeaderView!
    
    
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
    @IBOutlet private weak var lblDiscountName: UILabel!
    @IBOutlet private weak var txtDiscountName: UITextField!
    
    @IBOutlet private weak var lblDiscountPerItem: UILabel!
    @IBOutlet private weak var txtDiscountPerItem: UITextField!
    
    
    @IBOutlet private weak var segCtrlDiscountPerItemDiscountType : GenericSegmentedControl!
    @IBOutlet private weak var segCtrlDiscountScheduleType : GenericSegmentedControl!
    @IBOutlet private weak var swtDealHasNoEndDate: CustomSwitch!
    
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
    @IBOutlet weak var btnAddProductORCategory: GenericButton!
    
    
    // Edit Products or categories inlcuded in this Discount
    @IBOutlet private weak var vwEditProductORCategorySuperView: UIView!
    @IBOutlet private weak var vwEditProductORCategoryBtnSuperView: UIView!
    @IBOutlet weak var lblEditProductORCategoryBtn: UILabel!
    
    @IBOutlet private weak var tblProductORCategoryItemsIncludedView: ProductAndCategoryItemsIncludedInDiscountTableView!
    
    // Bottom Buttons
    @IBOutlet private weak var btnCancel: GenericButton!
    @IBOutlet private weak var btnSave: GenericButton!
    
    
    var viewModel : ViewModel!
    
    var isViewLoadedFlag : Bool = false
    
    // Helper to manage type switch UI
    var discountTypeSwitchUIUpdateHelper: CreatePNCDTypeSwitchUIHelper!
    var datePickerInputViewConfigurationBuilder: CreatePNCDVCDatePickerConfigurationBuilder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !isViewLoadedFlag && viewModel.editableDiscountItem != nil{
            configureInitialValues()
        }else {
            updateInitialUI()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isViewLoadedFlag = true
    }
    
    private func configure() {
        discountTypeSwitchUIUpdateHelper.vc = self
        datePickerInputViewConfigurationBuilder.vc = self
        
        viewModel.flagsPropertyManager.delegate = self
        viewModel.dateNTimeHelper.timeUIUpdateDelegate = self
        
        
    }
    
    private func updateUI(){
        vwNavigationHeader.delegate = self
        setupUIForDiscountTextFields()

        segCtrlDiscountPerItemDiscountType.configure(
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
    
    private func configureInitialValues(){
        guard let editableDiscountItem = viewModel.editableDiscountItem else { return }
        
        txtDiscountName.text = editableDiscountItem.discountName
        txtDiscountPerItem.text = editableDiscountItem.discount ?? "0"
        
        viewModel.configureInitialValuesFromExistingData()
    }
    
    private func updateInitialUI(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: { [weak self] in
            guard let self else { return }
            updateUIForDiscountTypeSelectionValueChange()
        })
        
        updateUIForDiscountPerItemDiscountTypeValueChange()
        updateUIForScheduleTypeValueChange()
        
        viewModel.flagsPropertyManager.discountPerItemDiscountType = .amountValue
        swtAllowDiscountStackWithOtherDiscounts.isOn = true
        swtDealHasNoEndDate.isOn = false
        swtDealIsActiveForFullDay.isOn = false
        
        viewModel.flagsPropertyManager.includedProductOrCategories.removeAll()
    }
    
    private func setupUIForDiscountTextFields(){
        // Discount Name
        txtDiscountName.attributedPlaceholder = getAttributedPlaceHolderText(for: "Enter Discount Name")
        
        txtDiscountName.delegate = self
        txtDiscountName.borderStyle = .none
        txtDiscountName.returnKeyType = .next
        txtDiscountName.superview?.applyBorder(
            borderWidth: 1,
            borderColor: .E4E8EF,
            borderOpacity: 1
        )
        txtDiscountName.superview?.applyCornerRadius(cornerRadius: 8)
        
        // Discount Per Item
        txtDiscountPerItem.attributedPlaceholder = getAttributedPlaceHolderText(for: "$0.00")
        txtDiscountPerItem.borderStyle = .none
        txtDiscountPerItem.superview?.applyBorder(
            borderWidth: 1,
            borderColor: .E4E8EF,
            borderOpacity: 1
        )
        txtDiscountPerItem.superview?.applyCornerRadius(cornerRadius: 8)
        
        txtDiscountPerItem.keyboardType = .numberPad
        txtDiscountPerItem.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
    }

    
    private func configureScheduleType(){
        var configuration : GenericSegmentedControl.Configuration = .default
        
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
        let discountType : ProductAndCategoryDiscountType = (sender.tag == 0) ? .product : .category
        
        if viewModel.flagsPropertyManager.productOrCategoryDiscountType != discountType {
            viewModel.flagsPropertyManager.productOrCategoryDiscountType = discountType
        }
        updateUIForDiscountTypeSelectionValueChange()
        Logger.log(#function)
    }
    
    @IBAction func didChangeValueOfAllowDiscountStackWithOtherDiscounts(_ sender: CustomSwitch) {
        viewModel.flagsPropertyManager.isAllowDiscountToStackWithOtherDiscounts = sender.isOn
        Logger.log(#function)
    }
    
    
    @IBAction func didChangeValueOfDiscountPerItemDiscountType(_ sender: GenericSegmentedControl) {
        let discountType : DiscountPerItemDiscountType = (sender.selectedIndex == 0) ? .amountValue : .percentValue
        
        if viewModel.flagsPropertyManager.discountPerItemDiscountType != discountType {
            viewModel.flagsPropertyManager.discountPerItemDiscountType = discountType
        }
        Logger.log(#function)
    }
    
    
    @IBAction func didChangeValueOfScheduleType(_ sender: GenericSegmentedControl) {
        let scheduleType : ScheduleType = (sender.selectedIndex == 0) ? .oneTime : .repeatsOnSchedule
        
        if viewModel.flagsPropertyManager.scheduleType != scheduleType {
            viewModel.flagsPropertyManager.scheduleType = scheduleType
        }
         
        Logger.log(#function)
    }
    

    @IBAction func didChangeValueOfDealIsActiveForFullDay(_ sender: CustomSwitch) {
        viewModel.flagsPropertyManager.isDealIsActiveForFullDay = sender.isOn
        Logger.log(#function)
    }
    
    
    @IBAction func onClickBtnAddProductAndCategory(_ sender: GenericButton) {
        ProductAndCategorySelectionVCFactory.make().push(in: navigationController, passData: { [weak self]  vc in
            guard let self else { return }
            vc.delegate = self
        }, animated: false)
        Logger.log(#function)
    }
    
    @IBAction private func onClickBtnCancel(_ sender: GenericButton) {
        
        Logger.log(#function)
    }
    
    
    @IBAction private func onClickBtnSave(_ sender: GenericButton) {
        if btnSave.isLoading {
            btnSave.hideLoader()
        }else{
            btnSave.showLoader()
        }
        Logger.log(#function)
    }
    
    
}

extension CreateProductAndCategoryDiscountVC : CustomNavigationHeaderViewDelegate{
    
    func onClickBack() {
        popVC()
    }
    
    func setHeaderTitle() -> String {
        "Product or Category Discount"
    }
    
}


extension CreateProductAndCategoryDiscountVC {
    
    private func updateUIForDiscountTypeSelectionValueChange(){
        discountTypeSwitchUIUpdateHelper.update(
            for: viewModel.flagsPropertyManager.productOrCategoryDiscountType
        )
    }
}


extension CreateProductAndCategoryDiscountVC {
    
    @objc func updateTextField(textField: UITextField) {
        textField.text = DiscountPerItemDiscountTextFormatter.format(
            textField.text ?? "",
            type: viewModel.flagsPropertyManager.discountPerItemDiscountType
        )
        
    }
    
    private func updateUIForDiscountPerItemDiscountTypeValueChange(){
        let isPercent = viewModel.flagsPropertyManager.discountPerItemDiscountType == .percentValue
        
        lblDiscountPerItem.text = isPercent ? "Discount per item (%)" : "Discount per item ($)"
        txtDiscountPerItem.text = nil
        txtDiscountPerItem.attributedPlaceholder = getAttributedPlaceHolderText(for: isPercent ? "0.00%" : "$0.00")
        
    }
    
    private func getAttributedPlaceHolderText(for text: String) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: FontFamily.ManropeMedium.size(14),
            .foregroundColor: UIColor._878787
        ]
        
        return NSAttributedString(string: text, attributes: attributes)
    }
}

extension CreateProductAndCategoryDiscountVC {
    
    private func updateUIForScheduleTypeValueChange() {
        let isOneTime = viewModel.flagsPropertyManager.scheduleType == .oneTime
        
        vwWeeklySelectionView.isHidden = isOneTime
        swtDealIsActiveForFullDay.superview?.isHidden = isOneTime
        dtPickerDealStartTime.superview?.isHidden = isOneTime
    }
    
    
    private func updateUIForIncludedProductsOrCategories() {
        
        let isShowTblList = viewModel.flagsPropertyManager.includedProductOrCategories.isEmpty == false
        
        vwAddProductORCategoryBtnSuperView.isHidden = isShowTblList
        vwEditProductORCategorySuperView.isHidden = !isShowTblList
        tblProductORCategoryItemsIncludedView.reloadData(with: viewModel.flagsPropertyManager.includedProductOrCategories)
        
    }
    
}

extension CreateProductAndCategoryDiscountVC : UITextFieldDelegate {
    
}

extension CreateProductAndCategoryDiscountVC : DatePickerInputViewDelegate {
    
    func configureView(_ datePickerView: DatePickerInputView) -> DatePickerInputView.Configuration {
        return datePickerInputViewConfigurationBuilder.make(
            datePickerView: datePickerView
        )
    }
    
    func onClickCancel() {
        Logger.log(#function)
    }
    
    func onClickDone(_ selectedDate: Date) {
        Logger.log(#function)
    }
    
}


extension CreateProductAndCategoryDiscountVC : CreatePNCDFlgsPropertyManagerDelegate {
    
    func didUpdateProductOrCategoryDiscountType() {
        updateUIForDiscountTypeSelectionValueChange()
    }
    
    func didUpdateIsAllowDiscountToStackWithOtherDiscounts() {

    }
    
    func didUpdateDiscountPerItemDiscountType() {
        updateUIForDiscountPerItemDiscountTypeValueChange()
    }
    
    
    func didUpdateScheduleType() {
        updateUIForScheduleTypeValueChange()
    }
    
    func didUpdateIsDealIsActiveForFullDay() {
        
    }
    
    func didUpdatedIncludedProductORCategories() {
        updateUIForIncludedProductsOrCategories()
    }
    
    
    func didUpdateIsThisDealHasNoEndDateFlag() {
        
    }
}

extension CreateProductAndCategoryDiscountVC : CreatePNCDDateAndTimeUIUpdateDelegate {
    
    func didUpdatedStartDate() {
        dtPickerDealStartDate.selectedDate = viewModel.dateNTimeHelper.startDate ?? .now()
    }
    
    func didUpdatedEndDate() {
        dtPickerDealEndDate.selectedDate = viewModel.dateNTimeHelper.endDate ?? .now()
    }
    
    func didUpdatedStartTime() {
        dtPickerDealStartTime.selectedDate = viewModel.dateNTimeHelper.startTime ?? .now()
    }
    
    func didUpdatedEndTime() {
        dtPickerDealStartTime.selectedDate = viewModel.dateNTimeHelper.endTime ?? .now()
    }
    
}

extension CreateProductAndCategoryDiscountVC : ProductAndCategorySelectionVCProtocol {
    func didSelectVariants(_ variants: [VariantDataModel]) {
        print(variants)
        viewModel.flagsPropertyManager.includedProductOrCategories = variants
       
    }
    
}
