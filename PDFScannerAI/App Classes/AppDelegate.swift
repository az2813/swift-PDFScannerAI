//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import UIKit
import Firebase
import Adapty
import ProgressHUD

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupWindow()
        setupAppearance()
        setupThirdPartyServices()
        registerUser()
        
        PurchaseManager.shared.completeTransactions()
        PurchaseManager.shared.retrievePrices(productIds: [UNLOCK_1WEEK_SUBSCRIPTION, UNLOCK_1MONTH_SUBSCRIPTION, UNLOCK_1YEAR_SUBSCRIPTION]) { products in
            print(products)
        }
        
        ProgressHUD.animationType = .barSweepToggle
        ProgressHUD.colorHUD = Colors.blueColor
        ProgressHUD.colorAnimation = .white

        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        PurchaseManager.shared.updateSubscriptionStatus()
    }

    // MARK: - Window & UI Setup
    private func setupWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
    }

    private func setupAppearance() {
        UINavigationBar.setupTransparentAppearance()
    }

    // MARK: - Third-Party SDKs
    private func setupThirdPartyServices() {
        FirebaseApp.configure()
        Firebase.Analytics.setAnalyticsCollectionEnabled(true)
        let configurationBuilder = AdaptyConfiguration.builder(withAPIKey: Constants.adaptyKey).with(observerMode: false)
        Adapty.activate(with: configurationBuilder.build()) { error in
            if let error = error {
                print("[Adapty] Activation error: \(error.localizedDescription)")
            } else {
                print("[Adapty] Activated successfully")
            }
        }
    }

    // MARK: - User Registration & IP Fetching
    private func registerUser() {
        AppManager.shared.registerUserAndFetchIP { result in
            switch result {
            case .success(let data):
                print("[User Registration] User ID: \(data.userID), IP Address: \(data.ipAddress)")
            case .failure(let error):
                print("[User Registration] Failed: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Scene Session Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        print("[Scene Lifecycle] Discarded sessions: \(sceneSessions.count)")
    }
}
