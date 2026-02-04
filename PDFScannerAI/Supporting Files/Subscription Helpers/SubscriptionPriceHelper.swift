//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import StoreKit
import Adapty

final class SubscriptionPriceHelper {
    static func formattedPrice(for product: SKProduct) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        return formatter.string(from: product.price) ?? "\(product.price)"
    }

    static func formattedPrice(for product: AdaptyProduct) -> String {
        if let price = product.localizedPrice {
            return price
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        return formatter.string(from: NSDecimalNumber(decimal: product.price)) ?? "\(product.price)"
    }

    static func weeklyPriceString(for product: AdaptyProduct) -> String {
        guard let period = product.subscriptionPeriod else { return "" }
        let totalDays = Double(period.numberOfUnits) * SubscriptionDurationHelper.daysPerUnit(period.unit)
        guard totalDays > 0 else { return "" }
        let weeks = totalDays / 7.0
        guard weeks > 0 else { return "" }
        let priceDouble = NSDecimalNumber(decimal: product.price).doubleValue / weeks
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        let priceStr = formatter.string(from: NSNumber(value: priceDouble)) ?? String(format: "%.2f", priceDouble)
        return "\(priceStr)/week"
    }

    static func pricePerPeriodString(for product: AdaptyPaywallProduct) -> String {
        let price = formattedPrice(for: product)
        guard let unit = product.subscriptionPeriod?.unit else { return price }
        let unitText: String
        switch unit {
        case .week: unitText = "Week"
        case .month: unitText = "Month"
        case .year: unitText = "Year"
        default: unitText = SubscriptionDurationHelper.formatSubscriptionDuration(product.subscriptionPeriod!)
        }
        return "\(price)/\(unitText)"
    }
}
