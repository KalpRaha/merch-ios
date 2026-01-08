//
//  GenericSegmentedControl.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 08/01/26.
//
import UIKit

class GenericSegmentedControl: UIControl {

    // MARK: - Public API

    var items: [String] = [] {
        didSet {
            rebuildSegments()
            selectedIndex = min(selectedIndex, items.count - 1)
        }
    }

    @IBInspectable var selectedIndex: Int = 0 {
        didSet {
            updateSelection(animated: true)
            sendActions(for: .valueChanged)
        }
    }

    // MARK: - Private Views

    private let stackView = UIStackView()
    private let thumbView = UIView()
    private var labels: [UILabel] = []

    private var stackConstraints: [NSLayoutConstraint] = []

    var configuration : Configuration = .default {
        didSet{
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

    func configure(with items: [String], configuration : Configuration) {
        self.items = items
        
        rebuildSegments()
        updateStackConstraints()
        
        self.configuration = configuration
        
//        updateConfiguration()
    }
    
    func updateConfiguration(configuration : Configuration){
        self.configuration = configuration
        updateConfiguration()
    }
    
    func updateConfiguration() {
        configuration.control.cornerRadiusBorder.apply(in: self)
        configuration.thumb.cornerRadiusBorder.apply(in: thumbView)
        
        self.backgroundColor = configuration.control.bgColor
        self.thumbView.backgroundColor = configuration.thumb.bgColor
        
        for (_, label) in labels.enumerated(){
            let isSelected = (label.tag == selectedIndex)
            label.font = isSelected ? configuration.thumb.font : configuration.control.font
            label.textColor = isSelected ? configuration.thumb.textColor : configuration.control.textColor
        }
    }
    
}


extension GenericSegmentedControl {
    
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
        selectedIndex = index
    }

    
}

// MARK: - UI Updates

extension GenericSegmentedControl {

    private func updateSelection(animated: Bool) {
        for (i, label) in labels.enumerated() {
            label.font = (i == selectedIndex) ? configuration.thumb.font : configuration.control.font
            label.textColor = (i == selectedIndex) ? configuration.thumb.textColor : configuration.control.textColor
        }
        updateThumbFrame(animated: animated)
    }

    private func updateThumbFrame(animated: Bool) {
        guard !labels.isEmpty else { return }

        let padding = configuration.paddingBetweenThumbAndControl
        let segmentWidth = (bounds.width - padding * 2) / CGFloat(labels.count)
        let height = bounds.height - padding * 2

        let targetFrame = CGRect(
            x: padding + segmentWidth * CGFloat(selectedIndex),
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


extension GenericSegmentedControl {
    
    struct Configuration {
        
        static var `default` : Self = .init()
        
        
        var paddingBetweenThumbAndControl : CGFloat = 0
        
        
        var control : ViewConfiguration = .init(
            
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
        
        var thumb : ViewConfiguration = .init(
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
            var font : UIFont = .systemFont(ofSize: 14, weight: .medium)
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
            
            func apply(in view : UIView) {
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

