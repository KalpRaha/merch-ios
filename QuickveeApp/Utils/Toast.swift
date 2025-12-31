//
//  Toast.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 31/12/25.
//

import UIKit

class Toast {
    
    private init() { }
    static let shared = Toast()
    
    private lazy var toastView: ToastView = {
        buildToastView()
    }()
    
    private var timer : Timer?
    

    func show(message : String) {
        invalidateAndHide()
        toastView.setMessgae(message)
        
        toastView.alpha = 1
        scheduleToHide()
    }
    
    func hide() {
        UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseOut, animations: { [weak self] in
            guard let self else { return }
            toastView.alpha = 0.0
        })
    }
    
}

extension Toast {
    
    private func buildToastView() -> ToastView{
        let frame : CGRect = AppDelegate.getAppInstance().window?.frame ?? UIDevice.current.accessibilityFrame
        
        let view = ToastView(frame:  frame)
        view.alpha = 0
        AppDelegate.getAppInstance().window?.addSubview(view)
        
        return view
    }
    
}

extension Toast {
    
    static func show(message: String) {
        shared.show(message: message)
    }
    
    private func scheduleToHide(){
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false, block: { [weak self] _ in
            guard let self else { return }
            hide()
        })
    }
    
    private func invalidateAndHide(){
        timer?.invalidate()
        timer = nil
        toastView.alpha = 0
    }
    
}
