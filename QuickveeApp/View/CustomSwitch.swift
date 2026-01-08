//
//  CustomSwitch.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 08/01/26.
//


import UIKit

final class CustomSwitch: UIControl {

    // MARK: - Public Properties

    var isOn: Bool = false {
        didSet {
            updateUI(animated: true)
            sendActions(for: .valueChanged)
        }
    }

    @IBInspectable var onBackgroundColor: UIColor = .CCDFFF
    @IBInspectable var offBackgroundColor: UIColor = .C5C5C5

    @IBInspectable var onThumbColor: UIColor = ._0A64F9
    @IBInspectable var offThumbColor: UIColor = .white

    // MARK: - Private Views

    private let stackView = UIStackView()
    private let thumbView = UIView()
    private let fillerView = UIView()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    // MARK: - Setup

    private func setupView() {
        layer.cornerRadius = bounds.height / 2
        clipsToBounds = true

        backgroundColor = offBackgroundColor

        // StackView
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2)
        ])

        // Thumb
        thumbView.backgroundColor = offThumbColor
        thumbView.layer.cornerRadius = (bounds.height - 4) / 2
        thumbView.isUserInteractionEnabled = false

        // Filler
        fillerView.backgroundColor = .clear
        fillerView.isUserInteractionEnabled = false

        // Initial State (OFF)
        stackView.addArrangedSubview(thumbView)
        stackView.addArrangedSubview(fillerView)

        // Tap Gesture
        let tap = UITapGestureRecognizer(target: self, action: #selector(toggle))
        addGestureRecognizer(tap)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.05, execute: { [weak self] in
            guard let self else { return }
            thumbView.layer.cornerRadius = thumbView.bounds.height / 2
        })
        thumbView.clipsToBounds = true
    }

    // MARK: - Actions

    @objc private func toggle() {
        isOn.toggle()
    }

    // MARK: - UI Updates

    private func updateUI(animated: Bool) {

        let animations = { [weak self] in
            guard let self else { return }
            self.backgroundColor = self.isOn ? self.onBackgroundColor : self.offBackgroundColor
            self.thumbView.backgroundColor = self.isOn ? self.onThumbColor : self.offThumbColor

            self.stackView.arrangedSubviews.forEach {
                self.stackView.removeArrangedSubview($0)
                $0.removeFromSuperview()
            }

            if self.isOn {
                self.stackView.addArrangedSubview(self.fillerView)
                self.stackView.addArrangedSubview(self.thumbView)
            } else {
                self.stackView.addArrangedSubview(self.thumbView)
                self.stackView.addArrangedSubview(self.fillerView)
            }

            self.layoutIfNeeded()
        }

        if animated {
            UIView.animate(
                withDuration: 0.25,
                delay: 0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0.5,
                options: [.curveEaseInOut],
                animations: animations
            )
        } else {
            animations()
        }
    }
}
