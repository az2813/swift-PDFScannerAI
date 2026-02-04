//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import Foundation
import UIKit

class PreviewNavigationBarHelper {
    static func configureNavigationBar(for viewController: UIViewController, fileName: String, tapTarget: Any?, tapAction: Selector?, doneTarget: Any?, doneAction: Selector?) {
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
        label.sizeToFit()

        let size = label.intrinsicContentSize
        label.frame = CGRect(origin: .zero, size: size)
        label.layer.cornerRadius = size.height / 2

        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tapGesture)

        return UIBarButtonItem(customView: label)
    }
}
