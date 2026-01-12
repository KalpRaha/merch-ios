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
    
    
    @IBOutlet private weak var lblDiscountName: UILabel!
    @IBOutlet private weak var txtDiscountName: UITextField!
    
    @IBOutlet private weak var lblDiscountPerItem: UILabel!
    @IBOutlet private weak var txtDiscountPerItem: UITextField!
    
    
    @IBOutlet private weak var segCtrlDiscountPerItemDiscountType : GenericSegmentedControl!
    
    @IBOutlet private weak var segCtrlDiscountScheduleType : GenericSegmentedControl!
    
    @IBOutlet private weak var swtDealHasNoEndDate: CustomSwitch!
    
    @IBOutlet private weak var txtDealStartDate: UITextField!
    @IBOutlet private weak var txtDealEndDate: UITextField!
    
    
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: { [weak self] in
            guard let self else { return }
            updateUIForDiscountTypeSelectionValueChange()
        })
        
        updateUIForDiscountPerItemDiscountTypeValueChange()
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
        
        txtDealStartDate.superview?.addTapGesture(action: { [weak self] gesture in
            guard let self else { return }
            
            let helper = DatePickerHelper()
            helper.openDatePicker(forTextField: txtDealStartDate)
            
            Logger.log("Start Date Pressed :")
        })
        
        
        txtDealEndDate.superview?.addTapGesture(action: { [weak self] gesture in
            guard let self else { return }
            
            let helper = DatePickerHelper()
            
            helper.openDatePicker(forTextField: txtDealEndDate)
            Logger.log("End Date Pressed :")
        })
        
        
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

extension CreateProductAndCategoryDiscountVC : UITextFieldDelegate{
    
    
    
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
        
    }
    
}



class DatePickerHelper {
    
    var onClickCancel: (() -> Void)?
    var onClickDone: ((Date) -> Void)?
    
    private var datePicker: UIDatePicker = {
        UIDatePicker()
    }()
    
    
    func openDatePicker(
        forTextField textField: UITextField,
        existingDate: Date? = nil
    ) {
        guard let activeVC = NavigationCoordinator.shared.window?.rootViewController else { return }
        datePicker.datePickerMode = .date
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        textField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(onClickDatePickerHandler(_:)), for: .valueChanged)
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: activeVC.view.frame.width, height: 40))
        toolbar.barStyle = .default
        
        let cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(onClickBtnDone(_:)))
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(onClickBtnDone(_:)))
        
        let flexibleBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([cancelBtn, doneBtn, flexibleBtn], animated: false)
        textField.inputAccessoryView = toolbar
        
    }
    
    @objc func onClickDatePickerHandler(_ sender : UIPickerView) {
        
        Logger.log(#function)
    }
    
    @objc func onClickBtnCancel(_ sender : UIPickerView) {
        onClickCancel?()
        Logger.log(#function)
    }
    
    @objc func onClickBtnDone(_ sender : UIPickerView) {
        onClickDone?(datePicker.date)
        Logger.log(#function)
    }
    
}
