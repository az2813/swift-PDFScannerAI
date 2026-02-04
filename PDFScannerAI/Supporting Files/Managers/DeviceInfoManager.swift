//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import Foundation
import UIKit
import SystemConfiguration.CaptiveNetwork
import CoreTelephony

class DeviceInfoManager {
    static let shared = DeviceInfoManager()

    private init() {}

    func fetchDeviceInfo() -> [String: Any] {
        var deviceInfo: [String: Any] = [:]
        
        // General Device Info
        deviceInfo["deviceName"] = UIDevice.current.name
        deviceInfo["deviceModel"] = UIDevice.current.model
        deviceInfo["systemName"] = UIDevice.current.systemName
        deviceInfo["systemVersion"] = UIDevice.current.systemVersion
        
        // Network Info
        deviceInfo["wifiSSID"] = getWiFiSSID() ?? "Unknown"
        
        // Carrier Info
        let carrierInfo = getCarrierInfo()
        deviceInfo["carrierName"] = carrierInfo["carrierName"]
        deviceInfo["mobileCountryCode"] = carrierInfo["mobileCountryCode"]
        deviceInfo["mobileNetworkCode"] = carrierInfo["mobileNetworkCode"]

        // Time & Locale
        deviceInfo["timeZone"] = TimeZone.current.identifier
        deviceInfo["locale"] = Locale.current.identifier
        
        return deviceInfo
    }

    // MARK: - Network Information
    private func getWiFiSSID() -> String? {
        guard let interfaces = CNCopySupportedInterfaces() as? [String],
              let interfaceName = interfaces.first,
              let info = CNCopyCurrentNetworkInfo(interfaceName as CFString) as? [String: Any] else { return nil }
        return info["SSID"] as? String
    }

    private func getCarrierInfo() -> [String: String] {
        let networkInfo = CTTelephonyNetworkInfo()
        if let carrier = networkInfo.serviceSubscriberCellularProviders?.values.first {
            return [
                "carrierName": carrier.carrierName ?? "Unknown",
                "mobileCountryCode": carrier.mobileCountryCode ?? "Unknown",
                "mobileNetworkCode": carrier.mobileNetworkCode ?? "Unknown"
            ]
        }
        return ["carrierName": "Unknown", "mobileCountryCode": "Unknown", "mobileNetworkCode": "Unknown"]
    }
}
