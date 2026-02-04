//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import StoreKit
import Adapty

final class SubscriptionDurationHelper {
    static func formatSubscriptionDuration(_ period: SKProductSubscriptionPeriod) -> String {
        let value = period.numberOfUnits
        switch period.unit {
        case .day:
            return value == 7 ? "Week" : "\(value) \(pluralize("day", value))"
        case .week:
            return "\(value) \(pluralize("week", value))"
        case .month:
            return value == 1 ? "Month" : "\(value) \(pluralize("month", value))"
        case .year:
            return value == 1 ? "Year" : "\(value) \(pluralize("year", value))"
        @unknown default:
            assertionFailure("Unknown SKProductSubscriptionPeriod unit")
            return "Unknown duration"
        }
    }

    static func formatSubscriptionDuration(_ period: AdaptySubscriptionPeriod) -> String {
        let value = period.numberOfUnits
        switch period.unit {
        case .day:
            return value == 7 ? "Week" : "\(value) \(pluralize("day", value))"
        case .week:
            return "\(value) \(pluralize("week", value))"
        case .month:
            return value == 1 ? "Month" : "\(value) \(pluralize("month", value))"
        case .year:
            return value == 1 ? "Year" : "\(value) \(pluralize("year", value))"
        default:
            return "Unknown duration"
        }
    }

    static func subscriptionDurationInDays(for product: SKProduct) -> Double? {
        guard let period = product.subscriptionPeriod else { return nil }
        return Double(period.numberOfUnits) * daysPerUnit(period.unit)
    }

    static func daysPerUnit(_ unit: AdaptySubscriptionPeriod.Unit) -> Double {
        switch unit {
        case .day: return 1.0
        case .week: return 7.0
        case .month: return 30.0
        case .year: return 365.0
        default: return 0.0
        }
    }

    private static func daysPerUnit(_ unit: SKProduct.PeriodUnit) -> Double {
        switch unit {
        case .day: return 1.0
        case .week: return 7.0
        case .month: return 30.0
        case .year: return 365.0
        @unknown default:
            assertionFailure("Unknown SKProduct.PeriodUnit")
            return 0.0
        }
    }

    static func pluralizedUnit(for period: SKProductSubscriptionPeriod) -> String {
        switch period.unit {
        case .day: return pluralize("day", period.numberOfUnits)
        case .week: return pluralize("week", period.numberOfUnits)
        case .month: return pluralize("month", period.numberOfUnits)
        case .year: return pluralize("year", period.numberOfUnits)
        @unknown default: return "unit"
        }
    }

    static func pluralizedUnit(for period: AdaptySubscriptionPeriod) -> String {
        switch period.unit {
        case .day: return pluralize("day", period.numberOfUnits)
        case .week: return pluralize("week", period.numberOfUnits)
        case .month: return pluralize("month", period.numberOfUnits)
        case .year: return pluralize("year", period.numberOfUnits)
        default: return "unit"
        }
    }

    private static func pluralize(_ unit: String, _ count: Int) -> String {
        count == 1 ? unit : unit + "s"
    }
}
