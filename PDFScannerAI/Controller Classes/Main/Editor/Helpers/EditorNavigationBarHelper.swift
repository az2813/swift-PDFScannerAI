//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import Foundation
import UIKit

class EditorNavigationBarHelper {
    static func configureNavigationBar(for viewController: UIViewController, fileName: String, tapTarget: Any?, tapAction: Selector?, pagesTarget: Any?, pagesAction: Selector?) {
        let titleLabel = UILabel()
        titleLabel.text = fileName
        titleLabel.font = FontHelper.font(.semiBold, size: 16)
        titleLabel.textColor = Colors.mainTextColor

        let descriptionLabel = UILabel()
        descriptionLabel.text = "Tap to edit"
        descriptionLabel.font = FontHelper.font(.medium, size: 12)
        descriptionLabel.textColor = Colors.grayColor
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center

        let mainStack = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        mainStack.axis = .vertical
        mainStack.alignment = .center
        mainStack.spacing = 2

        if let action = tapAction {
            let tap = UITapGestureRecognizer(target: tapTarget, action: action)
            mainStack.isUserInteractionEnabled = true
            mainStack.addGestureRecognizer(tap)
        }

        viewController.navigationItem.titleView = mainStack

        if let action = pagesAction {
            viewController.navigationItem.rightBarButtonItem =
                createPagesButton(target: pagesTarget, action: action)
        }
    }

    static func createPagesButton(target: Any?, action: Selector) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "pages_icon")?.withRenderingMode(.alwaysTemplate),
                        for: .normal)
        button.tintColor = Colors.navigationItemsTintColor.withAlphaComponent(0.0)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 18
        button.contentEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)

        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 36),
            button.heightAnchor.constraint(equalToConstant: 36)
        ])

        button.addTarget(target, action: action, for: .touchUpInside)

        return UIBarButtonItem(customView: button)
    }
}
