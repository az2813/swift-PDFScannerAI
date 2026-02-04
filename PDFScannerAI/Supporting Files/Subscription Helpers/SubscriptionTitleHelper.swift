//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import StoreKit
import Adapty

final class SubscriptionTitleHelper {
    static func formattedTitle(for product: SKProduct) -> String {
        if SubscriptionProductHelper.isLifetime(product) {
            return "Lifetime"
        } else if let period = product.subscriptionPeriod {
            return SubscriptionDurationHelper.formatSubscriptionDuration(period)
        } else {
            return "Unknown"
        }
    }

    static func formattedTitle(for product: AdaptyProduct) -> String {
        if SubscriptionProductHelper.isLifetime(product) {
            return "Lifetime"
        } else if let period = product.subscriptionPeriod {
            return SubscriptionDurationHelper.formatSubscriptionDuration(period)
        } else {
            return "Unknown"
        }
    }

    static func proTitle(for product: AdaptyPaywallProduct) -> String {
        guard let period = product.subscriptionPeriod else { return "Pro" }
        let base: String
        switch (period.unit, period.numberOfUnits) {
        case (.week, _):
            base = "Pro Weekly"
        case (.month, 1):
            base = "Pro Monthly"
        case (.month, 3):
            base = "Pro Quarterly"
        case (.year, _):
            base = "Pro Yearly"
        default:
            base = "Pro \(SubscriptionDurationHelper.formatSubscriptionDuration(period))"
        }
        return SubscriptionTrialHelper.hasTrial(product) ? base + " + Trial" : base
    }
}
