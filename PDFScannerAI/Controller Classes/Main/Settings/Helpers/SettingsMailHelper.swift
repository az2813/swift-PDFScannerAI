//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import UIKit
import MessageUI

final class SettingsMailHelper: NSObject, MFMailComposeViewControllerDelegate {
    func presentMailComposer(from viewController: UIViewController) {
        guard MFMailComposeViewController.canSendMail() else {
            print("Cannot send email. Please configure a mail account.")
            return
        }

        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setToRecipients([Constants.contactEmail])
        mailComposeVC.setSubject("\(Constants.appName) — Feedback & Support")
        mailComposeVC.setMessageBody("Hello,\n\nI have some feedback and a few questions about the app. Here are my comments:\n\n", isHTML: false)
        viewController.present(mailComposeVC, animated: true)
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
