//
//  Navigatable.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 30/12/25.
//

import UIKit

/// A protocol that unifies common navigation tasks for storyboard-based view controllers:
/// - Instantiation from a storyboard
/// - Setting as the application's root view controller
/// - Push navigation
/// - Modal presentation
/// - Embedding as a child view controller
/// - Popping from a navigation stack
///
/// Conformance is intended for UIViewController subclasses. Default implementations
/// are provided when `Self: UIViewController`.
protocol Navigatable {
    
    /// The storyboard from which instances of the conforming view controller are created.
    /// The default implementation (when `Self: UIViewController`) returns an app-provided
    /// `UIStoryboard.main`.
    static var storyboard : UIStoryboard { get }
    
    /// The storyboard identifier used to instantiate the conforming view controller.
    /// The default implementation (when `Self: UIViewController`) uses an app-provided
    /// `className` (typically the type name).
    static var viewControllerIdentifier : String { get }
    
    
    /// Instantiates a new instance of the conforming view controller using
    /// `storyboard` and `viewControllerIdentifier`.
    static func instantiate() -> Self
    
    /// Creates a new instance and sets it as the app's root view controller via
    /// the navigation coordinator, allowing optional configuration before display.
    /// - Parameter passData: An optional configuration closure that receives the created instance.
    static func root(passData: ( (Self) -> () )?)
    
    /// Sets `self` as the app's root view controller via the navigation coordinator.
    func root()
    
    
    /// Instantiates and pushes a new instance onto the provided navigation controller.
    /// - Parameters:
    ///   - navigationController: The navigation controller to push onto.
    ///   - passData: Optional configuration closure for the new instance.
    ///   - animated: Whether the push transition is animated.
    static func push(
        in navigationController: UINavigationController?,
        passData: ( (Self) -> () )?,
        animated: Bool
    )
    
    /// Pushes `self` onto the provided navigation controller.
    /// - Parameters:
    ///   - navigationController: The navigation controller to push onto.
    ///   - passData: Optional configuration closure for `self` prior to push.
    ///   - animated: Whether the push transition is animated.
    func push(
        in navigationController: UINavigationController?,
        passData: ( (Self) -> () )?,
        animated: Bool
    )
    
    /// Instantiates and pushes a new instance using the `navigationController` of `currentVC`.
    /// - Parameters:
    ///   - currentVC: The current view controller whose navigation controller will be used.
    ///   - passData: Optional configuration closure for the new instance.
    ///   - animated: Whether the push transition is animated.
    static func push(
        in currentVC: UIViewController?,
        passData: ( (Self) -> () )?,
        animated: Bool
    )
    
    /// Pushes `self` using the `navigationController` of `currentVC`.
    /// - Parameters:
    ///   - currentVC: The current view controller whose navigation controller will be used.
    ///   - passData: Optional configuration closure for the new instance.
    ///   - animated: Whether the push transition is animated.
    func push(
        in currentVC: UIViewController?,
        passData: ( (Self) -> () )?,
        animated: Bool
    )
    
    
    /// Instantiates and presents a new instance modally from `currentVC`.
    /// - Parameters:
    ///   - currentVC: The presenting view controller.
    ///   - passData: Optional configuration closure for the new instance.
    ///   - animated: Whether the presentation is animated.
    ///   - completion: Optional completion handler called after presentation finishes.
    static func present(
        in currentVC: UIViewController,
        passData: ( (Self) -> () )?,
        animated: Bool,
        completion: ( () -> Void )?
    )
    
    /// Presents `self` modally from `currentVC`.
    /// - Parameters:
    ///   - currentVC: The presenting view controller.
    ///   - passData: Optional configuration closure for `self`.
    ///   - animated: Whether the presentation is animated.
    ///   - completion: Optional completion handler called after presentation finishes.
    func present(
        in currentVC: UIViewController,
        passData: ( (Self) -> () )?,
        animated: Bool,
        completion: ( () -> Void )?
    )
    
    
    /// Instantiates and embeds a new instance as a child of `currentVC`, attaching its
    /// view to fill the parent.
    /// - Parameter currentVC: The parent view controller.
    static func presentAsChildVC(
        in currentVC: UIViewController
    )
    
    /// Embeds `self` as a child of `currentVC`, attaching its view to fill the parent.
    /// - Parameter currentVC: The parent view controller.
    func presentAsChildVC(
        in currentVC: UIViewController
    )
    
    /// Pops the top view controller from the navigation stack containing `self`.
    /// - Parameter animated: Whether the pop transition is animated.
    func popVC(animated: Bool)
}


//MARK: - Root Method

extension Navigatable where Self : UIViewController {
    
    /// Default storyboard used for instantiation. Expects an app-provided `UIStoryboard.main`.
    static var storyboard: UIStoryboard { .main }
    
