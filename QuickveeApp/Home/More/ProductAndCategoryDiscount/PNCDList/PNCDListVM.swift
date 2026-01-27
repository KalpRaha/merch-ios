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
                    
                    let request = GetDiscountListRequest()
                    let data = try await pncdRepository.getDiscountsList(request: request)
                    if data.status {
                        discountList =  data.data ?? []
                    }
                    
                    Logger.log("Found Response : \(data)")
                    
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
