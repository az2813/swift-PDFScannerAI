//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import Foundation
import UIKit

class ChatNavigationBarHelper {
    static func configureNavigationBar(for viewController: UIViewController, fileName: String) {
        let titleLabel = UILabel()
        titleLabel.text = "Chat"
        titleLabel.font = FontHelper.font(.bold, size: 18)
        titleLabel.textColor = Colors.mainTextColor

        let subtitleLabel = UILabel()
        subtitleLabel.text = fileName
        subtitleLabel.font = FontHelper.font(.medium, size: 10)
        subtitleLabel.textColor = Colors.grayColor
        subtitleLabel.numberOfLines = 1
        subtitleLabel.textAlignment = .center

        let stack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 0

        viewController.navigationItem.titleView = stack
        viewController.navigationItem.rightBarButtonItem = nil
    }
}

