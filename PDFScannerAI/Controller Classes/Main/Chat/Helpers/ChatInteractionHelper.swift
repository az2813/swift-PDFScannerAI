//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import UIKit

final class ChatInteractionHelper {
    private weak var viewController: ChatViewController?
    private let viewModel: ChatViewModel

    init(viewController: ChatViewController, viewModel: ChatViewModel) {
        self.viewController = viewController
        self.viewModel = viewModel
    }

    // MARK: - Button Actions
    @objc func handleSendButton(_ sender: UIButton) {
        AnimationUtility.animateButtonPress(sender) { [weak self] in
            guard let self = self, let vc = self.viewController else { return }
            let text = vc.inputTextView.text ?? ""
            let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
            let message = (self.viewModel.canSendMessage(trimmed) && !PlaceholderManager.isPlaceholderVisible(vc.inputTextView, placeholder: ChatUIConfigurator.placeholderText, placeholderColor: ChatUIConfigurator.placeholderTextColor)) ? trimmed : nil
            vc.view.endEditing(true)
            self.resetInput()
            self.viewModel.processInput(text: message) {}
        }
    }

    @objc func handleSummaryButton(_ sender: UIButton) {
        insertPrompt(ChatViewModel.summaryPrompt)
    }

    @objc func handleKeyPointsButton(_ sender: UIButton) {
        insertPrompt(ChatViewModel.keyPointsPrompt)
    }

    @objc func handleAIButton(_ sender: UIButton) {
        insertPrompt(ChatViewModel.aiPrompt)
    }

    // MARK: - UI Helpers
    func adjustContainerHeight() {
        guard let vc = viewController else { return }
        let newHeight = TextViewHeightManager.adjustHeight(
            for: vc.inputTextView,
            minHeight: ChatUIConfigurator.minInputTextViewHeight,
            maxHeight: ChatUIConfigurator.maxInputTextViewHeight,
            defaultHeight: ChatUIConfigurator.defaultMainContainerViewHeight
        )
        vc.mainContainerViewHeightConstraint.constant = newHeight
        vc.view.layoutIfNeeded()
    }

    func resetInput() {
        guard let vc = viewController else { return }
        PlaceholderManager.apply(
            to: vc.inputTextView,
            placeholder: ChatUIConfigurator.placeholderText,
            color: ChatUIConfigurator.placeholderTextColor
        )
        adjustContainerHeight()
    }

    func insertPrompt(_ prompt: String) {
        guard let vc = viewController else { return }
        vc.inputTextView.text = prompt
        vc.inputTextView.textColor = Colors.mainTextColor
        adjustContainerHeight()
        TextViewUtility.centerVerticalText(in: vc.inputTextView)
        if !vc.isKeyboardVisible {
            vc.inputTextView.becomeFirstResponder()
        }
    }

    func scrollToLastMessage() {
        guard let vc = viewController else { return }
        let count = viewModel.messages.count
        guard count > 0 else { return }
        let indexPath = IndexPath(row: count - 1, section: 0)
        vc.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}
