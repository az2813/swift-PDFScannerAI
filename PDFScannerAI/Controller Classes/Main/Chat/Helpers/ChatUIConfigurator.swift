//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import UIKit

final class ChatUIConfigurator {
    static let defaultMainContainerViewHeight: CGFloat = 88.0
    static let maxInputTextViewHeight: CGFloat = 160.0
    static let minInputTextViewHeight: CGFloat = 56.0
    static let placeholderText = "Ask anything..."
    static let placeholderTextColor = Colors.secondaryTextColor

    private weak var viewController: ChatViewController?

    init(viewController: ChatViewController) {
        self.viewController = viewController
    }

    func configureUI() {
        guard let vc = viewController else { return }
        vc.view.backgroundColor = Colors.secondaryBackgroundColor
        ChatNavigationBarHelper.configureNavigationBar(for: vc, fileName: vc.viewModel.fileName)

        RoundedStyleUtility.apply(
            to: vc.mainContainerView,
            cornerRadius: 24,
            backgroundColor: Colors.whiteColor
        )

        RoundedStyleUtility.apply(
            to: vc.inputContainerView,
            cornerRadius: vc.inputContainerView.frame.height/2,
            backgroundColor: .clear,
            borderColor: Colors.strokeColor,
            borderWidth: 2.0
        )

        vc.summaryButton.titleLabel?.font = FontHelper.font(.semiBold, size: 16)
        RoundedStyleUtility.apply(
            to: vc.summaryButton,
            cornerRadius: 16,
            backgroundColor: Colors.blueColor,
            titleTextColor: Colors.whiteColor
        )

        vc.keyPointsButton.titleLabel?.font = FontHelper.font(.semiBold, size: 16)
        RoundedStyleUtility.apply(
            to: vc.keyPointsButton,
            cornerRadius: 16,
            backgroundColor: Colors.blueColor,
            titleTextColor: Colors.whiteColor
        )

        vc.aiButton.titleLabel?.font = FontHelper.font(.semiBold, size: 16)
        RoundedStyleUtility.apply(
            to: vc.aiButton,
            cornerRadius: 16,
            backgroundColor: Colors.blueColor,
            titleTextColor: Colors.whiteColor
        )
        
        RoundedStyleUtility.apply(
            to: vc.sendButton,
            cornerRadius: vc.sendButton.frame.height/2,
            backgroundColor: Colors.blueColor,
            tintColor: Colors.whiteColor
        )

        vc.keyboardManager = KeyboardManager(
            view: vc.view,
            bottomConstraint: vc.bottomConstraint,
            scrollView: vc.tableView
        )
        vc.keyboardManager?.onKeyboardChanged = { [weak vc] in
            vc?.interactionHelper.scrollToLastMessage()
        }
    }

    func configureTextView() {
        guard let vc = viewController else { return }
        PlaceholderManager.apply(
            to: vc.inputTextView,
            placeholder: ChatUIConfigurator.placeholderText,
            color: ChatUIConfigurator.placeholderTextColor
        )
        vc.inputTextView.delegate = vc
        vc.inputTextView.font = FontHelper.font(.medium, size: 16)
    }
}
