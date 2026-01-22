//
//  CustomSegmentedControl.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 08/01/26.
//
import UIKit

class CustomSegmentedControl: UIControl {

    // MARK: - Public API

    var items: [String] = [] {
        didSet {
            rebuildSegments()
            // Keep current selectedIndex within bounds but do not auto-apply selection visually.
            if !items.isEmpty {
                let clamped = max(0, min(_selectedIndex, items.count - 1))
                _selectedIndex = clamped
            } else {
                _selectedIndex = 0
            }
            setNeedsLayout()
        }
    }

    // The last tapped index (read this in your action handler)
    private(set) var tappedIndex: Int?

    @IBInspectable private(set) var _selectedIndex: Int = 0

    // MARK: - Private Views

    private let stackView = UIStackView()
    private let thumbView = UIView()
    private var labels: [UILabel] = []

    private var stackConstraints: [NSLayoutConstraint] = []

    var configuration: Configuration = .default {
        didSet {
            updateConfiguration()
        }
    }
    var isAnimateOnSwitching: Bool = true

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()

        configuration.control.cornerRadiusBorder.apply(in: self)
        configuration.thumb.cornerRadiusBorder.apply(in: thumbView)

        updateThumbFrame(animated: false)
    }

    // MARK: - Setup

    private func commonInit() {
        clipsToBounds = true

        setupThumbView()
        setupStackView()
    }

    private func setupThumbView() {
        thumbView.clipsToBounds = true
        insertSubview(thumbView, at: 0)
    }

    private func setupStackView() {
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)
        updateStackConstraints()
    }

    // MARK: - Build Segments

    func configure(with items: [String], configuration: Configuration) {
        self.items = items

        rebuildSegments()
        updateStackConstraints()

        self.configuration = configuration
    }

    func updateConfiguration(configuration: Configuration) {
        self.configuration = configuration
        updateConfiguration()
    }

    func updateConfiguration() {
        configuration.control.cornerRadiusBorder.apply(in: self)
        configuration.thumb.cornerRadiusBorder.apply(in: thumbView)

        self.backgroundColor = configuration.control.bgColor
        self.thumbView.backgroundColor = configuration.thumb.bgColor

        for (_, label) in labels.enumerated() {
            let isSelected = (label.tag == _selectedIndex)
            label.font = isSelected ? configuration.thumb.font : configuration.control.font
            label.textColor = isSelected ? configuration.thumb.textColor : configuration.control.textColor
        }
    }
}


extension CustomSegmentedControl {

    private func updateStackConstraints() {
        NSLayoutConstraint.deactivate(stackConstraints)

        let padding = configuration.paddingBetweenThumbAndControl

        stackConstraints = [
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding)
        ]

        NSLayoutConstraint.activate(stackConstraints)
        layoutIfNeeded()
    }

    private func rebuildSegments() {
        labels.removeAll()
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for (index, title) in items.enumerated() {
            let label = UILabel()
            label.text = title
            label.textAlignment = .center
            label.tag = index
            label.isUserInteractionEnabled = true

            let tap = UITapGestureRecognizer(
                target: self,
                action: #selector(segmentTapped(_:))
            )
            label.addGestureRecognizer(tap)

            labels.append(label)
            stackView.addArrangedSubview(label)
        }

        setNeedsLayout()
    }

    @objc private func segmentTapped(_ gesture: UITapGestureRecognizer) {
        guard let index = gesture.view?.tag else { return }

        // Do not update UI here. Only notify and let owner decide.
        tappedIndex = index

        // Choose the event you prefer; keeping .touchUpInside to match your current usage.
        sendActions(for: .touchUpInside)
        // If you prefer UIControl.Event.valueChanged, switch to:
        // sendActions(for: .valueChanged)
    }
}

// MARK: - UI Updates

extension CustomSegmentedControl {

    // Call this to apply a new selected index programmatically
    func select(index: Int, animated: Bool = true) {
        self.isAnimateOnSwitching = animated
        
        _selectedIndex = max(0, min(index, max(0, items.count - 1)))
        updateSelection(animated: isAnimateOnSwitching)
        // Do not send actions here; owner already initiated this change.
        // If you want to notify listeners on programmatic changes, you could
        // add: sendActions(for: .valueChanged)
    }

    private func updateSelection(animated: Bool) {
        for (i, label) in labels.enumerated() {
            label.font = (i == _selectedIndex) ? configuration.thumb.font : configuration.control.font
            label.textColor = (i == _selectedIndex) ? configuration.thumb.textColor : configuration.control.textColor
        }
        updateThumbFrame(animated: animated)
    }

    private func updateThumbFrame(animated: Bool) {
        guard !labels.isEmpty else { return }

        let padding = configuration.paddingBetweenThumbAndControl
        let segmentWidth = (bounds.width - padding * 2) / CGFloat(labels.count)
        let height = bounds.height - padding * 2

        let targetFrame = CGRect(
            x: padding + segmentWidth * CGFloat(_selectedIndex),
            y: padding,
            width: segmentWidth,
            height: height
        )

        let animations = {
            self.thumbView.frame = targetFrame
        }

        animated
        ? UIView.animate(withDuration: 0.25,
                         delay: 0,
                         usingSpringWithDamping: 0.85,
                         initialSpringVelocity: 0.6,
                         options: [.curveEaseInOut],
                         animations: animations)
        : animations()
    }
}


extension CustomSegmentedControl {

    struct Configuration {

        static var `default`: Self = .init()

        var paddingBetweenThumbAndControl: CGFloat = 0

        var control: ViewConfiguration = .init(

            textColor: .B2B2B2,
            font: FontFamily.ManropeBold.size(16),
            bgColor: .F9F9F9,
            cornerRadiusBorder: .init(
                color: .clear,
                width: 0,
                opacity: 0,
                cornerRadius: 4
            )
        )

        var thumb: ViewConfiguration = .init(
            textColor: .white,
            font: FontFamily.ManropeBold.size(16),
            bgColor: .black,
            cornerRadiusBorder: .init(
                color: .clear,
                width: 0,
                opacity: 0,
                cornerRadius: 4
            )
        )

        struct ViewConfiguration {
            var textColor: UIColor = .black
            var font: UIFont = .systemFont(ofSize: 14, weight: .medium)
            var bgColor: UIColor = .F9F9F9

            var cornerRadiusBorder: CornerRadiusBorder = .init(
                color: .clear,
                width: 0,
                opacity: 0,
                cornerRadius: 4
            )
        }

        struct CornerRadiusBorder {
            var color: UIColor = .clear
            var width: CGFloat = 0
            var opacity: CGFloat = 0
            var cornerRadius: CGFloat = 4

            func apply(in view: UIView) {
                view.applyBorder(
                    borderWidth: width,
                    borderColor: color,
                    borderOpacity: opacity
                )

                view.applyCornerRadius(cornerRadius: cornerRadius)
            }
        }

    }
}
