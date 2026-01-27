//
//  CreateOREditPNCDVM.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 08/01/26.
//

import Foundation

protocol CreateOREditPNCDVMDelegate : AnyObject{
    
    func didCreatedPNCD()
    func didFoundErrorWhileCreatingThePNCD()
    
}

extension CreateOREditPNCDVC {
    
    class ViewModel {
        
        weak var delegate : CreateOREditPNCDVMDelegate?
        var repository: PNCDAPIRepositoryProtocol
        
        init(
            repository: PNCDAPIRepositoryProtocol,
            editableDiscountItem: PNCDDiscountListItem?,
            builder: CreateOREditPNCDVC.CreateOREditPNCDRequestBuilder
        ) {
            self.repository = repository
            self.editableDiscountItem = editableDiscountItem
            self.builder = builder
            
            self.flagsPropertyManager = FlagsPropertyManager()
        }
        
        var editableDiscountItem: PNCDDiscountListItem?
        var builder: CreateOREditPNCDVC.CreateOREditPNCDRequestBuilder
        
        
        var flagsPropertyManager: FlagsPropertyManager
      
        
        func createPNCD(req: CreateOrEditPNCDRequest) {
            Task{
                
                do {
                    let data = try await repository.createOrEditPNCD(request: req)
                    
                    if data.status {
                        delegate?.didCreatedPNCD()
                        Logger.log("Created or Edited PNCD successfully.")
                    }else{
                        delegate?.didFoundErrorWhileCreatingThePNCD()
                    }
                    
                    Logger.log("Create PNCD Response \(data)")
                    
                }catch {
                    
                    delegate?.didFoundErrorWhileCreatingThePNCD()
                    Logger.log("Error while Creating or Editing PNCD : \(error)")
                }
            }
        }
        
        
    }
    
}
