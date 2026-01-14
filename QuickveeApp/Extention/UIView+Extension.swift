//
//  UIView+Extension.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 31/12/25.
//

import UIKit
import ObjectiveC.runtime

extension UIView{
    
    func circularShape(){
        self.layer.cornerRadius = self.frame.height/2
    }
    
    func applyCornerRadius(cornerRadius: CGFloat, corners: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]){
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.layer.cornerRadius = cornerRadius
        self.layer.maskedCorners = corners
    }
    
    func applyBorder(borderWidth: CGFloat, borderColor: UIColor, borderOpacity: CGFloat = 1.0){
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.withAlphaComponent(borderOpacity).cgColor
        
    }
    
    // Function to apply shadow
    func applyShadow(shadowColor: UIColor, shadowOpacity: Float, shadowXOffset: CGFloat = 0, shadowYOffset: CGFloat = 0, shadowBlur: CGFloat, shadowSpread: CGFloat) {
        layer.masksToBounds = false  // Set to false to allow the shadow to be visible outside the corner radius
        
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = CGSize(width: shadowXOffset, height: shadowYOffset)
        layer.shadowRadius = shadowBlur / 2.0
        
        // Calculate the spread for the rounded path
        let spread = max(0, shadowSpread)
        
        // Set the shadow path to the rounded path with spread
        let roundedRect = bounds.insetBy(dx: -spread, dy: -spread)
        layer.shadowPath = UIBezierPath(roundedRect: roundedRect, cornerRadius: layer.cornerRadius).cgPath
    }
    
    func applyShadowWithFalseMasking(
        shadowColor: UIColor,
        shadowOpacity: Float,
        shadowXOffset: CGFloat = 0,
        shadowYOffset: CGFloat = 0,
        shadowBlur: CGFloat,
        shadowSpread: CGFloat
    ) {
        layer.masksToBounds = false
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = CGSize(width: shadowXOffset, height: shadowYOffset)
        layer.shadowRadius = shadowBlur / 2.0

        let spread = max(0, shadowSpread)
        let shadowRect = bounds.insetBy(dx: -spread, dy: -spread)
        let adjustedCornerRadius = (bounds.width / 2) + spread // Match corner radius to circular shadow path

        layer.shadowPath = UIBezierPath(roundedRect: shadowRect, cornerRadius: adjustedCornerRadius).cgPath
    }

}


/*
 
 Example :
 
    myView.addTapGesture { gesture in
        print("View tapped")
    }
 
 ////////////////
 
    myView.addTapGesture(
        tapsRequired: 2,
        configure: { $0.cancelsTouchesInView = false }
    ) { _ in
        print("Double tapped")
    }
 
 */

extension UIView {
    
    typealias TapAction = (UITapGestureRecognizer) -> Void
    
    private struct AssociatedKeys {
        // Use a stable, addressable key (Int stored property), not a String.
        static var tapAction: Int = 0
    }
    
    func addTapGesture(
        tapsRequired: Int = 1,
        configure: ((UITapGestureRecognizer) -> Void)? = nil,
        action: @escaping TapAction
    ) {
        isUserInteractionEnabled = true
        
        // Remove existing tap gestures to avoid duplicates
        gestureRecognizers?
            .filter { $0 is UITapGestureRecognizer }
            .forEach { removeGestureRecognizer($0) }
        
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(handleTapGesture(_:))
        )
        tapGesture.numberOfTapsRequired = tapsRequired
        configure?(tapGesture)
        
        addGestureRecognizer(tapGesture)
        
        objc_setAssociatedObject(
            self,
            &AssociatedKeys.tapAction,
            action,
            .OBJC_ASSOCIATION_COPY_NONATOMIC
        )
    }
    
    @objc private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        guard let action = objc_getAssociatedObject(
            self,
            &AssociatedKeys.tapAction
        ) as? TapAction else { return }
        
        action(gesture)
    }
    
}


/*
 
 Example :
 
    view.addSwipeGesture(
        direction: .down,
        action: { [weak self] gesture in
            guard let self else { return }
         
            Logger.log("Found this gesture action.")
        }
    )
 
 */

// Swipe Gesture
extension UIView {

