//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import UIKit

final class PaywallOneUIConfigurator {
    func configureUI(for viewController: PaywallOneViewController) {
        let vc = viewController
        vc.view.backgroundColor = Colors.whiteColor

        setupNavigationButtons(for: vc)

        vc.titleLabel.font = FontHelper.font(.bold, size: 32)
        vc.titleLabel.textColor = Colors.blueColor

        vc.subtitleLabel.font = FontHelper.font(.semiBold, size: 18)
        vc.subtitleLabel.textColor = Colors.mainTextColor

        vc.priceLabel.font = FontHelper.font(.medium, size: 14)
        vc.priceLabel.textColor = Colors.secondaryTextColor

        vc.subscribeButton.titleLabel?.font = FontHelper.font(.bold, size: 16)
        RoundedStyleUtility.apply(to: vc.subscribeButton, cornerRadius: 16, backgroundColor: Colors.blueColor, titleTextColor: Colors.whiteColor)

        vc.privacyButton.titleLabel?.font = FontHelper.font(.regular, size: 12)
        vc.privacyButton.setTitleColor(Colors.mainTextColor, for: .normal)
        vc.termsButton.titleLabel?.font = FontHelper.font(.regular, size: 12)
        vc.termsButton.setTitleColor(Colors.mainTextColor, for: .normal)
        vc.separatorLabel.font = FontHelper.font(.black, size: 12)
        vc.separatorLabel.textColor = Colors.secondaryTextColor

        vc.view.bringSubviewToFront(vc.titleLabel)
        vc.view.bringSubviewToFront(vc.subtitleLabel)
        vc.view.bringSubviewToFront(vc.priceLabel)
        vc.view.bringSubviewToFront(vc.subscribeButton)
        vc.view.bringSubviewToFront(vc.privacyButton)
        vc.view.bringSubviewToFront(vc.termsButton)
        vc.view.bringSubviewToFront(vc.separatorLabel)
    }

    // MARK: - Navigation Buttons
    private func setupNavigationButtons(for vc: PaywallOneViewController) {
        setupCustomButton(
            imageName: "cross_icon",
            action: #selector(PaywallOneViewController.customBackButtonTapped),
            isRight: true,
            in: vc
        )
        setupCustomButton(
            title: "Restore",
            action: #selector(PaywallOneViewController.restorePurchasesTapped),
            isRight: false,
            in: vc
        )
    }

    private func setupCustomButton(imageName: String? = nil, title: String? = nil, action: Selector, isRight: Bool, in vc: PaywallOneViewController) {
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
            button.alpha = 1.0
        }
    }
}
