//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import Foundation
import Adapty

class PaywallOneViewModel {
    struct ProductInfo {
        let product: AdaptyPaywallProduct
        let durationTitle: String
        let priceTrialLabel: String
        let weeklyPriceLabel: String
        let priceLabelText: String
        let titleText: String
        let descriptionText: String
    }
    
    enum PaywallError: Error {
        case productNotFound
    }
    
    private(set) var products: [ProductInfo] = []
    private(set) var selectedIndex: Int?
    var onProductsUpdated: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    var selectedProduct: ProductInfo? {
        guard let index = selectedIndex, index >= 0, index < products.count else { return nil }
        return products[index]
    }
    
    func fetchProducts() {
        Adapty.getPaywall(placementId: "placement_1") { [weak self] result in
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
            let formattedPrice = SubscriptionPriceHelper.formattedPrice(for: product)
            let trial = SubscriptionTrialHelper.extractTrialDuration(from: product)
            let hasTrial = SubscriptionTrialHelper.hasTrial(product)
            let duration = product.subscriptionPeriod.map { SubscriptionDurationHelper.formatSubscriptionDuration($0) } ?? ""
            
            let priceLabelText = hasTrial
            ? "Enjoy \(trial) free, then \(formattedPrice) / \(duration). Cancel anytime."
            : "Just \(formattedPrice) / \(duration). Cancel anytime."
            let titleText = hasTrial ? "Free PDF Scanner & AI Chat Trial" : "Unlock PDF Scanner & AI Chat"
            let descriptionText = hasTrial
            ? "All features free for \(trial.lowercased()). Scan, extract text, and chat with PDFs."
            : "Scan PDFs, extract text, and chat with your documents"
            
            let durationTitle = SubscriptionTitleHelper.proTitle(for: product)
            let priceTrialLabel = hasTrial ? "\(trial), then \(formattedPrice)" : formattedPrice
            let weeklyPrice = SubscriptionPriceHelper.weeklyPriceString(for: product)
            
            return ProductInfo(product: product, durationTitle: durationTitle, priceTrialLabel: priceTrialLabel, weeklyPriceLabel: weeklyPrice, priceLabelText: priceLabelText, titleText: titleText, descriptionText: descriptionText)
        }
        self.products = mapped
        self.selectedIndex = mapped.isEmpty ? nil : 0
        self.onProductsUpdated?()
    }
    
    func selectProduct(at index: Int) {
        guard index >= 0 && index < products.count else { return }
        selectedIndex = index
    }
    
    func purchaseSelectedProduct(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let product = selectedProduct?.product else {
            completion(.failure(PaywallError.productNotFound))
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
