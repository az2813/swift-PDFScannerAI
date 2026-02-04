//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import StoreKit
import Adapty

final class SubscriptionTrialHelper {
    static func extractTrialDuration(from product: SKProduct) -> String {
        guard let trial = product.introductoryPrice,
              trial.paymentMode == .freeTrial else {
            return SubscriptionProductHelper.isLifetime(product) ? "Lifetime access" : "No trial"
        }
        let period = trial.subscriptionPeriod
        return "\(period.numberOfUnits) \(SubscriptionDurationHelper.pluralizedUnit(for: period)) free"
    }

    static func extractTrialDuration(from product: AdaptyPaywallProduct) -> String {
        guard let offer = product.subscriptionOffer,
              offer.paymentMode == .freeTrial else {
            return SubscriptionProductHelper.isLifetime(product) ? "Lifetime access" : "No trial"
        }
        let period = offer.subscriptionPeriod
        return "\(period.numberOfUnits) \(SubscriptionDurationHelper.pluralizedUnit(for: period)) free"
    }

    static func hasTrial(_ product: SKProduct) -> Bool {
        product.introductoryPrice?.paymentMode == .freeTrial
    }

    static func hasTrial(_ product: AdaptyPaywallProduct) -> Bool {
        product.subscriptionOffer?.paymentMode == .freeTrial
    }
}
