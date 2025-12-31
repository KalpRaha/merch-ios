//
//  NavigationCoordinator.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 31/12/25.
//


import UIKit

class NavigationCoordinator : NSObject {
    
    var window: UIWindow?
    var scene : UIWindowScene?
    
    private override init() {
    }
    
    static let shared = NavigationCoordinator()
    
    
    func configureWithWindowScene(_ scene: UIWindowScene) {
        self.scene = scene
        self.window = UIWindow(windowScene: scene)
        
        // Start
        configureIntialScreen()
    }
    
    func configureWithWindow(_ window: UIWindow) {
        self.window = window
        
        // Start
        configureIntialScreen()
    }
    
    func rootVC(_ vc: UIViewController) {
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.isNavigationBarHidden = true
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }
    
    func configureIntialScreen() {
        // Configure your initial screen
        
        if checkLogin() {
            PassCodeViewController.root()
            
        } else {
            LoginTableViewController.root()
        }
    }
    
    
    func checkLogin() -> Bool {
        return UserDefaults.standard.bool(forKey: "LoggedIn")
    }
    
}
