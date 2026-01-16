//
//  CreateProductAndCategoryDiscountVC.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 07/01/26.
//

import UIKit


class CreateProductAndCategoryDiscountVCFactory {
    
    static func make() -> CreateProductAndCategoryDiscountVC {
    
        let vc = CreateProductAndCategoryDiscountVC.instantiate()
        vc.viewModel = CreateProductAndCategoryDiscountVC.ViewModel()
        vc.viewModel?.delegate = vc
        
        return vc
    }
}


final class CreateProductAndCategoryDiscountVC: UIViewController, Navigatable {

    static var storyboard: UIStoryboard { .productAndCategoryDiscount }
    
    
    @IBOutlet private weak var vwNavigationHeader: CustomNavigationHeaderView!
    
    
    // Discount Type Selection View
    @IBOutlet private weak var vwProductDiscountTypeSelectionView: UIView!
    @IBOutlet private weak var lblProductDiscountTypeSelectionViewTitle: UILabel!
    @IBOutlet private weak var lblProductDiscountTypeSelectionViewSubTitle: UILabel!
    
    @IBOutlet private weak var vwCategoryDiscountTypeSelectionView: UIView!
    @IBOutlet private weak var lblCategoryDiscountTypeSelectionViewTitle: UILabel!
    @IBOutlet private weak var lblCategoryDiscountTypeSelectionViewSubTitle: UILabel!

    
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
    @IBOutlet private weak var dtPickerDealStartDate: DatePickerInputView!
    @IBOutlet private weak var dtPickerDealEndDate: DatePickerInputView!
    
    // Weekly date picker
    @IBOutlet private weak var vwWeeklySelectionView : WeeklySelectionView!
    
    // Deal is active for full day
    @IBOutlet private weak var swtDealIsActiveForFullDay : CustomSwitch!
    
    // Time picker
    @IBOutlet private weak var dtPickerDealStartTime: DatePickerInputView!
    @IBOutlet private weak var dtPickerDealEndTime: DatePickerInputView!
    
    // Add Product OR Category Button
    @IBOutlet private weak var vwAddProductORCategoryBtnSuperView: UIView!
    @IBOutlet private weak var lblAddProductORCategoryBtn: UILabel!
    @IBOutlet private weak var btnAddProductORCategory: GenericButton!
    
    
    // Edit Products or categories inlcuded in this Discount
    @IBOutlet private weak var vwEditProductORCategorySuperView: UIView!
    @IBOutlet private weak var vwEditProductORCategoryBtnSuperView: UIView!
    @IBOutlet private weak var lblEditProductORCategoryBtn: UILabel!
    
    @IBOutlet private weak var tblProductORCategoryItemsIncludedView: ProductAndCategoryItemsIncludedInDiscountTableView!
    
    // Bottom Buttons
    @IBOutlet private weak var btnCancel: GenericButton!
    @IBOutlet private weak var btnSave: GenericButton!
    
    
    var viewModel : ViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateInitialUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    private func updateUI(){
        vwNavigationHeader.delegate = self
        setupUIForDiscountTextFields()
        
        segCtrlDiscountPerItemDiscountType.configure(
            with: viewModel.discountPerItemDiscountTypeSegments.compactMap({ $0.stringValue }),
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
    
    private func updateInitialUI(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: { [weak self] in
            guard let self else { return }
            updateUIForDiscountTypeSelectionValueChange()
        })
        
        updateUIForDiscountPerItemDiscountTypeValueChange()
        updateUIForScheduleTypeValueChange()
        
        viewModel.discountPerItemDiscountType = .amountValue
        swtAllowDiscountStackWithOtherDiscounts.isOn = true
        swtDealHasNoEndDate.isOn = false
        swtDealIsActiveForFullDay.isOn = false
        
        viewModel.includedProductOrCategories.removeAll()
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
            with: viewModel.scheduleTypeSegments.map({ $0.stringValue }),
            configuration: configuration
        )
    }

    // MARK: - IBAction
    
