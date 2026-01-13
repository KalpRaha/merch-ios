//
//  WeeklySelectionView.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 13/01/26.
//

import UIKit

final class WeeklySelectionView: UIView {

    private let titleLabel = UILabel()
    private let stackView = UIStackView()


    private var dataSource: [WeekDayItem] = []
    private var selectedItems : [WeekDayItem] = []
    

    private var selectedConfig: DayItemUIConfig!
    private var unselectedConfig: DayItemUIConfig!

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBaseUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupBaseUI()
    }

    // MARK: - Setup
    private func setupBaseUI() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.axis = .horizontal
        stackView.distribution = .fillEqually

        addSubview(titleLabel)
        addSubview(stackView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    // MARK: - Public Configure
    func configure(
        titleConfig: CustomTextConfiguration,
        containerConfig: WeeklyContainerConfig = .init(),
        selectedUI: DayItemUIConfig = .init(
            borderColor: ._0A64F9,
            borderWidth: 1,
            textColor: ._0A64F9
        ),
        unselectedUI: DayItemUIConfig = .init(
            borderColor: .E4E8EF,
            borderWidth: 1,
            textColor: ._8B8B8B
        ),
        days: [WeekDayItem] = WeekDayItem.dataSource,
        selectedItems: [WeekDayItem] = [.sun]
    ) {
        self.dataSource = days
        self.selectedItems = selectedItems
        
        self.selectedConfig = selectedUI
        self.unselectedConfig = unselectedUI

        titleLabel.text = titleConfig.title
        titleLabel.font = titleConfig.font
        titleLabel.textColor = titleConfig.textColor
        titleLabel.textAlignment = .left

        backgroundColor = containerConfig.backgroundColor

        stackView.spacing = containerConfig.stackSpacing
        stackView.topAnchor.constraint(
            equalTo: titleLabel.bottomAnchor,
            constant: containerConfig.stackTopPadding
        ).isActive = true

        reloadDays()
    }
    
    func updateSelectedItemsDataSource(_ selectedItems : [WeekDayItem]){
        self.selectedItems = selectedItems
        reloadDays()
    }

    // MARK: - Reload
    private func reloadDays() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for (index, item) in dataSource.enumerated() {
            let view = DayItemView()
            view.translatesAutoresizingMaskIntoConstraints = false

            let isSelected = selectedItems.contains(item)
            let ui = isSelected ? selectedConfig! : unselectedConfig!

            view.configure(
                title: item.title,
                uiConfig: ui
            ) { [weak self] in
                self?.toggleSelection(at: index)
            }
            
            view.tag = index
            
            stackView.addArrangedSubview(view)
            
            // Maintain 1:1 aspect ratio
            let aspectConstraint = view.heightAnchor.constraint(equalTo: view.widthAnchor)
            aspectConstraint.priority = .required
            aspectConstraint.isActive = true
        }
    }

    private func toggleSelection(at index: Int) {
        if selectedItems.contains(dataSource[index]) {
            selectedItems.removeAll(where: { $0 == dataSource[index] })
        }else {
            selectedItems.append(dataSource[index])
        }
        
        reloadSelectedDays()
    }
    
    private func reloadSelectedDays() {
        stackView.arrangedSubviews.forEach { view in
            guard let view = view as? DayItemView else { return }
            let isSelected = selectedItems.contains(dataSource[view.tag])
            
            view.updateUIConfiguraiton(
                uiConfig: isSelected ? selectedConfig : unselectedConfig
            )
        }
    }
    

    
}
