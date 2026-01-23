//
//  CustomSwitch.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 08/01/26.
//

import UIKit

final class CustomSwitch: UIControl {

    // MARK: - Public Properties

    // Backing state. Does NOT send actions automatically.
    private(set) var isOn: Bool = false

    // Background colors
    @IBInspectable var onBackgroundColor: UIColor = .CCDFFF
    @IBInspectable var offBackgroundColor: UIColor = .C5C5C5

    // Thumb colors
    @IBInspectable var onThumbColor: UIColor = ._0A64F9
    @IBInspectable var offThumbColor: UIColor = .white

    // Loader colors (arrays let you do multi-color animations like GenericButton)
    // If you prefer a single color, provide a 1-element array.
    var loaderOnColors: [UIColor] = [.white]
    var loaderOffColors: [UIColor] = [._0A64F9]

    // Loader line width
    var loaderLineWidth: CGFloat = 2.5

    // MARK: - Private Views

    private let stackView = UIStackView()
    private let thumbView = UIView()
    private let fillerView = UIView()

    // Loader inside thumb
    private lazy var loaderView: ProgressView? = {
        let pv = ProgressView(colors: loaderOffColors, lineWidth: loaderLineWidth)
        pv.translatesAutoresizingMaskIntoConstraints = false
        return pv
    }()

    // Prevent re-entrant taps while loading
    var isLoading: Bool = false {
        didSet{
            // Lock user interaction to avoid double taps while loading
            isUserInteractionEnabled = isLoading ? false : true
        }
    }

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

        // Filler
        fillerView.backgroundColor = .clear
        fillerView.isUserInteractionEnabled = false

        // Initial State (OFF)
        stackView.addArrangedSubview(thumbView)
        stackView.addArrangedSubview(fillerView)

        // Thumb
        // Loader in thumb
        thumbView.backgroundColor = offThumbColor
        thumbView.isUserInteractionEnabled = false
        thumbView.translatesAutoresizingMaskIntoConstraints = false
       
        
        // Tap Gesture: send .touchUpInside only, do not toggle automatically
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)
    }
    
    private func buildLoaderView(){
        // Configure colors depending on the intended state
        let colors = (isOn) ? loaderOnColors : loaderOffColors

        // Recreate loader with desired colors/lineWidth if needed
        loaderView?.removeFromSuperview()
        loaderView = nil
        
        let pv = ProgressView(colors: colors, lineWidth: loaderLineWidth)
        pv.translatesAutoresizingMaskIntoConstraints = false
        thumbView.addSubview(pv)
        
        NSLayoutConstraint.activate([
            pv.centerXAnchor.constraint(equalTo: thumbView.centerXAnchor),
            pv.centerYAnchor.constraint(equalTo: thumbView.centerYAnchor),
            pv.widthAnchor.constraint(equalTo: thumbView.heightAnchor, multiplier: 0.5),
            pv.heightAnchor.constraint(equalTo: pv.widthAnchor)
        ])
        loaderView = pv
        loaderView!.isHidden = false
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2

        // Corner radius after layout to get correct size
        thumbView.layer.cornerRadius = (bounds.height - 4) / 2
        thumbView.clipsToBounds = true
    }

    // MARK: - Actions

    // External programmatic toggle. Does NOT send any control events.
    func updateIsOnFlag(_ on: Bool, animated: Bool = true) {
        guard isOn != on else { return }
        isOn = on
        updateUI(animated: animated)
    }

    // IBAction flow: touch -> sendAction(.touchUpInside) -> your controller decides to start loading, call API, then setIsOn/stopLoading
    @objc private func handleTap() {
        // Do not toggle here. Just notify.
        sendActions(for: .touchUpInside)
    }

    // MARK: - Loader Control

    // Call from your IBAction before API call (or when starting it)
    func startLoading() {
        guard !isLoading else { return }
        defer{
            isLoading = true
        }

        buildLoaderView()
        loaderView?.isAnimating = true
    }

    // Call from your IBAction after API finishes
    func stopLoading() {
        guard isLoading else { return }
        isLoading = false
        loaderView?.isAnimating = false
        loaderView?.isHidden = true
        loaderView?.removeFromSuperview()
        loaderView = nil
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

