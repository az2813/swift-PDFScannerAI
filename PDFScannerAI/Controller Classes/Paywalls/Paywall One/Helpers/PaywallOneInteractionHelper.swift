//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import UIKit

final class PaywallOneInteractionHelper {
    private weak var viewController: PaywallOneViewController?
    private let viewModel: PaywallOneViewModel
    
    init(viewController: PaywallOneViewController, viewModel: PaywallOneViewModel) {
        self.viewController = viewController
        self.viewModel = viewModel
    }
    
    func setupInteractions() {
        guard let vc = viewController else { return }
        vc.subscribeButton.addTarget(self, action: #selector(makePurchase), for: .touchUpInside)
        vc.privacyButton.addTarget(self, action: #selector(openPrivacy), for: .touchUpInside)
        vc.termsButton.addTarget(self, action: #selector(openTerms), for: .touchUpInside)
    }
    
    @objc func makePurchase() {
        guard let vc = viewController else { return }
        AnimationUtility.animateButtonPress(vc.subscribeButton) { [weak self] in
            self?.viewController?.hapticFeedback()
            LoadingIndicatorManager.shared.show()
            self?.viewModel.purchaseSelectedProduct { [weak self] result in
                DispatchQueue.main.async {
                    LoadingIndicatorManager.shared.hide()
                    switch result {
                    case .success:
                        self?.openAppIfSubscribed(
                            failureAlertTitle: "Purchase Failed",
                            failureAlertMessage: "Your purchase could not be completed."
                        )
                    case let .failure(error):
                        if let vc = self?.viewController {
                            AlertHelper.showAlert(on: vc, title: "Error", message: error.localizedDescription, actions: [UIAlertAction(title: "OK", style: .default)])
                        }
                    }
                }
            }
        }
    }
    
    @objc func restorePurchasesTapped() {
        guard let vc = viewController else { return }
        vc.hapticFeedback()
        LoadingIndicatorManager.shared.show()
        viewModel.restorePurchases { [weak self] result in
            DispatchQueue.main.async {
                LoadingIndicatorManager.shared.hide()
                switch result {
                case .success:
                    self?.openAppIfSubscribed(
                        failureAlertTitle: "Restore Failed",
                        failureAlertMessage: "No previous purchases found to restore."
                    )
                case let .failure(error):
                    if let vc = self?.viewController {
                        AlertHelper.showAlert(on: vc, title: "Error", message: error.localizedDescription, actions: [UIAlertAction(title: "OK", style: .default)])
                    }
                }
            }
        }
    }
    
    @objc func customBackButtonTapped() {
        viewController?.hapticFeedback()
        openApp()
    }
    
    @objc func openPrivacy() {
        viewController?.hapticFeedback()
        UIApplication.shared.open(Constants.policyURL)
    }
    
    @objc func openTerms() {
        viewController?.hapticFeedback()
        UIApplication.shared.open(Constants.termsURL)
    }
    
    private func openApp() {
        guard let vc = viewController else { return }
        NavigationManager.shared.transitionToViewController(
            identifier: "DashboardViewController",
            from: vc,
            useNavigationController: true,
            push: false,
            presentationStyle: .fullScreen
        )
    }

    private func openAppIfSubscribed(
        failureAlertTitle: String? = nil,
        failureAlertMessage: String? = nil
    ) {
        SubscriptionManager.shared.checkSubscriptionStatus { [weak self] isSubscribed in
            guard let self else { return }
            if isSubscribed {
                self.openApp()
            } else if let title = failureAlertTitle,
                      let message = failureAlertMessage,
                      let vc = self.viewController {
                let ok = UIAlertAction(title: "OK", style: .default)
                AlertHelper.showAlert(on: vc, title: title, message: message, actions: [ok])
            }
        }
    }
}