    @IBAction private func onClickDiscountTypeSelection(_ sender : UIButton) {
        let discountType : ProductAndCategoryDiscountType = (sender.tag == 0) ? .product : .category
        
        if self.viewModel.productOrCategoryDiscountType != discountType {
            self.viewModel.productOrCategoryDiscountType = discountType
        }
        updateUIForDiscountTypeSelectionValueChange()
        Logger.log(#function)
    }
    
    @IBAction func didChangeValueOfAllowDiscountStackWithOtherDiscounts(_ sender: CustomSwitch) {
        viewModel.isAllowDiscountToStackWithOtherDiscounts = sender.isOn
        Logger.log(#function)
    }
    
    
    @IBAction func didChangeValueOfDiscountPerItemDiscountType(_ sender: GenericSegmentedControl) {
        let discountType : DiscountPerItemDiscountType = (sender.selectedIndex == 0) ? .amountValue : .percentValue
        
        if viewModel.discountPerItemDiscountType != discountType {
            viewModel.discountPerItemDiscountType = discountType
        }
        Logger.log(#function)
    }
    
    
    @IBAction func didChangeValueOfScheduleType(_ sender: GenericSegmentedControl) {
        let scheduleType : ScheduleType = (sender.selectedIndex == 0) ? .oneTime : .repeatsOnSchedule
        
        if viewModel.scheduleType != scheduleType {
            viewModel.scheduleType = scheduleType
        }
         
        Logger.log(#function)
    }
    

    @IBAction func didChangeValueOfDealIsActiveForFullDay(_ sender: CustomSwitch) {
        viewModel.isDealIsActiveForFullDay = sender.isOn
        Logger.log(#function)
    }
    
    
    @IBAction func onClickBtnAddProductAndCategory(_ sender: GenericButton) {
        ProductAndCategorySelectionVCFactory.make().push(in: navigationController, animated: false)
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
        let isProduct = viewModel.productOrCategoryDiscountType == .product
        
        // Product View UI Update
        vwProductDiscountTypeSelectionView.applyBorder(
            borderWidth: 1,
            borderColor: isProduct ? ._0A64F9 : .E4E4E4,
            borderOpacity: 1
        )
        vwProductDiscountTypeSelectionView.applyShadow(
            shadowColor: isProduct ? ._0A64F9 : .clear,
            shadowOpacity: isProduct ? 0.25 : 0,
            shadowXOffset: 0,
            shadowYOffset: 7,
            shadowBlur: isProduct ? 18 : 0,
            shadowSpread: 0
            
        )
        
        lblProductDiscountTypeSelectionViewTitle.textColor = isProduct ? ._0A64F9 : ._636363
        lblProductDiscountTypeSelectionViewSubTitle.textColor = isProduct ? .black : ._8F8F8F
        
        // Category View UI Update
        vwCategoryDiscountTypeSelectionView.applyBorder(
            borderWidth: 1,
            borderColor: !isProduct ? ._0A64F9 : .E4E4E4,
            borderOpacity: 1
        )
        vwCategoryDiscountTypeSelectionView.applyShadow(
            shadowColor: !isProduct ? ._0A64F9 : .clear,
            shadowOpacity: !isProduct ? 0.25 : 0,
            shadowXOffset: 0,
            shadowYOffset: 7,
            shadowBlur: !isProduct ? 18 : 0,
            shadowSpread: 0
        )
        
        lblCategoryDiscountTypeSelectionViewTitle.textColor = !isProduct ? ._0A64F9 : ._636363
        lblCategoryDiscountTypeSelectionViewSubTitle.textColor = !isProduct ? .black : ._8F8F8F
        
        lblAddProductORCategoryBtn.text = isProduct ? "Products Included In Offer" : "Categories Included In This Discount"
        btnAddProductORCategory.title = isProduct ? "Add products to discount" : "Add Categories to discount"
        
        lblEditProductORCategoryBtn.text = isProduct ? "Products Included In This Discount" : "Categories Included In This Discount"
    }
}


extension CreateProductAndCategoryDiscountVC {
    
    @objc func updateTextField(textField: UITextField) {
        textField.text = DiscountPerItemDiscountTextFormatter.format(
            textField.text ?? "",
            type: viewModel.discountPerItemDiscountType
        )
        
    }
    
    private func updateUIForDiscountPerItemDiscountTypeValueChange(){
        let isPercent = viewModel.discountPerItemDiscountType == .percentValue
        
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
        let isOneTime = viewModel.scheduleType == .oneTime
        
        vwWeeklySelectionView.isHidden = isOneTime
        swtDealIsActiveForFullDay.superview?.isHidden = isOneTime
        dtPickerDealStartTime.superview?.isHidden = isOneTime
    }
    
    
    private func updateUIForIncludedProductsOrCategories() {
        let isShowTblList = viewModel.includedProductOrCategories.isEmpty == false
        
        vwAddProductORCategoryBtnSuperView.isHidden = isShowTblList
        vwEditProductORCategorySuperView.isHidden = !isShowTblList
        
        
    }
    
}

extension CreateProductAndCategoryDiscountVC : UITextFieldDelegate {
    
}

extension CreateProductAndCategoryDiscountVC : DatePickerInputViewDelegate {
    
    func configureView(_ datePickerView: DatePickerInputView) -> DatePickerInputView.Configuration {
        
        var configuration = DatePickerInputView.Configuration.init(
            titleTextConfiguration: .init(title: "Start Date"),
            textFieldTextConfiguration: .init(
                placeholderText: "DD/MM/YYYY",
                textColor: UIColor._878787
            ),
            txtViewConfig: .init(
                borderColor: .E4E8EF,
                borderWidth: 1,
                borderOpacity: 1,
                cornerRadius: 8
            )
        )
        
        let dtPlaceholder = "DD/MM/YYYY"
        let timePlaceholder = "HH:MM"
        
        switch datePickerView {
           
       case dtPickerDealStartDate:
            configuration.titleTextConfiguration.title = "Start Date"
            configuration.textFieldTextConfiguration.placeholderText = dtPlaceholder
            
       case dtPickerDealEndDate:
            configuration.titleTextConfiguration.title = "End Date"
            configuration.textFieldTextConfiguration.placeholderText = dtPlaceholder
            
       case dtPickerDealStartTime:
            configuration.titleTextConfiguration.title = "Start Time"
            configuration.textFieldTextConfiguration.placeholderText = timePlaceholder
            
       case dtPickerDealEndTime:
            configuration.titleTextConfiguration.title = "End Time"
            configuration.textFieldTextConfiguration.placeholderText = timePlaceholder
            
       default:
            configuration.titleTextConfiguration.title = "Date or Time"
            configuration.textFieldTextConfiguration.placeholderText = "Select"
            
       }
    
        return configuration
    }
    
    func onClickCancel() {
        Logger.log(#function)
    }
    
    func onClickDone(_ selectedDate: Date) {
        Logger.log(#function)
    }
    
}


extension CreateProductAndCategoryDiscountVC : CreateProductAndCategoryDiscountVMDelegate {
    
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
    
}
