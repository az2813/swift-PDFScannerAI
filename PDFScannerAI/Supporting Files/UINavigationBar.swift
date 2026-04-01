//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import Foundation
import UIKit

extension UINavigationBar {
    static func setupTransparentAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.shadowImage = UIImage()
        appearance.shadowColor = nil
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        if let backImage = UIImage(named: "back_icon") {
            let insetImage = backImage.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
            appearance.setBackIndicatorImage(insetImage, transitionMaskImage: insetImage)
        }

        let backButtonAppearance = UIBarButtonItemAppearance(style: .plain)
        backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
        appearance.backButtonAppearance = backButtonAppearance
        
        let buttonAppearance = UIBarButtonItemAppearance()
        buttonAppearance.normal.backgroundImage = UIImage()
        buttonAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.label
        ]

        appearance.buttonAppearance = buttonAppearance
        appearance.doneButtonAppearance = buttonAppearance

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().tintColor = Colors.navigationItemsTintColor
    }
}
