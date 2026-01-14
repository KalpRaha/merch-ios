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
    func root()
    
    
    static func push(
        in navigationController: UINavigationController?,
        passData: ( (Self) -> () )?,
        animated: Bool
    )
    
    func push(
        in navigationController: UINavigationController?,
        animated: Bool
    )
    
    
    static func present(
        in currentVC: UIViewController,
        passData: ( (Self) -> () )?,
        animated: Bool,
        completion: ( () -> Void )?
    )
    
    func present(
        in currentVC: UIViewController,
        animated: Bool,
        completion: ( () -> Void )?
    )
    
    
    static func presentAsChildVC(
        in currentVC: UIViewController
    )
    
    func presentAsChildVC(
        in currentVC: UIViewController
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
        NavigationCoordinator.shared.rootVC(vc)
    }
    
    func root() {
        NavigationCoordinator.shared.rootVC(self)
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
    
    func push(
        in navigationController: UINavigationController?,
        animated: Bool = true
    ) {
        navigationController?.pushViewController(self, animated: animated)
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
    
    func present(
        in currentVC: UIViewController,
        animated: Bool = true,
        completion: ( () -> Void )? = nil
    ) {
        currentVC.present(self, animated: animated, completion: completion)
    }
    
    static func presentAsChildVC(
        in currentVC: UIViewController
    ) {
        
        let `self` = Self.instantiate()
        self.presentAsChildVC(in: currentVC)
    }
    
    func presentAsChildVC(
        in currentVC: UIViewController
    ) {
        
        self.view.frame = currentVC.view.bounds
        currentVC.view.addSubview(self.view)
        currentVC.addChild(self)
    }
    
    func popVC(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }
    
    
}


