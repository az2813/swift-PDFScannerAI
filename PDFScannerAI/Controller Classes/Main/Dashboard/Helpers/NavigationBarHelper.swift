//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import Foundation
import UIKit

class NavigationBarHelper {
    static func configureNavigationBar(for viewController: UIViewController, isSubscribed: Bool, onPremiumTap: Selector, onMenuTap: Selector) {
        if #available(iOS 26.0, *) {
            viewController.navigationItem.titleView = createTitleLabel()
        } else {
            viewController.navigationItem.leftBarButtonItem = createTitleButtonItem()
        }
        
        var rightItems: [UIBarButtonItem] = [createMenuButton(target: viewController, action: onMenuTap)]
        if !isSubscribed {
            rightItems.append(createPremiumButton(target: viewController, action: onPremiumTap))
        }
        
        viewController.navigationItem.rightBarButtonItems = rightItems
    }

    static func createTitleLabel() -> UIView {
        let titleLabel = UILabel()
        let titleText = "PDF Scanner"
        let attributedTitle = NSMutableAttributedString(string: titleText)
        attributedTitle.addAttribute(.foregroundColor, value: Colors.blueColor, range: NSRange(location: 0, length: 3))
        attributedTitle.addAttribute(.foregroundColor, value: Colors.mainTextColor, range: NSRange(location: 3, length: titleText.count - 3))
        titleLabel.attributedText = attributedTitle
        titleLabel.font = FontHelper.font(.bold, size: 22)
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 1

        let subtitleLabel = UILabel()
        subtitleLabel.text = "AI-powered PDF scanning & chat"
        subtitleLabel.font = FontHelper.font(.semiBold, size: 12)
        subtitleLabel.textColor = Colors.grayColor
        subtitleLabel.textAlignment = .left
        subtitleLabel.numberOfLines = 1

        let mainStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        mainStack.axis = .vertical
        mainStack.alignment = .leading
        mainStack.spacing = 2

        let container = UIView()
        container.addSubview(mainStack)
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            mainStack.topAnchor.constraint(equalTo: container.topAnchor),
            mainStack.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        container.setNeedsLayout()
        container.layoutIfNeeded()
        container.frame = CGRect(origin: .zero, size: mainStack.intrinsicContentSize)
        container.backgroundColor = .clear
        return container
    }
    
    static func createTitleButtonItem() -> UIBarButtonItem {
        let titleLabel = UILabel()
        let titleText = "PDF Scanner"
        let attributedTitle = NSMutableAttributedString(string: titleText)
        attributedTitle.addAttribute(.foregroundColor, value: Colors.blueColor, range: NSRange(location: 0, length: 3))
        attributedTitle.addAttribute(.foregroundColor, value: Colors.mainTextColor, range: NSRange(location: 3, length: titleText.count - 3))
        titleLabel.attributedText = attributedTitle
        titleLabel.font = FontHelper.font(.bold, size: 22)
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 1

        let subtitleLabel = UILabel()
        subtitleLabel.text = "AI-powered PDF scanning & chat"
        subtitleLabel.font = FontHelper.font(.semiBold, size: 12)
        subtitleLabel.textColor = Colors.grayColor
        subtitleLabel.textAlignment = .left
        subtitleLabel.numberOfLines = 1

        let mainStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        mainStack.axis = .vertical
        mainStack.alignment = .leading
        mainStack.spacing = 2

        let container = UIView()
        container.addSubview(mainStack)
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            mainStack.topAnchor.constraint(equalTo: container.topAnchor),
            mainStack.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        container.setNeedsLayout()
        container.layoutIfNeeded()
        container.frame = CGRect(origin: .zero, size: mainStack.intrinsicContentSize)
        container.backgroundColor = .clear
        let buttonItem = UIBarButtonItem(customView: container)
        buttonItem.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        return buttonItem
    }

    static func createMenuButton(target: Any?, action: Selector) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "settings_icon")?.withRenderingMode(.alwaysTemplate).resized(to: CGSize(width: 24, height: 24)), for: .normal)
        button.tintColor = Colors.navigationItemsTintColor
        button.backgroundColor = Colors.secondaryBackgroundColor
        button.layer.cornerRadius = 20
        //button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 40),
            button.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        button.addTarget(target, action: action, for: .touchUpInside)
        
        return UIBarButtonItem(customView: button)
    }

    static func createPremiumButton(target: Any?, action: Selector) -> UIBarButtonItem {
        let label = PaddedLabel()
        label.text = "GET PRO"
        label.textColor = Colors.whiteColor
        label.font = FontHelper.font(.bold, size: 12)
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
