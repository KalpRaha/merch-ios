//
//  DatePickerInputView.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 13/01/26.
//

import UIKit


protocol DatePickerInputViewDelegate : AnyObject {
    
    func configureView(_ datePickerView : DatePickerInputView) -> DatePickerInputView.Configuration
    
    func onClickCancel(_ datePickerView : DatePickerInputView)
    func onClickDone(_ datePickerView : DatePickerInputView, selectedDate: Date)
}

extension DatePickerInputView{
    
    enum PickerType {
        case date
        case time
    }
    
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
    private var pickerType: PickerType = .date
    

    // MARK: - UI Components

    private let lblTitle = UILabel()
    private let textFieldContainerView = UIView()

    // New: stack + icon
    private let hStack = UIStackView()
    private let textField = UITextField()
    private let iconImageView = UIImageView()

    private let datePicker = UIDatePicker()

    // Transparent overlay to expand tap area
    private let tapOverlayButton = UIButton(type: .custom)

    // Constraints for content inside its container (now applied to hStack)
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

    func configureView(
        pickerType : PickerType,
        delegate : DatePickerInputViewDelegate
    ) {
        self.delegate = delegate
        self.configuration = delegate.configureView(self)
        self.pickerType = pickerType
        
        buildView()
        updateUIForLatestConfiguration()
    }
    
    func updateUIForLatestConfiguration(){
        let config = self.configuration.titleTextConfiguration
        lblTitle.text = config.title
        lblTitle.textColor = config.textColor
        lblTitle.font = config.font
        
        updateConstraintsForInsets()
            
        self.configuration.containerViewConfig.apply(in: self)
        self.configuration.textFieldViewConfig.apply(in: self.textFieldContainerView)
        
        // Ensure picker reflects current mode and text shows correct formatting
        applyPickerType()
        configureIconForPickerType()
        if let selectedDate {
            updateTextField(with: clamp(selectedDate))
        } else {
            setDefaultPlaceholder()
        }
        
        setNeedsLayout()
        layoutSubviews()
    }

}

//MARK: - Build View

