//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import Foundation
import UIKit

class OnboardingViewModel {
    private var onboardingItems: [OnboardingItem] = [
        OnboardingItem(
            imageName: "onb_1_image",
            title: "Scan PDFs in Seconds",
            subtitle: "Snap, import, and create clean, searchable PDFs fast",
            sliderImageName: "slider_1_image"
        ),
        OnboardingItem(
            imageName: "onb_2_image",
            title: "Chat with Your Documents",
            subtitle: "Ask questions, get summaries and find answers instantly",
            sliderImageName: "slider_2_image"
        ),
        OnboardingItem(
            imageName: "onb_3_image",
            title: "Extract Text with AI",
            subtitle: "Copy, edit and share text from scans in one tap",
            sliderImageName: "slider_3_image"
        ),
        OnboardingItem(
            imageName: "onb_4_image",
            title: "Organize and Share Easily",
            subtitle: "Keep files tidy, sync across devices and share securely",
            sliderImageName: "slider_4_image"
        )
    ]
    
    var currentIndex = 0

    var onOnboardingComplete: (() -> Void)?
    var onPaywallRequired: (() -> Void)?
    
    var currentOnboardingItem: OnboardingItem {
        return onboardingItems[currentIndex]
    }
    
    var isLastItem: Bool {
        return currentIndex == onboardingItems.count - 1
    }
    
    func nextOnboardingItem() -> Bool {
        currentIndex += 1
        return currentIndex >= onboardingItems.count
    }

    func completeOnboarding() {
        UserDefaultsHelper.setOnboardingCompleted(true)
        checkSubscriptionStatus()
    }

    private func checkSubscriptionStatus() {
        SubscriptionManager.shared.checkSubscriptionStatus { [weak self] isSubscribed in
            if isSubscribed {
                self?.onOnboardingComplete?()
            } else {
                self?.onPaywallRequired?()
            }
        }
    }
}
