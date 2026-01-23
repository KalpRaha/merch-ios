//
//  AddItemButton.swift
//  QuickveeApp
//
//  Created by Your Name on 23/01/26.
//

import UIKit

@IBDesignable
final class AddItemButton: UIControl {

    // MARK: - Inspectables

    // Circular background color
    @IBInspectable
    var fillColor: UIColor = UIColor._0A64F9 {
        didSet { backgroundColor = fillColor }
    }

    // Tint color for the plus icon (requires template-rendered image)
    @IBInspectable
    var iconTintColor: UIColor = .white {
        didSet { imageView.tintColor = iconTintColor }
    }

    // Optional asset name for the plus icon. If empty, we use SF Symbol "plus" (iOS 13+).
    @IBInspectable
    var plusImageName: String = "" {
        didSet { updateImage() }
    }

    // Ratio of icon size relative to the control’s min(width,height). 0.0 ... 1.0
    // Example: 0.5 means the icon’s width/height is 50% of the circle’s diameter.
    @IBInspectable
    var iconSizeRatio: CGFloat = 0.5 {
        didSet {
            iconSizeRatio = max(0.2, min(iconSizeRatio, 0.9))
            updateIconSizeConstraints()
        }
    }

    // MARK: - Subviews

    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.setContentHuggingPriority(.required, for: .horizontal)
        iv.setContentHuggingPriority(.required, for: .vertical)
        iv.setContentCompressionResistancePriority(.required, for: .horizontal)
        iv.setContentCompressionResistancePriority(.required, for: .vertical)
        return iv
    }()

    // Constraints that control icon size
    private var widthConstraint: NSLayoutConstraint?
    private var heightConstraint: NSLayoutConstraint?

    // MARK: - Init

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
        isAccessibilityElement = true
        accessibilityTraits = .button
        accessibilityLabel = "Add Item"

        backgroundColor = fillColor
        clipsToBounds = true

        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        // Initial size constraints (updated in layoutSubviews as well)
        widthConstraint = imageView.widthAnchor.constraint(equalToConstant: 0)
        heightConstraint = imageView.heightAnchor.constraint(equalToConstant: 0)
        widthConstraint?.isActive = true
        heightConstraint?.isActive = true

        updateImage()
        imageView.tintColor = iconTintColor

        // Defer the first size update until after initial layout to avoid zero-size crashes
        DispatchQueue.main.async { [weak self] in
            self?.updateIconSizeConstraints()
        }
    }

    private func updateImage() {
        if #available(iOS 13.0, *) {
            if plusImageName.isEmpty {
                imageView.image = UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate)
            } else {
                imageView.image = UIImage(named: plusImageName)?.withRenderingMode(.alwaysTemplate)
            }
        } else {
            // Fallback to asset by name on older iOS
            let name = plusImageName.isEmpty ? "plus" : plusImageName
            imageView.image = UIImage(named: name)?.withRenderingMode(.alwaysTemplate)
        }
    }

    private func updateIconSizeConstraints() {
        // Protect against zero/invalid sizes during early layout phases
        let diameter = min(bounds.width, bounds.height)
        guard diameter.isFinite, diameter > 0 else { return }

        let clampedRatio = max(0.2, min(iconSizeRatio, 0.9))
        let side = diameter * clampedRatio

        widthConstraint?.constant = side
        heightConstraint?.constant = side

        // Avoid forcing layout from within layoutSubviews to prevent recursion
        if window != nil {
            setNeedsLayout()
        }
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()

        // Keep it circular
        let diameter = min(bounds.width, bounds.height)
        layer.cornerRadius = diameter * 0.5

        // Update icon size responsively (safe now)
        updateIconSizeConstraints()
    }

    // MARK: - Touch feedback (optional)

    override var isHighlighted: Bool {
        didSet {
            alpha = isHighlighted ? 0.7 : 1.0
        }
    }

    // Default intrinsic size
    override var intrinsicContentSize: CGSize {
        CGSize(width: 44, height: 44)
    }
}
