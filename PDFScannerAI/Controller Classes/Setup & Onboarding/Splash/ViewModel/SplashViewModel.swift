//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import Foundation

class SplashViewModel {

    var onOnboardingRequired: (() -> Void)?
    var onAppReady: (() -> Void)?
    var onPaywallRequired: (() -> Void)?

    func checkConditions() {
        if !UserDefaultsHelper.isOnboardingCompleted() {
            onOnboardingRequired?()
        } else {
            checkSubscriptionStatus()
        }
    }

    private func checkSubscriptionStatus() {
        SubscriptionManager.shared.checkSubscriptionStatus { [weak self] isSubscribed in
            if isSubscribed {
                self?.onAppReady?()
            } else {
                self?.onPaywallRequired?()
            }
        }
    }
}
