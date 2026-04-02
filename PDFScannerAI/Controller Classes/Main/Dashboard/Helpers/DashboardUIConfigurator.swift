//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import UIKit

final class DashboardUIConfigurator {
    func configureUI(for viewController: DashboardViewController) {
        let vc = viewController
        vc.view.backgroundColor = Colors.backgroundColor

        vc.newScanButton.titleLabel?.font = FontHelper.font(.bold, size: 16)
        ImageStyleUtility.apply(
            to: vc.newScanButton,
            imageName: "dashboard_scan_icon",
            title: "Scan",
            cornerRadius: 16,
            backgroundColor: Colors.blueColor,
            titleTextColor: Colors.whiteColor
        )

        ImageStyleUtility.apply(
            to: vc.aiButton,
            imageName: "dashboard_share_icon",
            title: "Share",
            cornerRadius: 16,
            backgroundColor: Colors.blueColor,
            titleTextColor: Colors.whiteColor
        )
        
        ImageStyleUtility.apply(
            to: vc.carScanButton,
            imageName: "dashboard_add_icon",
            title: "Car Scan",
            cornerRadius: 16,
            backgroundColor: Colors.blueColor,
            titleTextColor: Colors.whiteColor
        )
    }

    func applyAccessState(for viewController: DashboardViewController, isSubscribed: Bool) {
        // Always keep UI interactive and fully visible; gating happens on action.
        viewController.newScanButton.isEnabled = true
        viewController.aiButton.isEnabled = true
        viewController.carScanButton.isEnabled = true
        viewController.newScanButton.alpha = 1.0
        viewController.aiButton.alpha = 1.0
        viewController.carScanButton.alpha = 1.0
        viewController.tableView.allowsSelection = true
    }
}
