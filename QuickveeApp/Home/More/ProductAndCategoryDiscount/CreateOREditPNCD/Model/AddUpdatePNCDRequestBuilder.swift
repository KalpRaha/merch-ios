//
//  AddUpdatePNCDRequestBuilder.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 16/01/26.
//

import Foundation


extension CreateOREditPNCDVC {

    final class AddUpdatePNCDRequestBuilder {
        
        private var merchantId: String
        private var dealName: String?
        private var description: String?
        private var noEndDate: String?
        private var useWithCoupon: String?
        private var discount: String?
        private var discountType: String?
        private var isDisable: String?
        private var items: String?
        private var startDate: String?
        private var endDate: String?
        private var pNCDId: String?
        private var fullDay: String?
        private var startTime: String?
        private var endTime: String?
        private var repeatType: String?
        private var weeklyDays: String?
        private var monthlyDates: String?
        private var type: String?

        init(
            merchantId: String
        ) {
            self.merchantId = merchantId
        }

        func setMerchantId(_ value: String) -> Self {
            merchantId = value
            return self
        }
        
        func setDealName(_ value: String?) -> Self {
            dealName = value
            return self
        }
        
        func setDescription(_ value: String?) -> Self {
            description = value
            return self
        }
        
        func setNoEndDate(_ value: String?) -> Self {
            noEndDate = value
            return self
        }
        
        func setUseWithCoupon(_ value: String?) -> Self {
            useWithCoupon = value
            return self
        }
        
        func setDiscount(_ value: String?) -> Self {
            discount = value
            return self
        }
        
        func setDiscountType(_ value: String?) -> Self {
            discountType = value
            return self
        }
        
        func setIsDisable(_ value: String?) -> Self {
            isDisable = value
            return self
        }
        
        func setItems(_ value: String?) -> Self {
            items = value
            return self
        }
        
        func setStartDate(_ value: String?) -> Self {
            startDate = value
            return self
        }
        
        func setEndDate(_ value: String?) -> Self {
            endDate = value
            return self
        }
        
        func setPNCDId(_ value: String?) -> Self {
            pNCDId = value
            return self
        }
        
        func setFullDay(_ value: String?) -> Self {
            fullDay = value
            return self
        }
        
        func setStartTime(_ value: String?) -> Self {
            startTime = value
            return self
        }
        
        func setEndTime(_ value: String?) -> Self {
            endTime = value
            return self
        }
        
        func setRepeatType(_ value: String?) -> Self {
            repeatType = value
            return self
        }
        
        func setWeeklyDays(_ value: String?) -> Self {
            weeklyDays = value
            return self
        }
        
        func setMonthlyDates(_ value: String?) -> Self {
            monthlyDates = value
            return self
        }
        
        func setType(_ value: String?) -> Self {
            type = value
            return self
        }
        
        func build() -> CreateOrEditPNCDRequest {
            CreateOrEditPNCDRequest(
                merchantId: merchantId,
                pNCDId: pNCDId,
                dealName: dealName,
                description: description,
                noEndDate: noEndDate,
                useWithCoupon: useWithCoupon,
                discount: discount,
                discountType: discountType,
                isDisable: isDisable,
                items: items,
                startDate: startDate,
                endDate: endDate,
                fullDay: fullDay,
                startTime: startTime,
                endTime: endTime,
                repeatType: repeatType,
                weeklyDays: weeklyDays,
                monthlyDates: monthlyDates,
                type: type
            )
        }
    }
    
}
