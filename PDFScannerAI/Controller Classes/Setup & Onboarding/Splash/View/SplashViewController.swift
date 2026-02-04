//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import UIKit

class SplashViewController: UIViewController {

    private let viewModel = SplashViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.checkConditions()
    }
}

// MARK: - UI Setup
extension SplashViewController {
    private func setupUI() {
        view.backgroundColor = Colors.backgroundColor
    }
    
    private func bindViewModel() {
        viewModel.onOnboardingRequired = { [weak self] in
           self?.openOnboarding()
        }

        viewModel.onAppReady = { [weak self] in
            self?.openApp()
        }

        viewModel.onPaywallRequired = { [weak self] in
            self?.presentPaywallController()
        }
    }
}

// MARK: - Navigation
extension SplashViewController {
    private func openOnboarding() {
        NavigationManager.shared.transitionToViewController(
            identifier: "OnboardingViewController",
            from: self,
            useNavigationController: false,
            presentationStyle: .fullScreen
        )
    }

    private func openApp() {
        NavigationManager.shared.transitionToViewController(
            identifier: "DashboardViewController",
            from: self
        )
    }
    
    private func presentPaywallController() {
        PaywallManager.shared.showPaywall(from: self, configKey: "paywall_splash", isDismiss: false)
    }
}
