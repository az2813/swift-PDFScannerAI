//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import UIKit

class SettingsNavigationBarHelper {
    static func configureNavigationBar(for viewController: UIViewController) {
        let titleLabel = UILabel()
        titleLabel.text = "Settings & More"
        titleLabel.font = FontHelper.font(.bold, size: 22)
        titleLabel.textColor = Colors.mainTextColor
        viewController.navigationItem.titleView = titleLabel
    }
}
