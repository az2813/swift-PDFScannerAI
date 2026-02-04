//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import Foundation
import UIKit

struct SettingsSection {
    let title: String?
    let options: [SettingsOption]
}

struct SettingsOption {
    let icon: UIImage
    let title: String
    let isToggle: Bool
    let isPremium: Bool
    let action: (() -> Void)?
}
