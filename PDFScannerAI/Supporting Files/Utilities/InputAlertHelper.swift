//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import Foundation
import UIKit

class InputAlertHelper {
    static func showInputAlert(
        from viewController: UIViewController,
        title: String,
        message: String?,
        textFieldPlaceholder: String,
        textFieldDefaultValue: String?,
        confirmButtonTitle: String,
        cancelButtonTitle: String,
        confirmHandler: @escaping (String?) -> Void
    ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = textFieldPlaceholder
            textField.text = textFieldDefaultValue
        }
        
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: nil)
        
        let confirmAction = UIAlertAction(title: confirmButtonTitle, style: .default) { _ in
            let inputText = alertController.textFields?.first?.text
            confirmHandler(inputText)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
}
