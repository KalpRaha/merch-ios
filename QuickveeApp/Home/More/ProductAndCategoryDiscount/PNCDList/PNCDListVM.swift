//
//  PNCDListVM.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 15/01/26.
//

import Foundation

protocol ProductAndCategoryDiscountListVMProtocol: AnyObject {
    
    func didUpdatedDiscountList()
    
    func didUpdatedEnableDisableLoadingStateIds()
    
}

extension PNCDListVC {
    
    class ViewModel {
        
        
        var pncdRepository : PNCDAPIRepositoryProtocol
        weak var delegate : ProductAndCategoryDiscountListVMProtocol?
        
        var discountList : [PNCDDiscountListItem] = [] {
            didSet{
                delegate?.didUpdatedDiscountList()
            }
        }
        
        var enableDisableLoadingStateIds: Set<String> = []{
            didSet{
                // If you prefer to refresh the whole list whenever the set changes, uncomment:
                // delegate?.didUpdatedEnableDisableLoadingStateIds()
            }
        }
        
        init(
            pncdRepository: PNCDAPIRepositoryProtocol
        ) {
            self.pncdRepository = pncdRepository
        }
        
        func getDiscountList() {
            
            Task{
                do {
                    // Live code (commented for now)
                    // let request = GetDiscountListRequest()
                    // let data = try await pncdRepository.getDiscountsList(request: request)
                    // if data.status {
                    //     discountList =  data.data ?? []
                    // }
                    
                    guard
                        let data = testJSON.data(using: .utf8)
                    else{
                        return
                    }
                    let decodedData = try JSONDecoder().decode([PNCDDiscountListItem].self, from: data)
                    
                    // If you want to retain any in-flight loading ids only for items that still exist:
                    // let existingIds = Set(decodedData.compactMap { $0.id })
                    // enableDisableLoadingStateIds = enableDisableLoadingStateIds.intersection(existingIds)
                    
                    discountList = decodedData
                    
                    Logger.log("Found Response : \(decodedData)")
                    
                }catch{
                    Logger.log("Found Response Error : \(error)")
                }
                
            }
        }
        
        // New id-driven API: remove IndexPath dependency
        func enableDisableDiscountList(pncdID: String) {
            // Resolve current row (if present) from id
            guard let currentRow = discountList.firstIndex(where: { $0.id == pncdID }) else {
                Toast.showSomethingWentWrongMessage()
                return
            }
            
            let isDiscountDisable = discountList[currentRow].isDiscountDisable
            
            // Mark loading for this id and notify UI (collection reload can be id-driven in VC)
            enableDisableLoadingStateIds.insert(pncdID)
            self.delegate?.didUpdatedEnableDisableLoadingStateIds()
            
            Task{
                do {
                    
                    let request = UpdatePNCDStateRequest(
                        pncdID: pncdID,
                        status: !isDiscountDisable
                    )
                    
                    let data = try await pncdRepository.updatePNCDState(request: request)
                    
                    if (data.status ?? false) {
                        await MainActor.run { [weak self] in
                            guard let self else { return }
                            // Resolve current row by id to avoid stale positions.
                            if let latestRow = self.discountList.firstIndex(where: { $0.id == pncdID }) {
                                self.discountList[latestRow].updateDiscountDisableFlag(!isDiscountDisable)
                                self.enableDisableLoadingStateIds.remove(pncdID)
                                self.delegate?.didUpdatedEnableDisableLoadingStateIds()
                            } else {
                                // Fallback: remove loading flag if item no longer exists
                                self.enableDisableLoadingStateIds.remove(pncdID)
                                self.delegate?.didUpdatedEnableDisableLoadingStateIds()
                            }
                        }
                    }
                    
                    Logger.log("Found Response : \(data)")
                    
                }catch{
                    // Simulated delayed success path while server is down.
                    do {
                        try await Task.sleep(nanoseconds: 2_500_000_000)
                    } catch {
                        // ignore sleep cancellation
                    }
                    
                    await MainActor.run { [weak self] in
                        guard let self else { return }
                        if let latestRow = self.discountList.firstIndex(where: { $0.id == pncdID }) {
                            self.discountList[latestRow].updateDiscountDisableFlag(!isDiscountDisable)
                            self.enableDisableLoadingStateIds.remove(pncdID)
                            self.delegate?.didUpdatedEnableDisableLoadingStateIds()
                            Toast.show("State Updated Successfully.")
                        } else {
                            // Fallback: if item disappeared, just clear the flag and refresh list UI
                            self.enableDisableLoadingStateIds.remove(pncdID)
                            self.delegate?.didUpdatedEnableDisableLoadingStateIds()
                            Toast.show("State Updated Successfully.")
                        }
                    }
                    
                    Logger.log("Found Response Error : \(error)")
                }
                
            }
        }
        
