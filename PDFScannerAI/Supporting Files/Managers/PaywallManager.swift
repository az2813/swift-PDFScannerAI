//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import Foundation
import UIKit

class PaywallManager {
    
    static let shared = PaywallManager()
    
    private init() {}

    // MARK: - Public Methods

    /// Fetches the remote config and presents the paywall based on the config key and isDismiss flag.
    func showPaywall(from viewController: UIViewController, configKey: String, isDismiss: Bool = false) {
        RemoteConfigManager.shared.fetchConfig { [weak self] success in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if success {
                    let paywallType = RemoteConfigManager.shared.getString(forKey: configKey) ?? "paywall_1"
                    self.presentPaywall(paywallType: paywallType, from: viewController, isDismiss: isDismiss)
                } else {
                    print("Error fetching remote config. Opening default paywall.")
                    self.presentDefaultPaywall(from: viewController, isDismiss: isDismiss)
                }
            }
        }
    }

    // MARK: - Private Methods

    /// Determines which paywall to present based on the paywall type.
    private func presentPaywall(paywallType: String, from viewController: UIViewController, isDismiss: Bool) {
        let viewControllerIdentifier: String
        switch paywallType {
        case "paywall_1":
            viewControllerIdentifier = "PaywallOneViewController"
        case "paywall_2":
            viewControllerIdentifier = "PaywallTwoViewController"
        case "paywall_3":
            viewControllerIdentifier = "PaywallThreeViewController"
        case "paywall_4":
            viewControllerIdentifier = "PaywallFourViewController"
        default:
            viewControllerIdentifier = "PaywallOneViewController"
        }

        // Present the paywall using NavigationManager and pass the isDismiss flag
        NavigationManager.shared.transitionToViewController(
            identifier: viewControllerIdentifier,
            from: viewController,
            useNavigationController: true,
            push: false,
            presentationStyle: .fullScreen
        ) { paywallVC in
            paywallVC.setValue(isDismiss, forKey: "isDismiss")
        }
    }

    /// Presents the default paywall if remote config fails.
    private func presentDefaultPaywall(from viewController: UIViewController, isDismiss: Bool) {
        let viewControllerIdentifier = "PaywallTwoViewController"
        NavigationManager.shared.transitionToViewController(
            identifier: viewControllerIdentifier,
            from: viewController,
            useNavigationController: true,
            push: false,
            presentationStyle: .fullScreen
        ) { paywallVC in
            paywallVC.setValue(isDismiss, forKey: "isDismiss")
        }
    }
}
