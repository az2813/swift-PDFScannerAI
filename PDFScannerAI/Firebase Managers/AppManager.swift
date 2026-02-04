//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class AppManager {
    static let shared = AppManager()

    private init() {}

    func registerUserAndFetchIP(completion: @escaping (Result<(userID: String, ipAddress: String, deviceInfo: [String: Any]), Error>) -> Void) {
        AuthManager.shared.getCurrentUserUID { [weak self] result in
            switch result {
            case .success(let userID):
                IPAddressManager.shared.fetchIPAddress { ipAddress in
                    if let ipAddress = ipAddress {
                        let deviceInfo = DeviceInfoManager.shared.fetchDeviceInfo()
                        self?.storeUserDetails(userID: userID, ipAddress: ipAddress, deviceInfo: deviceInfo)
                        completion(.success((userID: userID, ipAddress: ipAddress, deviceInfo: deviceInfo)))
                    } else {
                        completion(.failure(NSError(domain: "AppManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch IP address."])))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func storeUserDetails(userID: String, ipAddress: String, deviceInfo: [String: Any]) {
        let databaseRef = Database.database(url: Constants.databaseURL).reference()
        let userRef = databaseRef.child("users").child(userID)

        let userDetails: [String: Any] = [
            "ipAddress": ipAddress,
            "deviceInfo": deviceInfo
        ]

        userRef.updateChildValues(userDetails) { error, _ in
            if let error = error {
                print("Error updating user details: \(error.localizedDescription)")
            } else {
                print("Successfully updated user details for userID: \(userID)")
            }
        }
    }
}