        // Deprecated: kept for compatibility if something still calls it; forwards to id-based method
        func enableDisableDiscountList(indexPath: IndexPath) {
            guard let pncdID = discountList[safe: indexPath.row]?.id else {
                Toast.showSomethingWentWrongMessage()
                return
            }
            enableDisableDiscountList(pncdID: pncdID)
        }
        
        private func showPNCDStateUpdateToast(indexPath: IndexPath){
            // Intentionally left for future toast customization
        }
    }
}


/// Safe subscript to avoid index out of range
private extension Array {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}



let testJSON = """
[
  {
    "id": "201",
    "merchant_id": "MERCH001",
    "start_date": "2026-01-01",
    "end_date": "2026-12-31",
    "deal_name": "New Year Category Discount",
    "description": "Flat discount on selected categories",
    "no_end_date": "0",
    "use_with_coupon": "0",
    "discount": "10.00",
    "discount_type": "1",
    "is_disable": "0",
    "items": "",
    "use_status": "1",
    "type": "category",
    "full_day": "1",
    "start_time": "00:00:00",
    "end_time": "23:59:59",
    "repeat_type": "1",
    "weekly_days": "Mon, Wed, Fri",
    "monthly_dates": "",
    "created_at": "2026-01-01 10:00:00",
    "updated_at": "2026-01-01 10:00:00",
    "is_deleted": "0",
    "updated_timestamp": "2026-01-01 10:00:00"
  },
  {
    "id": "202",
    "merchant_id": "MERCH002",
    "start_date": "2026-02-01",
    "end_date": "2026-02-28",
    "deal_name": "Valentine Special",
    "description": "Limited time discount on gift items",
    "no_end_date": "0",
    "use_with_coupon": "1",
    "discount": "15.00",
    "discount_type": "2",
    "is_disable": "0",
    "items": "gift_items",
    "use_status": "1",
    "type": "item",
    "full_day": "0",
    "start_time": "09:00:00",
    "end_time": "21:00:00",
    "repeat_type": "2",
    "weekly_days": "",
    "monthly_dates": "14",
    "created_at": "2026-01-20 11:30:00",
    "updated_at": "2026-01-22 09:15:00",
    "is_deleted": "0",
    "updated_timestamp": "2026-01-22 09:15:00"
  },
  {
    "id": "203",
    "merchant_id": "MERCH003",
    "start_date": "2026-03-01",
    "end_date": "2026-06-30",
    "deal_name": "Summer Sale",
    "description": "Seasonal summer discounts",
    "no_end_date": "0",
    "use_with_coupon": "0",
    "discount": "25.00",
    "discount_type": "1",
    "is_disable": "0",
    "items": "",
    "use_status": "1",
    "type": "store",
    "full_day": "1",
    "start_time": "00:00:00",
    "end_time": "23:59:59",
    "repeat_type": "1",
    "weekly_days": "Sat,Sun",
    "monthly_dates": "",
    "created_at": "2026-02-15 14:00:00",
    "updated_at": "2026-02-15 14:00:00",
    "is_deleted": "0",
    "updated_timestamp": "2026-02-15 14:00:00"
  },
  {
    "id": "204",
    "merchant_id": "MERCH004",
    "start_date": "2026-04-01",
    "end_date": "",
    "deal_name": "No End Date Offer",
    "description": "Ongoing discount without end date",
    "no_end_date": "1",
    "use_with_coupon": "0",
    "discount": "5.00",
    "discount_type": "1",
    "is_disable": "0",
    "items": "",
    "use_status": "1",
    "type": "category",
    "full_day": "1",
    "start_time": "00:00:00",
    "end_time": "23:59:59",
    "repeat_type": "3",
    "weekly_days": "",
    "monthly_dates": "",
    "created_at": "2026-03-10 08:00:00",
    "updated_at": "0000-00-00 00:00:00",
    "is_deleted": "0",
    "updated_timestamp": "2026-03-10 08:00:00"
  },
  {
    "id": "205",
    "merchant_id": "MERCH005",
    "start_date": "2026-05-01",
    "end_date": "2026-05-31",
    "deal_name": "Electronics Bonanza",
    "description": "Discount on electronic products",
    "no_end_date": "0",
    "use_with_coupon": "1",
    "discount": "20.00",
    "discount_type": "2",
    "is_disable": "0",
    "items": "electronics",
    "use_status": "1",
    "type": "item",
    "full_day": "0",
    "start_time": "10:00:00",
    "end_time": "22:00:00",
    "repeat_type": "1",
    "weekly_days": "Tue,Thu",
    "monthly_dates": "",
    "created_at": "2026-04-25 16:45:00",
    "updated_at": "2026-04-26 10:10:00",
    "is_deleted": "0",
    "updated_timestamp": "2026-04-26 10:10:00"
  },
  {
    "id": "206",
    "merchant_id": "MERCH006",
    "start_date": "2026-06-01",
    "end_date": "2026-06-15",
    "deal_name": "Mid-Year Flash Sale",
    "description": "Short duration flash sale",
    "no_end_date": "0",
    "use_with_coupon": "0",
    "discount": "35.00",
    "discount_type": "1",
    "is_disable": "1",
    "items": "",
    "use_status": "1",
    "type": "store",
    "full_day": "0",
    "start_time": "12:00:00",
    "end_time": "18:00:00",
    "repeat_type": "1",
    "weekly_days": "Mon,Tue,Wed",
    "monthly_dates": "",
    "created_at": "2026-05-20 13:00:00",
    "updated_at": "2026-05-21 09:00:00",
    "is_deleted": "0",
    "updated_timestamp": "2026-05-21 09:00:00"
  },
  {
    "id": "207",
    "merchant_id": "MERCH007",
    "start_date": "2026-07-01",
    "end_date": "2026-07-31",
    "deal_name": "Monsoon Deals",
    "description": "Rainy season offers",
    "no_end_date": "0",
    "use_with_coupon": "1",
    "discount": "12.50",
    "discount_type": "2",
    "is_disable": "1",
    "items": "",
    "use_status": "1",
    "type": "category",
    "full_day": "1",
    "start_time": "00:00:00",
    "end_time": "23:59:59",
    "repeat_type": "2",
    "weekly_days": "",
    "monthly_dates": "5,15,25",
    "created_at": "2026-06-25 17:20:00",
    "updated_at": "2026-06-25 17:20:00",
    "is_deleted": "0",
    "updated_timestamp": "2026-06-25 17:20:00"
  },
  {
    "id": "208",
    "merchant_id": "MERCH008",
    "start_date": "2026-08-01",
    "end_date": "2026-08-10",
    "deal_name": "Independence Sale",
    "description": "Special independence day discount",
    "no_end_date": "0",
    "use_with_coupon": "0",
    "discount": "18.00",
    "discount_type": "1",
    "is_disable": "0",
    "items": "",
    "use_status": "1",
    "type": "store",
    "full_day": "1",
    "start_time": "00:00:00",
    "end_time": "23:59:59",
    "repeat_type": "1",
    "weekly_days": "",
    "monthly_dates": "",
    "created_at": "2026-07-20 12:00:00",
    "updated_at": "2026-07-20 12:00:00",
    "is_deleted": "0",
    "updated_timestamp": "2026-07-20 12:00:00"
  },
  {
    "id": "209",
    "merchant_id": "MERCH009",
    "start_date": "2026-09-01",
    "end_date": "2026-09-30",
    "deal_name": "Back to School",
    "description": "Discount on school essentials",
    "no_end_date": "0",
    "use_with_coupon": "1",
    "discount": "22.00",
    "discount_type": "2",
    "is_disable": "0",
    "items": "stationery",
    "use_status": "1",
    "type": "item",
    "full_day": "0",
    "start_time": "08:00:00",
    "end_time": "20:00:00",
    "repeat_type": "1",
    "weekly_days": "Mon-Fri",
    "monthly_dates": "",
    "created_at": "2026-08-25 09:30:00",
    "updated_at": "2026-08-26 10:00:00",
    "is_deleted": "0",
    "updated_timestamp": "2026-08-26 10:00:00"
  },
  {
    "id": "210",
    "merchant_id": "MERCH010",
    "start_date": "2026-10-01",
    "end_date": "2026-10-31",
    "deal_name": "Festival Special",
    "description": "Festive season discounts",
    "no_end_date": "0",
    "use_with_coupon": "0",
    "discount": "40.00",
    "discount_type": "1",
    "is_disable": "1",
    "items": "",
    "use_status": "1",
    "type": "category",
    "full_day": "1",
    "start_time": "00:00:00",
    "end_time": "23:59:59",
    "repeat_type": "1",
    "weekly_days": "",
    "monthly_dates": "",
    "created_at": "2026-09-20 18:00:00",
    "updated_at": "2026-09-20 18:00:00",
    "is_deleted": "0",
    "updated_timestamp": "2026-09-20 18:00:00"
  }
]
"""

