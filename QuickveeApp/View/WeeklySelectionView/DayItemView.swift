//
//  DayItemView.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 13/01/26.
//

import UIKit

extension WeeklySelectionView {
    
    class DayItemView: UIView {

        private let titleLabel = UILabel()
        private var tapAction: (() -> Void)?

        override init(frame: CGRect) {
            super.init(frame: frame)
            setupUI()
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setupUI()
        }

        private func setupUI() {
            titleLabel.textAlignment = .center
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            addSubview(titleLabel)

            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: topAnchor),
                titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
                titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])

            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            addGestureRecognizer(tap)
        }

        func configure(
            title: String,
            uiConfig: DayItemUIConfig,
            tapAction: @escaping () -> Void
        ) {
            self.tapAction = tapAction
            titleLabel.text = title
            
            updateUIConfiguraiton(uiConfig: uiConfig)
        }
        
        func updateUIConfiguraiton(
            uiConfig: DayItemUIConfig
        ) {
            titleLabel.textColor = uiConfig.textColor
            titleLabel.font = uiConfig.font

            backgroundColor = uiConfig.backgroundColor
            layer.borderColor = uiConfig.borderColor.cgColor
            layer.borderWidth = uiConfig.borderWidth
            layer.cornerRadius = uiConfig.cornerRadius
            layer.masksToBounds = true
        }

        @objc private func handleTap() {
            tapAction?()
        }
    }
    
}