fileprivate extension DatePickerInputView {

    func buildView(){
        setupTitleLabel()
        setupTextFieldContainer()
        setupStackView()
        setupTextField()
        setupIconImageView()
        setupDatePicker()
        setupToolbar()
        setupTapOverlay()
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

    func setupStackView() {
        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.spacing = 5
        hStack.translatesAutoresizingMaskIntoConstraints = false

        textFieldContainerView.addSubview(hStack)

        let contentInsets = configuration.textFieldContentInset
        
        topConstraint = hStack.topAnchor.constraint(equalTo: textFieldContainerView.topAnchor, constant: contentInsets.top)
        leadingConstraint = hStack.leadingAnchor.constraint(equalTo: textFieldContainerView.leadingAnchor, constant: contentInsets.left)
        trailingConstraint = hStack.trailingAnchor.constraint(equalTo: textFieldContainerView.trailingAnchor, constant: -contentInsets.right)
        bottomConstraint = hStack.bottomAnchor.constraint(equalTo: textFieldContainerView.bottomAnchor, constant: -contentInsets.bottom)

        NSLayoutConstraint.activate([
            topConstraint,
            leadingConstraint,
            trailingConstraint,
            bottomConstraint
        ])
    }

    func setupTextField() {
        textField.tintColor = .clear
        textField.delegate = self
        setDefaultPlaceholder()
        textField.translatesAutoresizingMaskIntoConstraints = false

        // Ensure text field can compress before icon if space is tight
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        hStack.addArrangedSubview(textField)
    }
    
    func setupIconImageView() {
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.contentMode = .scaleAspectFit

        // Provide a sensible size for the icon
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24)
        ])

        // Icon should not stretch; keep it hugging
        iconImageView.setContentHuggingPriority(.required, for: .horizontal)
        iconImageView.setContentCompressionResistancePriority(.required, for: .horizontal)

        hStack.addArrangedSubview(iconImageView)
        configureIconForPickerType()
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
        applyPickerType()

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
    
    func applyPickerType() {
        switch pickerType {
        case .date:
            datePicker.datePickerMode = .date
        case .time:
            datePicker.datePickerMode = .time
            datePicker.locale = .enUSPosix
        }
    }
    
    func configureIconForPickerType() {
        // Replace with your asset names
        // e.g., UIImage(named: "date_picker") and UIImage(named: "time_picker")
        switch pickerType {
        case .date:
            iconImageView.image = .calenderIcon
        case .time:
            iconImageView.image = .clockIcon
        }
        // If assets aren’t available yet, you can set a system symbol as a fallback on iOS 13+
        if iconImageView.image == nil {
            if #available(iOS 13.0, *) {
                let name = (pickerType == .date) ? "calendar" : "clock"
                iconImageView.image = UIImage(systemName: name)
            }
        }
        iconImageView.tintColor = configuration.textFieldTextConfiguration.textColor
    }
    
    func setupTapOverlay() {
        // A transparent button that sits on top to handle taps anywhere in the view
        tapOverlayButton.translatesAutoresizingMaskIntoConstraints = false
        tapOverlayButton.backgroundColor = .clear
        // Ensure it does not show highlight
        tapOverlayButton.adjustsImageWhenHighlighted = false
        tapOverlayButton.addTarget(self, action: #selector(handleOverlayTap), for: .touchUpInside)
        
        addSubview(tapOverlayButton)
        // Bring to front so it captures touches
        bringSubviewToFront(tapOverlayButton)
        
        NSLayoutConstraint.activate([
            tapOverlayButton.topAnchor.constraint(equalTo: topAnchor),
            tapOverlayButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            tapOverlayButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            tapOverlayButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
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

        // Cancel | Done | flexible space
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
        delegate?.onClickCancel(self)
    }

    @objc func doneTapped() {
        let finalDate = clamp(datePicker.date)
        selectedDate = finalDate
        updateTextField(with: finalDate)
        textField.resignFirstResponder()
        delegate?.onClickDone(self, selectedDate: finalDate)
    }

    @objc func handleOverlayTap() {
        // Make the text field the first responder; caret color already clear
        textField.becomeFirstResponder()
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
        textField.text =
        switch pickerType {
        case .date: PNCDDateFormatter.shared.getStringToDisplay(date)
        case .time: PNCDTimeFormatter.shared.getStringToDisplay(date)
        }
    }

    
    func setDefaultPlaceholder() {
        textField.attributedPlaceholder = getAttributedPlaceholder(
            configuration.textFieldTextConfiguration.placeholderText
        )
    }

    func getAttributedPlaceholder(_ text: String) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: configuration.textFieldTextConfiguration.font,
            .foregroundColor: configuration.textFieldTextConfiguration.textColor
        ]
        return NSAttributedString(
            string: text,
            attributes: attributes
        )
    }

}

extension DatePickerInputView {
    
    func setSelectedDate(
        date : String?,
        time: String?,
        timeZone: TimeZone = .current,
        locale: Locale = .current
    ) {
        
        // Use local calendar and time zone (device's current time zone)
        let calendar = Calendar.current

        guard
            let date = PNCDDateFormatter.shared.parseFromAPI(date),
            let timeDate = PNCDTimeFormatter.shared.parseFromAPI(time)
        else {
            selectedDate = nil
            return
        }
        
        // Extract date components (year, month, day)
        var components = calendar.dateComponents([.year, .month, .day], from: date)
        
        // Extract time components (hour, minute, second)
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: timeDate)
        
        // Combine them
        components.hour = timeComponents.hour
        components.minute = timeComponents.minute
        components.second = timeComponents.second
        
        // Create the final Date in local time zone
        guard let combinedDate = calendar.date(from: components) else { return }
        print("Combined Date: \(combinedDate)")  // For debugging: e.g., "Jan 22, 2026 at 10:30:00 AM"
        
        self.selectedDate = combinedDate
        printDate(date: combinedDate, timeZone: timeZone, locale: locale)
    }
    
    
    private func printDate(
        date: Date,
        timeZone: TimeZone,
        locale: Locale
    ) {
        let displayFormatter = DateFormatter()
        displayFormatter.dateStyle = .medium
        displayFormatter.timeStyle = .medium
        displayFormatter.timeZone = timeZone
        displayFormatter.locale = locale
        
        Logger.log("✅ Local: \(displayFormatter.string(from: date ))")
        Logger.log("📊 UTC: \(date)")
    }
}

extension DatePickerInputView: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {

    }

}
