//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import Foundation
import UIKit

class AlertHelper {
    /// Presents an alert with the given configuration.
    ///
    /// - Parameters:
    ///   - viewController: The view controller to present the alert on.
    ///   - title: The title of the alert (optional).
    ///   - message: The message of the alert (optional).
    ///   - actions: An array of `UIAlertAction` to be added to the alert.
    ///   - preferredStyle: The preferred style of the alert (e.g., `.alert` or `.actionSheet`). Defaults to `.alert`.
    static func showAlert(on viewController: UIViewController,
                          title: String? = nil,
                          message: String? = nil,
                          actions: [UIAlertAction],
                          preferredStyle: UIAlertController.Style = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        actions.forEach { alertController.addAction($0) }
        viewController.present(alertController, animated: true, completion: nil)
    }
}