    func addSwipeGesture(
        direction: UISwipeGestureRecognizer.Direction,
        configGesture: ((UISwipeGestureRecognizer) -> Void)? = nil,
        action: ((UISwipeGestureRecognizer) -> Void)?
    ) {

        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeGesture.direction = direction
        configGesture?(swipeGesture)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(swipeGesture)

        // Store the action closure as an associated object based upon the swipe direction
        switch direction{

        case .up:
            guard let key = AssociatedSwipeGestureActionKeys.swipeUpAction else {
                fatalError("AssociatedSwipeGestureActionKeys.swipeUpAction is nil.")
            }
            objc_setAssociatedObject(self, key, action, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            print("up")

        case .down:
            guard let key = AssociatedSwipeGestureActionKeys.swipeDownAction else {
                fatalError("AssociatedSwipeGestureActionKeys.swipeDownAction is nil.")
            }
            objc_setAssociatedObject(self, key, action, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            print("down")

        case.left:
            guard let key = AssociatedSwipeGestureActionKeys.swipeLeftAction else {
                fatalError("AssociatedSwipeGestureActionKeys.swipeLeftAction is nil.")
            }
            objc_setAssociatedObject(self, key, action, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            print("left")

        case .right:
            guard let key = AssociatedSwipeGestureActionKeys.swipeRightAction else {
                fatalError("AssociatedSwipeGestureActionKeys.swipeRightAction is nil.")
            }
            objc_setAssociatedObject(self, key, action, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            print("Right")

        default:
            guard let key = AssociatedSwipeGestureActionKeys.swipeUnknownAction else {
                fatalError("AssociatedSwipeGestureActionKeys.swipeUnknownAction is nil.")
            }
            objc_setAssociatedObject(self, key, action, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            print("unknown direction")
        }
    }

    @objc private func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        var mainKey : UnsafeRawPointer!
        
        switch gesture.direction{

        case .up:
            guard let key = AssociatedSwipeGestureActionKeys.swipeUpAction else {
                fatalError("AssociatedSwipeGestureActionKeys.swipeUpAction is nil.")
            }
            mainKey = key
            print("up")

        case .down:
            
            guard let key = AssociatedSwipeGestureActionKeys.swipeDownAction else {
                fatalError("AssociatedSwipeGestureActionKeys.swipeDownAction is nil.")
            }
            mainKey = key
            print("down")

        case.left:
            
            guard let key = AssociatedSwipeGestureActionKeys.swipeLeftAction else {
                fatalError("AssociatedSwipeGestureActionKeys.swipeLeftAction is nil.")
            }
            mainKey = key
            print("left")

        case .right:
            guard let key = AssociatedSwipeGestureActionKeys.swipeRightAction else {
                fatalError("AssociatedSwipeGestureActionKeys.swipeRightAction is nil.")
            }
            mainKey = key
            print("Right")

        default:
            
            guard let key = AssociatedSwipeGestureActionKeys.swipeUnknownAction else {
                fatalError("AssociatedSwipeGestureActionKeys.swipeUnknownAction is nil.")
            }
            mainKey = key
            print("unknown direction")
        }
        
        if let action = objc_getAssociatedObject(self, mainKey) as? (UISwipeGestureRecognizer) -> Void {
            action(gesture)
        }
        
    }
    
    private struct AssociatedSwipeGestureActionKeys {
        static let swipeUpAction = UnsafeRawPointer(bitPattern: "swipeUpAction".hashValue)
        static let swipeDownAction = UnsafeRawPointer(bitPattern: "swipeDownAction".hashValue)
        static let swipeRightAction = UnsafeRawPointer(bitPattern: "swipeRightAction".hashValue)
        static let swipeLeftAction = UnsafeRawPointer(bitPattern: "swipeLeftAction".hashValue)
        static let swipeUnknownAction = UnsafeRawPointer(bitPattern: "swipeUnknownAction".hashValue)
    }
    
}


extension UIView {

    func loadNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)

        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            fatalError("Failed to load nib for \(self)")
        }

        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
}


extension UITableViewCell {
    
    static var nib : UINib {
        UINib(nibName: className, bundle: nil)
    }
    
}
