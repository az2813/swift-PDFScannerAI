//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import Foundation
import UIKit

class SettingsViewModel {
    
    var settingsSections: [SettingsSection] = []
    
    init() {
        settingsSections = [
            SettingsSection(
                title: "Premium",
                options: [
                    SettingsOption(
                        icon: UIImage(named: "crown_img")!,
                        title: "\(Constants.appName) Premium",
                        isToggle: false,
                        isPremium: true,
                        action: nil
                    )
                ]
            ),
            
            SettingsSection(
                title: "Legal Information",
                options: [
                    SettingsOption(
                        icon: UIImage(named: "privacy_img")!,
                        title: "Privacy Policy",
                        isToggle: false,
                        isPremium: false,
                        action: nil
                    ),
                    SettingsOption(
                        icon: UIImage(named: "terms_img")!,
                        title: "Terms of Use",
                        isToggle: false,
                        isPremium: false,
                        action: nil
                    )
                ]
            ),
            
            SettingsSection(
                title: "Support",
                options: [
                    SettingsOption(
                        icon: UIImage(named: "feedback_img")!,
                        title: "Contact Us",
                        isToggle: false,
                        isPremium: false,
                        action: nil
                    ),
                    SettingsOption(
                        icon: UIImage(named: "rate_img")!,
                        title: "Rate the App",
                        isToggle: false,
                        isPremium: false,
                        action: nil
                    )
                ]
            ),
            
            SettingsSection(
                title: "More",
                options: [
                    SettingsOption(
                        icon: UIImage(named: "apps_img")!,
                        title: "Other Apps",
                        isToggle: false,
                        isPremium: false,
                        action: nil
                    )
                ]
            )
        ]
    }
}
