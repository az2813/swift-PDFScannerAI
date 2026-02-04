//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import UIKit

class PaywallTwoInteractionHelper {
    private weak var viewController: PaywallTwoViewController?
    private let viewModel: PaywallTwoViewModel

    init(viewController: PaywallTwoViewController, viewModel: PaywallTwoViewModel) {
        self.viewController = viewController
        self.viewModel = viewModel
    }

    func purchaseSelectedProduct() {
        guard let vc = viewController else { return }
        LoadingIndicatorManager.shared.show()
        viewModel.purchaseSelectedProduct { [weak self] result in
            DispatchQueue.main.async {
                LoadingIndicatorManager.shared.hide()
                switch result {
                case .success:
                    self?.openAppIfSubscribed(
                        failureAlertTitle: "Purchase Failed",
                        failureAlertMessage: "Your purchase could not be completed."
                    )
                case let .failure(error):
                    let ok = UIAlertAction(title: "OK", style: .default)
                    AlertHelper.showAlert(on: vc, title: "Purchase Error", message: error.localizedDescription, actions: [ok])
                }
            }
        }
    }

    func restorePurchases() {
        guard let vc = viewController else { return }
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
                    let ok = UIAlertAction(title: "OK", style: .default)
                    AlertHelper.showAlert(on: vc, title: "Restore Error", message: error.localizedDescription, actions: [ok])
                }
            }
        }
    }

    func openPrivacy() {
        UIApplication.shared.open(Constants.policyURL)
    }

    func openTerms() {
        UIApplication.shared.open(Constants.termsURL)
    }

    func customBackButtonTapped() {
        openApp()
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
                AlertHelper.showAlert(on: vc,
                                     title: title,
                                     message: message,
                                     actions: [ok])
            }
        }
    }
}
