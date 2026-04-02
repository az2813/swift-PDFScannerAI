//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import Foundation
import UIKit

class PreviewNavigationBarHelper {
    static func configureNavigationBar(for viewController: UIViewController, fileName: String, tapTarget: Any?, tapAction: Selector?, doneTarget: Any?, doneAction: Selector?, isTitleEditable: Bool = true) {
        if isTitleEditable {
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
            
            if let action = tapAction, isTitleEditable {
                let tap = UITapGestureRecognizer(target: tapTarget, action: action)
                mainStack.isUserInteractionEnabled = true
                mainStack.addGestureRecognizer(tap)
            }
            
            viewController.navigationItem.titleView = mainStack
        }

        if let action = doneAction {
            viewController.navigationItem.rightBarButtonItem =
                createDoneButton(target: doneTarget, action: action)
        }
    }

    static func createDoneButton(target: Any?, action: Selector) -> UIBarButtonItem {
        let label = PaddedLabel()
        label.text = "Done"
        label.textColor = Colors.whiteColor
        label.font = FontHelper.font(.semiBold, size: 14)
        label.backgroundColor = Colors.greenColor
        label.textAlignment = .center
        label.clipsToBounds = true
        label.setHorizontalPadding(8)
        label.setVerticalPadding(6)
        label.translatesAutoresizingMaskIntoConstraints = false

        let container = UIView()
        if #available(iOS 26.0, *) {
            container.backgroundColor = .white
        }
        container.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(label)

        // Constraints are REQUIRED in iOS 26
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            label.topAnchor.constraint(equalTo: container.topAnchor),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])

        // Force layout so size is known
        container.layoutIfNeeded()

        // Rounded pill
        label.layer.cornerRadius = label.intrinsicContentSize.height / 2

        // Tap handling
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        container.isUserInteractionEnabled = true
        container.addGestureRecognizer(tapGesture)

        return UIBarButtonItem(customView: container)
    }
}
