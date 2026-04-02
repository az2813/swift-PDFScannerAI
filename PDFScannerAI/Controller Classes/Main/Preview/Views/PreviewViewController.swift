//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import UIKit
import PDFKit

final class PreviewViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var switcherView: UIView!
    @IBOutlet weak var fileButton: UIButton!
    @IBOutlet weak var chatsButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomSupportView: UIView!
    @IBOutlet weak var bottomHolderView: UIView!
    @IBOutlet weak var messageContainer: UIView!
    @IBOutlet weak var messageContainerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var contentHolderView: UIView!
    
    var keyboardManager: KeyboardManager?
    var isKeyboardVisible = false
    let viewModel = PreviewViewModel()
    private var interactionHelper: PreviewInteractionHelper!
    private var tableHelper: PreviewChatsTableViewHelper!
    var pdfView: PDFView?
    var didRenamePDF: ((String, String) -> Void)? = nil
    var isFromAddCar: Bool = false
    var isTitleEditable: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        let configurator = PreviewUIConfigurator(viewController: self)
        configurator.configureUI()
        interactionHelper = PreviewInteractionHelper(viewController: self, viewModel: viewModel)
        tableHelper = PreviewChatsTableViewHelper(tableView: tableView, viewModel: viewModel, viewController: self)

        bindViewModel()

        fileButton.addTarget(self, action: #selector(handleFileButton), for: .touchUpInside)
        chatsButton.addTarget(self, action: #selector(handleChatsButton), for: .touchUpInside)

        contentHolderView.isHidden = false
        tableView.isHidden = true

        viewModel.fetchChats()

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

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleChatsUpdated),
            name: .chatsUpdated,
            object: nil
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
        viewModel.fetchChats()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        TextViewUtility.centerVerticalText(in: inputTextView)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func bindViewModel() {
        viewModel.onChatsUpdated = { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
            let enabled = !self.viewModel.chats.isEmpty
            self.chatsButton.isEnabled = enabled
            if self.tableView.isHidden {
                self.chatsButton.alpha = 0.2
            } else {
                self.chatsButton.alpha = 1.0
                self.fileButton.alpha = 0.2
            }
        }
    }

    @IBAction func sendMessage(_ sender: Any) {
        AnimationUtility.animateButtonPress(sendButton) { [weak self] in
            self?.interactionHelper.sendMessage()
        }
    }

    @objc private func handleFileButton() {
        contentHolderView.isHidden = false
        tableView.isHidden = true
        fileButton.alpha = 1.0
        chatsButton.alpha = 0.2
    }

    @objc private func handleChatsButton() {
        contentHolderView.isHidden = true
        tableView.isHidden = false
        chatsButton.alpha = 1.0
        fileButton.alpha = 0.2
    }

    func resetInput() {
        PlaceholderManager.apply(to: inputTextView, placeholder: PreviewUIConfigurator.placeholderText, color: PreviewUIConfigurator.placeholderTextColor)
        updateMessageContainerHeight()
        updateSendButtonState()
    }

    private func configureNavigationBar() {
        PreviewNavigationBarHelper.configureNavigationBar(
            for: self,
            fileName: viewModel.fileName,
            tapTarget: self,
            tapAction: #selector(handleTitleTap),
            doneTarget: self,
            doneAction: #selector(handleDoneButton),
            isTitleEditable: isTitleEditable
        )
    }

    @objc private func handleTitleTap() {
        InputAlertHelper.showInputAlert(
            from: self,
            title: "Edit File Name",
            message: nil,
            textFieldPlaceholder: "File Name",
            textFieldDefaultValue: viewModel.fileName,
            confirmButtonTitle: "OK",
            cancelButtonTitle: "Cancel"
        ) { [weak self] newName in
            guard let self = self, let name = newName, !name.isEmpty else { return }
            let oldName = self.viewModel.fileName
            if self.viewModel.renamePDF(to: name) {
                FileChatManager.shared.renameDocument(oldName: oldName, newName: name)
                self.configureNavigationBar()
                self.didRenamePDF?(oldName, name)
            }
        }
    }

    @objc private func handleDoneButton() {
        if isFromAddCar == false {
            navigationController?.popToRootViewController(animated: true)
        } else {
            if let viewControllers = navigationController?.viewControllers, let viewController = viewControllers.first(where: { viewController in
                return viewController is AddCarViewController
            }) {
                navigationController?.popToViewController(viewController, animated: true)
            } else {
                navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}

// MARK: - UI Setup
extension PreviewViewController {
    func updateMessageContainerHeight() {
        messageContainerViewHeightConstraint.constant = TextViewHeightManager.adjustHeight(
            for: inputTextView,
            minHeight: PreviewUIConfigurator.minInputTextViewHeight,
            maxHeight: PreviewUIConfigurator.maxInputTextViewHeight,
            defaultHeight: PreviewUIConfigurator.defaultMainContainerViewHeight
        )
        TextViewUtility.centerVerticalText(in: inputTextView)
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
    }

    private func updateSendButtonState() {
        let isEnabled = !PlaceholderManager.isPlaceholderVisible(
            inputTextView,
            placeholder: PreviewUIConfigurator.placeholderText,
            placeholderColor: PreviewUIConfigurator.placeholderTextColor
        ) && viewModel.canSendMessage(inputTextView.text)
        sendButton.isEnabled = isEnabled
        sendButton.alpha = isEnabled ? 1.0 : 0.5
    }
    
}

// MARK: - UITextViewDelegate
extension PreviewViewController {
    func textViewDidBeginEditing(_ textView: UITextView) {
        PlaceholderManager.clearIfNeeded(
            textView,
            placeholder: PreviewUIConfigurator.placeholderText,
            placeholderColor: PreviewUIConfigurator.placeholderTextColor,
            activeColor: Colors.mainTextColor
        )
        updateSendButtonState()
    }

    func textViewDidChange(_ textView: UITextView) {
        updateMessageContainerHeight()
        updateSendButtonState()
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        PlaceholderManager.restoreIfNeeded(textView, placeholder: PreviewUIConfigurator.placeholderText, placeholderColor: PreviewUIConfigurator.placeholderTextColor)
        updateMessageContainerHeight()
        updateSendButtonState()
    }
}

// MARK: - Keyboard Handling
extension PreviewViewController {
    @objc private func handleKeyboardShow() {
        isKeyboardVisible = true
        isModalInPresentation = true
    }

    @objc private func handleKeyboardHide() {
        isKeyboardVisible = false
        isModalInPresentation = false
    }
}

// MARK: - Notifications
extension PreviewViewController {
    @objc private func handleChatsUpdated() {
        viewModel.fetchChats()
    }
}
