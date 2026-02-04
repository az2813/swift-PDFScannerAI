//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import UIKit

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var mainContainerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var inputContainerView: UIView!
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var summaryButton: UIButton!
    @IBOutlet weak var keyPointsButton: UIButton!
    @IBOutlet weak var aiButton: UIButton!
    
    var keyboardManager: KeyboardManager?
    var isKeyboardVisible = false
    var interactionHelper: ChatInteractionHelper!
    private var tableHandler: ChatTableViewHandler!

    // MARK: - Injected ViewModel
    var viewModel: ChatViewModel!

    func configure(with viewModel: ChatViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let configurator = ChatUIConfigurator(viewController: self)
        configurator.configureUI()

        interactionHelper = ChatInteractionHelper(viewController: self, viewModel: viewModel)
        bindViewModel()
        configurator.configureTextView()
        tableHandler = ChatTableViewHandler(tableView: tableView, viewModel: viewModel, viewController: self)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        TextViewUtility.centerVerticalText(in: inputTextView)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Actions
    @IBAction func sendMessage(_ sender: UIButton) {
        interactionHelper.handleSendButton(sender)
    }

    @IBAction func summarizeFile(_ sender: UIButton) {
        interactionHelper.handleSummaryButton(sender)
    }

    @IBAction func keyPointsFile(_ sender: UIButton) {
        interactionHelper.handleKeyPointsButton(sender)
    }

    @IBAction func aiFile(_ sender: UIButton) {
        interactionHelper.handleAIButton(sender)
    }
}

// MARK: - Binding
extension ChatViewController {
    private func bindViewModel() {

        viewModel.onMessagesUpdated = { [weak self] in
            guard let self = self else { return }

            let oldCount = self.tableView.numberOfRows(inSection: 0)
            let newCount = self.viewModel.messages.count

            if newCount > oldCount {
                let insertedIndexes = (oldCount..<newCount).map { IndexPath(row: $0, section: 0) }
                self.tableView.insertRows(at: insertedIndexes, with: .fade)

            } else if newCount < oldCount {
                let removedIndexes = (newCount..<oldCount).map { IndexPath(row: $0, section: 0) }
                self.tableView.deleteRows(at: removedIndexes, with: .fade)

            } else {
                let indexPath = IndexPath(row: newCount - 1, section: 0)
                self.tableView.reloadRows(at: [indexPath], with: .fade)
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.interactionHelper.scrollToLastMessage()
            }
        }

        viewModel.onLoadingTextUpdated = { [weak self] updatedText in
            guard let self = self else { return }
            let lastIndex = self.viewModel.messages.count - 1
            guard lastIndex >= 0 else { return }

            let indexPath = IndexPath(row: lastIndex, section: 0)
            if let cell = self.tableView.cellForRow(at: indexPath) as? ReceivedChatMessageCell {
                DispatchQueue.main.async {
                    cell.updateMessageText(updatedText)
                }
            }
        }

        viewModel.onErrorOccurred = { errorMessage in
            print("AI Error: \(errorMessage)")
        }

        tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.interactionHelper.scrollToLastMessage()
        }
    }
}

// MARK: - UITextViewDelegate
extension ChatViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        PlaceholderManager.clearIfNeeded(
            textView,
            placeholder: ChatUIConfigurator.placeholderText,
            placeholderColor: ChatUIConfigurator.placeholderTextColor,
            activeColor: Colors.mainTextColor
        )
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        PlaceholderManager.restoreIfNeeded(
            textView,
            placeholder: ChatUIConfigurator.placeholderText,
            placeholderColor: ChatUIConfigurator.placeholderTextColor
        )
    }

    func textViewDidChange(_ textView: UITextView) {
        interactionHelper.adjustContainerHeight()
        TextViewUtility.centerVerticalText(in: inputTextView)
    }
}

// MARK: - Keyboard Handling
extension ChatViewController {
    @objc private func handleKeyboardShow() {
        isKeyboardVisible = true
        isModalInPresentation = true
    }

    @objc private func handleKeyboardHide() {
        isKeyboardVisible = false
        isModalInPresentation = false
    }
}
