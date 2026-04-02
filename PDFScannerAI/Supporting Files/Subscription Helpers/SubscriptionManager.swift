//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import Foundation
import Adapty

class SubscriptionManager {
    static let shared = SubscriptionManager()
    
    private init() {}

    func checkSubscriptionStatus(completion: @escaping (Bool) -> Void) {
        RemoteConfigManager.shared.fetchConfig { success in
            DispatchQueue.main.async {
                //completion(true)
                if RemoteConfigManager.shared.getBool(forKey: "appFree") {
                    completion(true)
                } else {
                    Adapty.getProfile { result in
                        if let profile = try? result.get(),
                           profile.accessLevels["premium"]?.isActive == true {
                            completion(true)
                        } else {
                            completion(PurchaseManager.shared.isPurchased())
                        }
                    }
                }
            }
        }
    }
}
