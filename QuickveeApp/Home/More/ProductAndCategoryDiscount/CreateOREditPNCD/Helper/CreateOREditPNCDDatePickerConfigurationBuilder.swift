//
//  CreateOREditPNCDDatePickerConfigurationBuilder.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 16/01/26.
//

import UIKit

extension CreateOREditPNCDVC {
    
    class DatePickerConfigurationBuilder {
       
        weak var vc : CreateOREditPNCDVC!
       
        func make(
            datePickerView: DatePickerInputView,
            
        ) -> DatePickerInputView.Configuration {
            
            var configuration = DatePickerInputView.Configuration.init(
                titleTextConfiguration: .init(title: "Start Date"),
                textFieldTextConfiguration: .init(
                    placeholderText: "DD/MM/YYYY",
                    textColor: UIColor._878787
                ),
                txtViewConfig: .init(
                    borderColor: .E4E8EF,
                    borderWidth: 1,
                    borderOpacity: 1,
                    cornerRadius: 8
                )
            )
            
            let dtPlaceholder = "DD/MM/YYYY"
            let timePlaceholder = "HH:MM"
            
            switch datePickerView {
                
            case vc.dtPickerDealStartDate:
                configuration.titleTextConfiguration.title = "Start Date"
                configuration.textFieldTextConfiguration.placeholderText = dtPlaceholder
                
            case vc.dtPickerDealEndDate:
                configuration.titleTextConfiguration.title = "End Date"
                configuration.textFieldTextConfiguration.placeholderText = dtPlaceholder
                
            case vc.dtPickerDealStartTime:
                configuration.titleTextConfiguration.title = "Start Time"
                configuration.textFieldTextConfiguration.placeholderText = timePlaceholder
                
            case vc.dtPickerDealEndTime:
                configuration.titleTextConfiguration.title = "End Time"
                configuration.textFieldTextConfiguration.placeholderText = timePlaceholder
                
            default:
                configuration.titleTextConfiguration.title = "Date or Time"
                configuration.textFieldTextConfiguration.placeholderText = "Select"
                
            }
            
            return configuration
        }
    }
    
}