    /// Default storyboard identifier. Expects an app-provided `className` (typically the type name).
    static var viewControllerIdentifier: String { className }
    
    
    /// Instantiates `Self` from the configured storyboard and identifier.
    /// - Returns: A new instance of the view controller.
    static func instantiate() -> Self {
        return storyboard.instantiateViewController(identifier: viewControllerIdentifier) as Self
    }
    
    
    /// Creates and sets a new instance as the app's root view controller via `NavigationCoordinator`,
    /// applying optional configuration before display.
    /// - Parameter passData: Optional configuration closure for the instance.
    static func root(
        passData: ( (Self) -> () )? = nil
    ) {
        let vc = Self.instantiate()
        
        passData?(vc)
        NavigationCoordinator.shared.rootVC(vc)
    }
    
    /// Sets `self` as the app's root view controller via `NavigationCoordinator`.
    func root() {
        NavigationCoordinator.shared.rootVC(self)
    }
    
}


//MARK: - Push Methods

extension Navigatable where Self : UIViewController {
    
    /// Instantiates and pushes a new `Self` onto the provided navigation controller.
    /// - Parameters:
    ///   - navigationController: The navigation controller to push onto.
    ///   - passData: Optional configuration closure for the new instance.
    ///   - animated: Whether the push is animated. Defaults to `true`.
    static func push(
        in navigationController: UINavigationController?,
        passData: ( (Self) -> () )? = nil,
        animated: Bool = true
    ) {
        Self.instantiate().push(in: navigationController, passData: passData, animated: animated)
    }
    
    /// Pushes `self` onto the provided navigation controller.
    /// - Parameters:
    ///   - navigationController: The navigation controller to push onto.
    ///   - passData: Optional configuration closure for `self`.
    ///   - animated: Whether the push is animated. Defaults to `true`.
    func push(
        in navigationController: UINavigationController?,
        passData: ( (Self) -> () )? = nil,
        animated: Bool = true
    ) {
        passData?(self)
        navigationController?.pushViewController(self, animated: animated)
    }
    
    /// Instantiates and pushes a new `Self` using `currentVC`'s navigation controller.
    /// - Parameters:
    ///   - currentVC: The current view controller whose navigation controller is used.
    ///   - passData: Optional configuration closure for the new instance.
    ///   - animated: Whether the push is animated. Defaults to `true`.
    static func push(
        in currentVC: UIViewController?,
        passData: ( (Self) -> () )?,
        animated: Bool = true
    ) {
        Self.instantiate().push(in: currentVC, passData: passData, animated: animated)
    }
    
    /// Pushes `self` using `currentVC`'s navigation controller.
    /// - Parameters:
    ///   - currentVC: The current view controller whose navigation controller is used.
    ///   - passData: Optional configuration closure for `self`.
    ///   - animated: Whether the push is animated. Defaults to `true`.
    func push(
        in currentVC: UIViewController?,
        passData: ( (Self) -> () )? = nil,
        animated: Bool = true
    ){
        passData?(self)
        currentVC?.navigationController?.pushViewController(self, animated: animated)
    }
    
}


//MARK: - Present Methods

extension Navigatable where Self : UIViewController {
    
    /// Instantiates and presents a new `Self` modally from `currentVC`.
    /// - Parameters:
    ///   - currentVC: The presenting view controller.
    ///   - passData: Optional configuration closure for the new instance.
    ///   - animated: Whether the presentation is animated. Defaults to `true`.
    ///   - completion: Optional completion handler called after presentation.
    static func present(
        in currentVC: UIViewController,
        passData: ( (Self) -> () )? = nil,
        animated: Bool = true,
        completion: ( () -> Void )? = nil
    ) {
        Self.instantiate().present(
            in: currentVC,
            passData: passData,
            animated: animated,
            completion: completion
        )
    }
    
    /// Presents `self` modally from `currentVC`.
    /// - Parameters:
    ///   - currentVC: The presenting view controller.
    ///   - passData: Optional configuration closure for `self`.
    ///   - animated: Whether the presentation is animated. Defaults to `true`.
    ///   - completion: Optional completion handler called after presentation.
    func present(
        in currentVC: UIViewController,
        passData: ( (Self) -> () )? = nil,
        animated: Bool = true,
        completion: ( () -> Void )? = nil
    ) {
        passData?(self)
        currentVC.present(self, animated: animated, completion: completion)
    }
    
}


//MARK: - Present As child vc Methods

extension Navigatable where Self : UIViewController {
    
    /// Instantiates and embeds a new `Self` as a child of `currentVC`, attaching
    /// its view to the parent's bounds.
    /// - Parameter currentVC: The parent view controller.
    static func presentAsChildVC(
        in currentVC: UIViewController
    ) {
        Self.instantiate().presentAsChildVC(in: currentVC)
    }
    
    /// Embeds `self` as a child of `currentVC`, attaching its view to the parent's bounds.
    /// - Parameter currentVC: The parent view controller.
    func presentAsChildVC(
        in currentVC: UIViewController
    ) {
        
        self.view.frame = currentVC.view.bounds
        currentVC.view.addSubview(self.view)
        currentVC.addChild(self)
    }
    
}


//MARK: - Pop Method

extension Navigatable where Self : UIViewController {
    
    /// Pops the top view controller from `self.navigationController`.
    /// - Parameter animated: Whether the pop is animated. Defaults to `true`.
    func popVC(
        animated: Bool = true
    ) {
        navigationController?.popViewController(animated: animated)
    }
    
    
}
