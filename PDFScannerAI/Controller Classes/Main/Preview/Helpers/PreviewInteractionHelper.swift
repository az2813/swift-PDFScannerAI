//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import UIKit
import Foundation

final class PreviewInteractionHelper {
    private weak var viewController: PreviewViewController?
    private let viewModel: PreviewViewModel

    init(viewController: PreviewViewController, viewModel: PreviewViewModel) {
        self.viewController = viewController
        self.viewModel = viewModel
    }

    func sendMessage() {
        guard let vc = viewController else { return }
        let text = vc.inputTextView.text ?? ""
        guard let chatViewModel = viewModel.createChatViewModel(with: text) else { return }
        vc.resetInput()

        NavigationManager.shared.transitionToConfiguredViewController(
            identifier: "ChatViewController",
            from: vc,
            presentationStyle: .pageSheet,
            useNavigationController: true,
            detents: [.large()]
        ) { viewController in
            (viewController as? ChatViewController)?.configure(with: chatViewModel)
        }
    }

}
