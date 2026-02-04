//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import UIKit

final class SettingsInteractionHelper {
    private weak var viewController: UIViewController?
    private let mailHelper = SettingsMailHelper()

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    func presentPaywall() {
        guard let vc = viewController else { return }
        PaywallManager.shared.showPaywall(from: vc, configKey: "paywall_settings", isDismiss: true)
    }

    func openURL(_ url: URL) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    func rateApp() {
        guard let url = URL(string: "itms-apps://itunes.apple.com/app/id\(Constants.appID)?action=write-review") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    func sendFeedbackEmail() {
        guard let vc = viewController else { return }
        mailHelper.presentMailComposer(from: vc)
    }
}
