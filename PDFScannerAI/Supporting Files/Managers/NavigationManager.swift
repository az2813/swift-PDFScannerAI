//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import Foundation
import UIKit

class NavigationManager {
    
    static let shared = NavigationManager()
    
    private init() {}

    // MARK: - Transition to View Controller
    private func storyboard(from vc: UIViewController) -> UIStoryboard {
        return vc.storyboard ?? UIStoryboard(name: "Main", bundle: nil)
    }

    func transitionToViewController(identifier: String, from currentVC: UIViewController, useNavigationController: Bool = true, push: Bool = false, presentationStyle: UIModalPresentationStyle = .fullScreen, configure: ((UIViewController) -> Void)? = nil) {

        let storyboard = storyboard(from: currentVC)
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier)

        configure?(viewController)
        
        if push {
            pushToNavigationController(viewController, from: currentVC)
        } else {
            presentViewController(viewController, from: currentVC, useNavigationController: useNavigationController, presentationStyle: presentationStyle)
        }
    }
    
    // MARK: - Transition to Tab Bar Controller
    func transitionToTabBarController(from currentVC: UIViewController) {
        let storyboard = storyboard(from: currentVC)
        guard let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController else {
            print("Error: Could not find TabBarController")
            return
        }

        presentViewController(tabBarController, from: currentVC, useNavigationController: false, presentationStyle: .fullScreen)
    }
    
    // MARK: - Generic Transition with Configuration
    func transitionToConfiguredViewController(
        identifier: String,
        from currentVC: UIViewController,
        presentationStyle: UIModalPresentationStyle = .pageSheet,
        useNavigationController: Bool = false,
        detents: [UISheetPresentationController.Detent] = [.medium(), .large()],
        configure: ((UIViewController) -> Void)?
    ) {
        let storyboard = storyboard(from: currentVC)
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier)

        configure?(viewController)

        if useNavigationController {
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.modalPresentationStyle = presentationStyle

            if presentationStyle == .pageSheet {
                if let sheet = navigationController.sheetPresentationController {
                    sheet.detents = detents
                    sheet.preferredCornerRadius = 32
                    sheet.prefersGrabberVisible = true
                }
            }

            currentVC.present(navigationController, animated: true, completion: nil)
        } else {
            viewController.modalPresentationStyle = presentationStyle

            if presentationStyle == .pageSheet {
                if let sheet = viewController.sheetPresentationController {
                    sheet.detents = detents
                    sheet.preferredCornerRadius = 32
                    sheet.prefersGrabberVisible = true
                }
            }

            currentVC.present(viewController, animated: true, completion: nil)
        }
    }

    // MARK: - Helper Methods
    private func pushToNavigationController(_ viewController: UIViewController, from currentVC: UIViewController) {
        guard let navController = currentVC.navigationController else {
            print("Error: No navigation controller found to push view controller.")
            return
        }
        
        viewController.hidesBottomBarWhenPushed = true
        navController.pushViewController(viewController, animated: true)
    }
    
    private func presentViewController(_ viewController: UIViewController, from currentVC: UIViewController, useNavigationController: Bool, presentationStyle: UIModalPresentationStyle) {
        if useNavigationController {
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.modalPresentationStyle = presentationStyle
            currentVC.present(navigationController, animated: true, completion: nil)
        } else {
            viewController.modalPresentationStyle = presentationStyle
            currentVC.present(viewController, animated: true, completion: nil)
        }
    }
}
