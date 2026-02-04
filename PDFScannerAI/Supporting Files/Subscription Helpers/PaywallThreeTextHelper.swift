//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import Adapty

final class PaywallThreeTextHelper {
    static func shortDurationTitle(for product: AdaptyPaywallProduct) -> String {
        guard let unit = product.subscriptionPeriod?.unit else { return "" }
        switch unit {
        case .week: return "WEEK"
        case .month: return "MONTH"
        case .year: return "YEAR"
        default:
            return SubscriptionDurationHelper.formatSubscriptionDuration(product.subscriptionPeriod!).uppercased()
        }
    }

    static func pricePerPeriodString(for product: AdaptyPaywallProduct) -> String {
        SubscriptionPriceHelper.pricePerPeriodString(for: product)
    }

    static func trialLabelText(for product: AdaptyPaywallProduct) -> String {
        if SubscriptionTrialHelper.hasTrial(product) {
            let trial = SubscriptionTrialHelper.extractTrialDuration(from: product)
            return "\(trial) trial"
        } else {
            return "Full app access"
        }
    }

    static func descriptionText(for product: AdaptyPaywallProduct) -> String {
        let price = SubscriptionPriceHelper.formattedPrice(for: product)
        guard let unit = product.subscriptionPeriod?.unit else { return "" }
        let unitText: String
        switch unit {
        case .week: unitText = "Week"
        case .month: unitText = "Month"
        case .year: unitText = "Year"
        default: unitText = SubscriptionDurationHelper.formatSubscriptionDuration(product.subscriptionPeriod!)
        }
        if SubscriptionTrialHelper.hasTrial(product) {
            let trial = SubscriptionTrialHelper.extractTrialDuration(from: product)
            return "Try \(trial), then you'll be charged \(price) per \(unitText). Cancel anytime."
        } else {
            return "Full access at \(price) per \(unitText). Cancel anytime."
        }
    }
}
