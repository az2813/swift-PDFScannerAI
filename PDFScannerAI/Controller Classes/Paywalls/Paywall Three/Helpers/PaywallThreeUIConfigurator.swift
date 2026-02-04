//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import UIKit

final class PaywallThreeUIConfigurator {
    func configureUI(for viewController: PaywallThreeViewController) {
        let vc = viewController
        vc.view.backgroundColor = Colors.whiteColor
        setupNavigationButtons(for: vc)
    }

    // MARK: - Navigation Buttons
    private func setupNavigationButtons(for vc: PaywallThreeViewController) {
        setupCustomButton(
            imageName: "cross_icon",
            action: #selector(PaywallThreeViewController.customBackButtonTapped),
            isRight: true,
            in: vc
        )
    }

    private func setupCustomButton(imageName: String? = nil, title: String? = nil, action: Selector, isRight: Bool, in vc: PaywallThreeViewController) {
        let button = UIButton(type: .system)
        if let imageName = imageName {
            button.setImage(UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate), for: .normal)
            button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            button.tintColor = Colors.navigationItemsTintColor
        } else if let title = title {
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = FontHelper.font(.regular, size: 12)
            button.setTitleColor(Colors.mainTextColor, for: .normal)
        }
        button.alpha = 0
        button.addTarget(vc, action: action, for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: button)
        if isRight {
            vc.navigationItem.rightBarButtonItem = barButton
        } else {
            vc.navigationItem.leftBarButtonItem = barButton
        }
        UIView.animate(withDuration: 0.5, delay: 4.0) {
            button.alpha = 0.6
        }
    }
}
