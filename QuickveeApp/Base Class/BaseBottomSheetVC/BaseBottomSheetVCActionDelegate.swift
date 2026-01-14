//
//  BaseBottomSheetVCActionDelegate.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 14/01/26.
//

import UIKit


protocol BaseBottomSheetVCActionDelegate : AnyObject {
    
    func setBGTapView() -> UIView
    func setBottomContainerView() -> UIView
    
    func setBGDimColor() -> UIColor
    
    func onTapToHideGesture()
    func onSwipeDownToHideGesture()
    func onSwipeDownGrabberViewToHideGesture()
    
    
    func isAddTapToHideGestureOnBGView() -> Bool // default it will be true
    func isHideOnTapToHideGestureOnBGView() -> Bool // default it will be true
    
    func isAddBGViewSwipeDownToHideGesture() -> Bool // default it will be false
    
}

extension BaseBottomSheetVCActionDelegate {
    
    
    func setBGDimColor() -> UIColor {
        .black.withAlphaComponent(0.6)
    }
    
    // gesture
    
    func onTapToHideGesture() { }
    func onSwipeDownToHideGesture() { }
    func onSwipeDownGrabberViewToHideGesture() { }
    
    
    // Configuration flags
    func isAddTapToHideGestureOnBGView() -> Bool {
        true
    }
    
    func isHideOnTapToHideGestureOnBGView() -> Bool {
        true
    }
    
    func isAddBGViewSwipeDownToHideGesture() -> Bool {
        false
    }
    
}
