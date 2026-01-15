//
//  GenericButton.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 07/01/26.
//


import UIKit

@IBDesignable
final class GenericButton: UIControl {

    // MARK: - Button Style

    enum AppButtonStyle: Int {
        case cancel = 0
        case save = 1
    }

    // MARK: - IBInspectable

    @IBInspectable
    var title: String = "" {
        didSet { titleLabel.text = title }
    }

    /// 0 = Cancel, 1 = Save
    @IBInspectable
    var buttonStyleRaw: Int = 0 {
        didSet {
            buttonStyle = AppButtonStyle(rawValue: buttonStyleRaw) ?? .cancel
        }
    }

    @IBInspectable
    var cornerRadius: CGFloat = 8 {
        didSet { layer.cornerRadius = cornerRadius }
    }
    
    @IBInspectable
    var bgColor: UIColor = ._0A64F9 {
        didSet{
            backgroundColor = bgColor
        }
    }

    /// Optional custom loader size (square)
    @IBInspectable
    var progressSize: CGFloat = 0 {
        didSet { updateProgressSize() }
    }
    
    // MARK: - Public Properties

    private(set) var buttonStyle: AppButtonStyle = .cancel {
        didSet { applyUIStyle() }
    }

    override var isEnabled: Bool {
        didSet { applyUIStyle() }
    }
    
    var isLoading : Bool {
        progressView.isAnimating
    }

    var titleFont : UIFont = FontFamily.ManropeRegular.size(15){
        didSet {
            titleLabel.font = titleFont
        }
    }
    
    // MARK: - UI Components

    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    private let progressView: ProgressView = {
        let progress = ProgressView(colors: [.white], lineWidth: 3)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()

    private var progressWidthConstraint: NSLayoutConstraint?
    private var progressHeightConstraint: NSLayoutConstraint?

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    // MARK: - Setup

    private func commonInit() {
        setupUI()
        applyUIStyle()
    }

    private func setupUI() {
        layer.cornerRadius = cornerRadius
        clipsToBounds = true

        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.isUserInteractionEnabled = false

        titleLabel.font = titleFont
        titleLabel.textAlignment = .center

        progressView.isHidden = true

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(progressView)

        addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        setupProgressConstraints()
    }

    private func setupProgressConstraints() {
        progressView.translatesAutoresizingMaskIntoConstraints = false

        progressWidthConstraint = progressView.widthAnchor.constraint(equalToConstant: 16)
        progressHeightConstraint = progressView.heightAnchor.constraint(equalToConstant: 16)

        progressWidthConstraint?.isActive = true
        progressHeightConstraint?.isActive = true
    }

    private func updateProgressSize() {
        let size = progressSize > 0 ? progressSize : 16
        progressWidthConstraint?.constant = size
        progressHeightConstraint?.constant = size
        layoutIfNeeded()
    }

    // MARK: - Styling

    private func applyUIStyle() {
        isUserInteractionEnabled = isEnabled
        
        switch buttonStyle {
        case .cancel:
            backgroundColor = .clear
            layer.borderWidth = 1
            layer.borderColor = UIColor.black.cgColor
            titleLabel.textColor = .black

        case .save:
            backgroundColor = isEnabled ? bgColor : ._818181
            layer.borderWidth = 0
            titleLabel.textColor = .white
        }
    }


    // MARK: - Loader Control

    func showLoader() {
        progressView.isHidden = false
        progressView.isAnimating = true
    }

    func hideLoader(animated: Bool = true) {
        self.progressView.isAnimating = false
        self.progressView.isHidden = true
        self.progressView.alpha = 1
    }
}
