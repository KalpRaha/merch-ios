//
//  DatePickerInputView.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 13/01/26.
//

import UIKit


protocol DatePickerInputViewDelegate : AnyObject {
    
    func configureView(_ datePickerView : DatePickerInputView) -> DatePickerInputView.Configuration
    
    func onClickCancel()
    func onClickDone(_ selectedDate: Date)
}


final class DatePickerInputView: UIView {

    
    weak var delegate: DatePickerInputViewDelegate?

    var minimumDate: Date? {
        didSet { datePicker.minimumDate = minimumDate }
    }

    var maximumDate: Date? {
        didSet { datePicker.maximumDate = maximumDate }
    }

    /// Pre-filled date (will be clamped within min/max)
    var selectedDate: Date? {
        didSet { applySelectedDate() }
    }
    
    var configuration: Configuration!
    

    // MARK: - UI Components

    private let lblTitle = UILabel()
    private let textFieldContainerView = UIView()

    private let textField = UITextField()
    private let datePicker = UIDatePicker()

    // Constraints for textField inside its container
    private var topConstraint: NSLayoutConstraint!
    private var leadingConstraint: NSLayoutConstraint!
    private var trailingConstraint: NSLayoutConstraint!
    private var bottomConstraint: NSLayoutConstraint!

    // Constraints for label-container spacing
    private var titleToContainerConstraint: NSLayoutConstraint?

    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    
    func configureView(delegate : DatePickerInputViewDelegate) {
        self.delegate = delegate
        self.configuration = delegate.configureView(self)
        
        buildView()
        updateUIForLatestConfiguration()
    }
    
    func updateUIForLatestConfiguration(){
        lblTitle.text = self.configuration.titleText
        lblTitle.textColor = self.configuration.titleTextColor
        lblTitle.font = self.configuration.titleTextFont
        
        updateConstraintsForInsets()
            
        self.configuration.containerViewConfig.apply(in: self)
        self.configuration.textFieldViewConfig.apply(in: self.textFieldContainerView)
        
        setNeedsLayout()
        layoutSubviews()
    }

}

//MARK: - Build View

fileprivate extension DatePickerInputView {

    func buildView(){
        setupTitleLabel()
        setupTextFieldContainer()
        setupTextField()
        setupDatePicker()
        setupToolbar()
    }
    
    func setupTitleLabel() {
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        lblTitle.numberOfLines = 1
        lblTitle.textAlignment = .left

        addSubview(lblTitle)

        NSLayoutConstraint.activate([
            lblTitle.topAnchor.constraint(equalTo: topAnchor),
            lblTitle.leadingAnchor.constraint(equalTo: leadingAnchor),
            lblTitle.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    func setupTextFieldContainer() {
        textFieldContainerView.translatesAutoresizingMaskIntoConstraints = false
        textFieldContainerView.backgroundColor = .clear
        addSubview(textFieldContainerView)

        let topSpacing = textFieldContainerView.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: configuration.titleBottomPadding)
        titleToContainerConstraint = topSpacing

        NSLayoutConstraint.activate([
            topSpacing,
            textFieldContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            textFieldContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            textFieldContainerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func setupTextField() {
        textField.delegate = self
        setDefaultPlaceholder()
        textField.translatesAutoresizingMaskIntoConstraints = false

        textFieldContainerView.addSubview(textField)
        let contentInsets = configuration.textFieldContentInset
        
        topConstraint = textField.topAnchor.constraint(equalTo: textFieldContainerView.topAnchor, constant: contentInsets.top)
        leadingConstraint = textField.leadingAnchor.constraint(equalTo: textFieldContainerView.leadingAnchor, constant: contentInsets.left)
        trailingConstraint = textField.trailingAnchor.constraint(equalTo: textFieldContainerView.trailingAnchor, constant: -contentInsets.right)
        bottomConstraint = textField.bottomAnchor.constraint(equalTo: textFieldContainerView.bottomAnchor, constant: -contentInsets.bottom)

        NSLayoutConstraint.activate([
            topConstraint,
            leadingConstraint,
            trailingConstraint,
            bottomConstraint
        ])
    }
    
    func updateConstraintsForInsets() {
        let contentInsets = configuration.textFieldContentInset
        
        topConstraint.constant = contentInsets.top
        leadingConstraint.constant = contentInsets.left
        trailingConstraint.constant = -contentInsets.right
        bottomConstraint.constant = -contentInsets.bottom
        
        layoutIfNeeded()
    }

    func setupDatePicker() {
        datePicker.datePickerMode = .date

        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }

        datePicker.addTarget(
            self,
            action: #selector(dateChanged(_:)),
            for: .valueChanged
        )

        textField.inputView = datePicker
    }
    
}

fileprivate extension DatePickerInputView {
    
    func setupToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let cancel = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(cancelTapped)
        )

        let done = UIBarButtonItem(
            title: "Done",
            style: .done,
            target: self,
            action: #selector(doneTapped)
        )

        let spacer = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )

        toolbar.setItems([cancel, done, spacer], animated: false)
        textField.inputAccessoryView = toolbar
    }
    
    // MARK: - Actions
    @objc func dateChanged(_ sender: UIDatePicker) {
        let clamped = clamp(sender.date)
        sender.date = clamped
        updateTextField(with: clamped)
    }

    @objc func cancelTapped() {
        if let selectedDate {
            updateTextField(with: selectedDate)
        } else {
            setDefaultPlaceholder()
        }

        textField.resignFirstResponder()
        delegate?.onClickCancel()
    }

    @objc func doneTapped() {
        let finalDate = clamp(datePicker.date)
        selectedDate = finalDate
        updateTextField(with: finalDate)
        textField.resignFirstResponder()
        delegate?.onClickDone(finalDate)
    }

      
}

fileprivate extension DatePickerInputView {

    func applySelectedDate() {
        guard let date = selectedDate else { return }

        let clampedDate = clamp(date)
        datePicker.date = clampedDate
        updateTextField(with: clampedDate)
    }

    func clamp(_ date: Date) -> Date {
        if let min = minimumDate, date < min { return min }
        if let max = maximumDate, date > max { return max }
        return date
    }

    func updateTextField(with date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        textField.text = formatter.string(from: date)
    }

    
    func setDefaultPlaceholder() {
        textField.attributedPlaceholder = getAttributedPlaceholder("DD/MM/YYYY")
    }

    func getAttributedPlaceholder(_ text: String) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: FontFamily.ManropeMedium.size(14),
            .foregroundColor: UIColor._878787
        ]
        return NSAttributedString(
            string: text,
            attributes: attributes
        )
    }

}

extension DatePickerInputView: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {

    }

}
