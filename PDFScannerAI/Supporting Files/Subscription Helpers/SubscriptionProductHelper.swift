import StoreKit
import Adapty

final class SubscriptionProductHelper {
    static func isLifetime(_ product: SKProduct) -> Bool {
        product.subscriptionPeriod == nil || product.subscriptionPeriod?.numberOfUnits == 0
    }

    static func isLifetime(_ product: AdaptyProduct) -> Bool {
        product.subscriptionPeriod == nil || product.subscriptionPeriod?.numberOfUnits == 0
    }
}
