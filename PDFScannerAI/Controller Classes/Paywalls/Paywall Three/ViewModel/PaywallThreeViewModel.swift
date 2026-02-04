//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import Foundation
import Adapty

class PaywallThreeViewModel {
    struct ProductInfo {
        let product: AdaptyPaywallProduct
        let durationLabel: String
        let priceLabel: String
        let trialLabel: String
        let descriptionText: String
    }

    private(set) var products: [ProductInfo] = []
    private(set) var selectedIndex: Int?
    var onProductsUpdated: (() -> Void)?
    var onError: ((Error) -> Void)?

    func fetchProducts() {
        Adapty.getPaywall(placementId: "placement_3") { [weak self] result in
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
            let duration = PaywallThreeTextHelper.shortDurationTitle(for: product)
            let price = PaywallThreeTextHelper.pricePerPeriodString(for: product)
            let trial = PaywallThreeTextHelper.trialLabelText(for: product)
            let description = PaywallThreeTextHelper.descriptionText(for: product)
            return ProductInfo(product: product, durationLabel: duration, priceLabel: price, trialLabel: trial, descriptionText: description)
        }
        self.products = mapped
        self.selectedIndex = mapped.isEmpty ? nil : 0
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
            completion(.failure(NSError(domain: "PaywallThree", code: -1, userInfo: [NSLocalizedDescriptionKey: "Product not found"])))
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
