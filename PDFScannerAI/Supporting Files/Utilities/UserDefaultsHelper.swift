//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import Foundation
import UIKit

class UserDefaultsHelper {
    
    private static let onboardingCompletedKey = "isOnboardingCompleted"

    // MARK: - Onboarding

    static func setOnboardingCompleted(_ completed: Bool) {
        UserDefaults.standard.set(completed, forKey: onboardingCompletedKey)
    }

    static func isOnboardingCompleted() -> Bool {
        return UserDefaults.standard.bool(forKey: onboardingCompletedKey)
    }

    static func clearOnboardingStatus() {
        UserDefaults.standard.removeObject(forKey: onboardingCompletedKey)
    }
}
