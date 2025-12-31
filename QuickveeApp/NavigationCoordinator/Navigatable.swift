//
//  Navigatable.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 30/12/25.
//

import UIKit

protocol Navigatable {
    
    static var storyboard : UIStoryboard { get }
    static var viewControllerIdentifier : String { get }
    
    
    static func instantiate() -> Self
    
    static func root(passData: ( (Self) -> () )?)
    
    static func push(
        in navigationController: UINavigationController?,
        passData: ( (Self) -> () )?,
        animated: Bool
    )
    
    static func present(
        in currentVC: UIViewController,
        passData: ( (Self) -> () )?,
        animated: Bool,
        completion: ( () -> Void )?
    )
    
    func popVC(animated: Bool)
}

extension Navigatable where Self : UIViewController {
    
    static var storyboard: UIStoryboard { .main }
    static var viewControllerIdentifier: String { className }
    
    
    static func instantiate() -> Self {
        return storyboard.instantiateViewController(identifier: viewControllerIdentifier) as Self
    }
    
    
    static func root(
        passData: ( (Self) -> () )? = nil
    ) {
        let vc = Self.instantiate()
        
        passData?(vc)
        AppDelegate.getAppInstance().rootVC(vc)
    }
    
    static func push(
        in navigationController: UINavigationController?,
        passData: ( (Self) -> () )? = nil,
        animated: Bool = true
    ) {
        
        let vc = Self.instantiate()
        
        passData?(vc)
        navigationController?.pushViewController(vc, animated: animated)
    }
    
    static func present(
        in currentVC: UIViewController,
        passData: ( (Self) -> () )? = nil,
        animated: Bool = true,
        completion: ( () -> Void )? = nil
    ) {
        let vc = Self.instantiate()
        passData?(vc)
        currentVC.present(vc, animated: animated, completion: completion)
    }
    
    func popVC(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }
    
    
}


