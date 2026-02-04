//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import UIKit

final class EditorUIConfigurator {
    func configureUI(for viewController: EditorViewController) {
        let vc = viewController

        vc.view.backgroundColor = Colors.backgroundColor
        RoundedStyleUtility.apply(to: vc.contentView, backgroundColor: Colors.whiteColor)
        
        RoundedStyleUtility.apply(to: vc.countView, cornerRadius: 12, backgroundColor: Colors.whiteColor)
        RoundedStyleUtility.apply(to: vc.removePageButton, cornerRadius: 12, backgroundColor: Colors.whiteColor, tintColor: Colors.redColor)
        RoundedStyleUtility.apply(to: vc.rotateButton, cornerRadius: 12, backgroundColor: Colors.whiteColor, tintColor: Colors.navigationItemsTintColor)
        
        vc.pageCountLabel.font = FontHelper.font(.semiBold, size: 12)
        
        RoundedStyleUtility.apply(to: vc.optionsView, cornerRadius: 16, backgroundColor: .clear)
        vc.optionsView.isHidden = true

        Self.filterButtons(for: vc).forEach { button in
            button.titleLabel?.font = FontHelper.font(.bold, size: 10)
            button.setTitleColor(Colors.blueColor, for: .normal)
            RoundedStyleUtility.apply(to: button, cornerRadius: 12, borderColor: UIColor.clear, borderWidth: 0)
        }

        Self.bottomItems(for: vc).forEach { view, icon, label in
            RoundedStyleUtility.apply(to: view, cornerRadius: 16, backgroundColor: Colors.whiteColor)
            icon.tintColor = Colors.blueColor
            label.font = FontHelper.font(.bold, size: 10)
            label.textColor = Colors.blueColor
        }

        RoundedStyleUtility.apply(to: vc.saveView, cornerRadius: 16, backgroundColor: Colors.greenColor)
        vc.saveIcon.tintColor = Colors.whiteColor
        vc.saveLabel.font = FontHelper.font(.bold, size: 10)
        vc.saveLabel.textColor = Colors.whiteColor
    }

    func setupBackground(for viewController: EditorViewController) {
        let vc = viewController
        vc.backgroundImageView = UIImageView(frame: vc.contentView.bounds)
        vc.backgroundImageView.contentMode = .scaleAspectFill
        vc.backgroundImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        vc.backgroundImageView.clipsToBounds = true
        vc.backgroundImageView.backgroundColor = .clear
        vc.contentView.insertSubview(vc.backgroundImageView, at: 0)

        let blurEffect = UIBlurEffect(style: .regular)
        vc.blurView = UIVisualEffectView(effect: blurEffect)
        vc.blurView.frame = vc.contentView.bounds
        vc.blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        vc.contentView.insertSubview(vc.blurView, aboveSubview: vc.backgroundImageView)
    }

    func setupScrollView(for viewController: EditorViewController) {
        let vc = viewController
        vc.scrollView = UIScrollView(frame: vc.contentView.bounds)
        vc.scrollView.showsVerticalScrollIndicator = true
        vc.scrollView.isPagingEnabled = true
        vc.scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        vc.scrollView.delegate = vc
        vc.scrollView.backgroundColor = .clear
        vc.contentView.backgroundColor = .clear
        vc.contentView.insertSubview(vc.scrollView, aboveSubview: vc.blurView)
    }
    
    static func filterButtons(for vc: EditorViewController) -> [UIButton] {
        [vc.enhanceButton,
         vc.contrastBwButton,
         vc.softBwButton,
         vc.sharpenBwButton,
         vc.originalButton]
            .compactMap { $0 }
    }

    static func bottomItems(for vc: EditorViewController) -> [(UIView, UIImageView, UILabel)] {
        [
            (vc.filtersView, vc.filtersIcon, vc.filtersLabel),
            (vc.contrastView, vc.contrastIcon, vc.contrastLabel),
            (vc.brightnessView, vc.brightnessIcon, vc.brightnessLabel),
            (vc.addPageView, vc.addPageIcon, vc.addPageLabel),
            (vc.saveView, vc.saveIcon, vc.saveLabel)
        ]
    }
}
