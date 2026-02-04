//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import Foundation

class IPAddressManager {
    static let shared = IPAddressManager()

    private init() {}

    func fetchIPAddress(completion: @escaping (String?) -> Void) {
        let url = URL(string: "https://api.ipify.org?format=json")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let ip = json["ip"] as? String {
                completion(ip)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
}
