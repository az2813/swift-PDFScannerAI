//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import Foundation
import FirebaseRemoteConfig

class RemoteConfigManager {
    static let shared = RemoteConfigManager()
    
    private let remoteConfig: RemoteConfig
    
    private init() {
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings

        remoteConfig.setDefaults([
            "paywall_version": "default" as NSObject,
            "paywall_1_allow_close": true as NSObject,
            "paywall_2_allow_close": true as NSObject,
            "paywall_3_allow_close": true as NSObject,
            "paywall_4_allow_close": true as NSObject
        ])
    }
    
    func fetchConfig(completion: @escaping (Bool) -> Void) {
        remoteConfig.fetch { [weak self] status, error in
            guard status == .success else {
                print("Config fetch failed:", error?.localizedDescription ?? "Unknown error")
                completion(false)
                return
            }

            self?.remoteConfig.activate { _, error in
                if let error = error {
                    print("Activation error:", error)
                    completion(false)
                } else {
                    print("Remote Config Activated")
                    completion(true)
                }
            }
        }
    }

    func isCloseAllowed(forPaywall key: String) -> Bool {
        return remoteConfig.configValue(forKey: key).boolValue
    }

    func getString(forKey key: String) -> String? {
        return remoteConfig.configValue(forKey: key).stringValue
    }

    func getBool(forKey key: String) -> Bool {
        return remoteConfig.configValue(forKey: key).boolValue
    }

    func getNumber(forKey key: String) -> NSNumber? {
        return remoteConfig.configValue(forKey: key).numberValue
    }
}
