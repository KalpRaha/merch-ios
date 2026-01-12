//
//  ViewModel.swift
//  QuickveeApp
//
//  Created by Pallavi on 09/01/26.
//

import Foundation


protocol ProductAndCategorySelectionViewModelDelegate: AnyObject {
    
    func variantListApicall()
    
}

extension ProductAndCategorySelectionVC {

    class ViewModel {
        
        var repository: VariantListRepositoryProtocol
        weak var delegate: ProductAndCategorySelectionViewModelDelegate?
        
        var variantList: [InventoryVariant] = [] {
            didSet {
                delegate?.variantListApicall()
            }
        }
        
        var selectedIndexPath : [IndexPath] = []
        
        
        
        
        init(repository: VariantListRepositoryProtocol) {
            self.repository = repository
        }
      
//        
//        func getVariantData(){
//            
//            
//            
//            
////            Task{
////                
////                do{
////                    let data = try await repository.getVariantList()
////                    variantList = data.result ?? []
////                    print("Variant List:\(variantList)")
////                }catch{
////                    
////                    print("error:\(error)")
////                    
////                }
////            }
//        }
        
        
        func variantListApicall() {
            
            let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
            
            ApiCalls.sharedCall.variantListCall(merchant_id: id) { isSuccess, responseData in
                
                if isSuccess {
                    
                    guard let list = responseData["result"] else {
                        return
                    }
                    self.getResponseValues(varient: list)
                }
                else{
                    print("Api Error")
                }
            }
        }
        
        func getResponseValues(varient: Any){
            
            let response = varient as! [[String: Any]]
            var small = [InventoryVariant]()
            
            for res in response {
                
                let variant = InventoryVariant(id: "\(res["id"] ?? "")",
                                               costperItem: "\(res["costperItem"] ?? "")",
                                               title: "\(res["title"] ?? "")",
                                               isvarient: "\(res["isvarient"] ?? "")",
                                               upc: "\(res["upc"] ?? "")",
                                               cotegory: "\(res["cotegory"] ?? "")",
                                               var_id: "\(res["var_id"] ?? "")",
                                               var_upc: "\(res["var_upc"] ?? "")",
                                               quantity: "\(res["quantity"] ?? "")",
                                               price: "\(res["price"] ?? "")",
                                               custom_code: "\(res["custom_code"] ?? "")",
                                               variant: "\(res["variant"] ?? "")",
                                               var_price: "\(res["var_price"] ?? "")",
                                               is_lottery: "\(res["is_lottery"] ?? "")",
                                               var_costperItem: "\(res["var_costperItem"] ?? "")",
                                               brand: "\(res["brand"] ?? "")",
                                               brand_id: "\(res["brand_id"] ?? "")",
                                               tags: "\(res["tags"] ?? "")")
                
                small.append(variant)
            }
            
           // variantList = small.compactMap({ $0.toVariantDataModel() })
            variantList = small 
          print(variantList)
        }
        
        
    }
}


