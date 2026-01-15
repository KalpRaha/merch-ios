//
//  BarcodeScannerDelegateHandler.swift
//  QuickveeApp
//
//  Created by Pallavi on 15/01/26.
//

import BarcodeScanner


class BarcodeScannerDelegateHandler  : BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate {
    
    var didCaptureCode: ((String, String) -> Void)?
    
    
    func scannerDidDismiss(_ controller: BarcodeScanner.BarcodeScannerViewController) {
        print("diddismiss")
    }
    
    func scanner(_ controller: BarcodeScanner.BarcodeScannerViewController, didReceiveError error: Error) {
        print("error")
    }
    
    func scanner(_ controller: BarcodeScanner.BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        print("success")
        
       didCaptureCode?(code, type)
    }
    
    
}
