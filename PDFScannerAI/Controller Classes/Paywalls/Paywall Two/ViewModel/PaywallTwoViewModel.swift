//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import Foundation
import Adapty

class PaywallTwoViewModel {
    struct ProductInfo {
        let product: AdaptyPaywallProduct
        let durationTitle: String
        let priceTrialLabel: String
        let weeklyPriceLabel: String
    }

    private(set) var products: [ProductInfo] = []
    private(set) var selectedIndex: Int?
    var onProductsUpdated: (() -> Void)?
    var onError: ((Error) -> Void)?

    func fetchProducts() {
        Adapty.getPaywall(placementId: "placement_2") { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(paywall):
                Adapty.getPaywallProducts(paywall: paywall) { [weak self] productsResult in
                    guard let self else { return }
                    switch productsResult {
                    case let .success(products):
                        self.handle(products: products)
                    case let .failure(error):
                        self.onError?(error)
                    }
                }
            case let .failure(error):
                print("Failed to get paywall: \(error)")
                self.onError?(error)
            }
        }
    }

    private func handle(products: [AdaptyPaywallProduct]) {
        let mapped = products.map { product -> ProductInfo in
            let price = SubscriptionPriceHelper.formattedPrice(for: product)
            let trial = SubscriptionTrialHelper.extractTrialDuration(from: product)
            let hasTrial = SubscriptionTrialHelper.hasTrial(product)
            let durationTitle = SubscriptionTitleHelper.proTitle(for: product)
            let priceTrialLabel = hasTrial ? "\(trial), then \(price)" : price
            let weeklyPrice = SubscriptionPriceHelper.weeklyPriceString(for: product)
            print(product.vendorProductId)
            return ProductInfo(product: product, durationTitle: durationTitle, priceTrialLabel: priceTrialLabel, weeklyPriceLabel: weeklyPrice)
        }
        self.products = mapped
        self.selectedIndex = mapped.indices.contains(1) ? 1 : mapped.isEmpty ? nil : 0
        self.onProductsUpdated?()
    }

    func selectProduct(at index: Int) {
        guard index >= 0 && index < products.count else { return }
        selectedIndex = index
    }

    var selectedProduct: ProductInfo? {
        guard let index = selectedIndex, index >= 0, index < products.count else { return nil }
        return products[index]
    }

    func selectProduct(withTrial hasTrial: Bool) {
        if let idx = products.firstIndex(where: { SubscriptionTrialHelper.hasTrial($0.product) == hasTrial }) {
            selectedIndex = idx
        }
    }

    // Returns a short description of the trial for a product
    func trialDescription(for info: ProductInfo) -> String {
        let hasTrial = SubscriptionTrialHelper.hasTrial(info.product)
        if hasTrial {
            let trial = SubscriptionTrialHelper.extractTrialDuration(from: info.product)
            return "Free \(trial) trial activated"
        } else {
            return "Get access to all our features"
        }
    }

    var selectedTrialDescription: String? {
        selectedProduct.map { trialDescription(for: $0) }
    }

    func purchaseSelectedProduct(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let product = selectedProduct?.product else {
            completion(.failure(NSError(domain: "PaywallTwo", code: -1, userInfo: [NSLocalizedDescriptionKey: "Product not found"])))
            return
        }
        Adapty.makePurchase(product: product) { result in
            switch result {
            case .success:
                completion(.success(()))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func restorePurchases(completion: @escaping (Result<Void, Error>) -> Void) {
        Adapty.restorePurchases { result in
            switch result {
            case .success:
                completion(.success(()))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
