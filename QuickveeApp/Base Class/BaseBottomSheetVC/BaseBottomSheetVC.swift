//
//  BaseBottomSheetVC.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 14/01/26.
//

import UIKit


class BaseBottomSheetVC: UIViewController {
    
    private var bgTapGestureView: UIView!
    private var grabberInteractionView: UIView?
    
    private var btmContainerView: UIView!
    
    
    private var btmContainerViewOriginY : CGFloat!
    weak var delegate : BaseBottomSheetVCActionDelegate?
    
    
    deinit{
        Logger.log("\(className) Removed from memory.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
        showWithAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func updateUI(){
        bgTapGestureView = delegate?.setBGTapView() ?? UIView()
        btmContainerView = delegate?.setBottomContainerView() ?? UIView()
        
        self.view.backgroundColor = .clear
        btmContainerView.isHidden = true
        
        addGestures()
    }
    
    func addGestures(){
        if (delegate?.isAddTapToHideGestureOnBGView() ?? true) {
            
            bgTapGestureView.addTapGesture(action: { [weak self] _ in
                guard let self else { return }
                
                delegate?.onTapToHideGesture()
                
                if (delegate?.isHideOnTapToHideGestureOnBGView() ?? true) {
                    hideWithAnimation()
                }
                
            })  // bgInteractionView.addTapGesture
        }   // if isAddBGViewTapToHideGesture
        
        
        if (delegate?.isAddBGViewSwipeDownToHideGesture() ?? false)  {
            
            btmContainerView.addSwipeGesture(direction: [.down],
                                             action: { [weak self] _ in
                guard let self else { return }
                
                delegate?.onSwipeDownToHideGesture()
                
            })  // bgInteractionView.addSwipeGesture
        }   // if isAddBGViewSwipeDownToHideGesture
        
    }   // addGestures
    
    func showWithAnimation(){
        btmContainerView.frame.origin.y += (btmContainerView.frame.height + 100)
        btmContainerView.isHidden = false
        
        CommonFunctions.generateHapticFeedback()
        
        btmContainerView.transform = CGAffineTransform(translationX: 0, y: btmContainerView.bounds.height + 100)
        self.view.backgroundColor = .clear
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            
            btmContainerView.transform = .identity
            
            view.backgroundColor = delegate?.setBGDimColor() ?? .black.withAlphaComponent(0.6)
        }
    }
    
    func hideWithAnimation(){
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let self else { return }
            
            self.view.backgroundColor = .clear
            btmContainerView.transform = CGAffineTransform(translationX: 0, y: btmContainerView.bounds.height + 100)
            
        }, completion: { [weak self] _ in
            guard let self else { return }
            
            view.removeFromSuperview()
            removeFromParent()
        })
    }
    
    
}


