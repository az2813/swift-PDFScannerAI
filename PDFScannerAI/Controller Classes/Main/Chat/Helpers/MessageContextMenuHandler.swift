//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import Foundation
import UIKit

class MessageContextMenuHandler: NSObject {
    weak var viewController: UIViewController?
    private var message: ChatDisplayMessage?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    func attach(to view: UIView, for message: ChatDisplayMessage) {
        self.message = message
        view.interactions
            .filter { $0 is UIContextMenuInteraction }
            .forEach { view.removeInteraction($0) }

        let interaction = UIContextMenuInteraction(delegate: self)
        view.addInteraction(interaction)
    }
}

extension MessageContextMenuHandler: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        guard let message = message else { return nil }

        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let copy = UIAction(title: "Copy", image: UIImage(systemName: "doc.on.doc")) { _ in
                UIPasteboard.general.string = message.text
            }

            let share = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { [weak self] _ in
                guard let vc = self?.viewController else { return }
                let activityVC = UIActivityViewController(activityItems: [message.text], applicationActivities: nil)
                vc.present(activityVC, animated: true)
            }

            return UIMenu(title: "", children: [copy, share])
        }
    }
}
