import UIKit

final class PreviewChatsTableViewHelper: NSObject {
    private weak var tableView: UITableView?
    private weak var viewController: PreviewViewController?
    private let viewModel: PreviewViewModel
    
    init(tableView: UITableView, viewModel: PreviewViewModel, viewController: PreviewViewController) {
        self.tableView = tableView
        self.viewModel = viewModel
        self.viewController = viewController
        super.init()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 16, right: 0)
    }
}

extension PreviewChatsTableViewHelper: UITableViewDataSource, UITableViewDelegate, ChatTableCellDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfChats(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableCell", for: indexPath) as? ChatTableCell else {
            return UITableViewCell()
        }
        if let chat = viewModel.chat(at: indexPath), let document = viewModel.document {
            cell.configure(with: chat, document: document)
            cell.delegate = self
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = viewController else { return }
        // Find the original index in the flat chats array
        guard let chat = viewModel.chat(at: indexPath) else { return }
        let originalIndex = viewModel.chats.firstIndex { $0.created == chat.created } ?? 0
        let chatViewModel = viewModel.createChatHistoryViewModel(at: originalIndex)
        NavigationManager.shared.transitionToConfiguredViewController(
            identifier: "ChatViewController",
            from: vc,
            presentationStyle: .pageSheet,
            useNavigationController: true,
            detents: [.large()]
        ) { controller in
            (controller as? ChatViewController)?.configure(with: chatViewModel)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = viewModel.title(for: section)
        label.font = FontHelper.font(.semiBold, size: 16)
        label.textColor = Colors.mainTextColor
        headerView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 24),
            label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -24),
            label.topAnchor.constraint(equalTo: headerView.topAnchor),
            label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -4)
        ])
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let spacer = UIView()
        spacer.backgroundColor = .clear
        return spacer
    }
    
    func chatTableCell(_ cell: ChatTableCell, didTapMoreFor document: Document, chat: ChatHistory) {
        guard let indexPath = tableView?.indexPath(for: cell) else { return }
        showActionSheet(for: document, chat: chat, indexPath: indexPath)
    }
}

private extension PreviewChatsTableViewHelper {
    func showActionSheet(for document: Document, chat: ChatHistory, indexPath: IndexPath) {
        guard let vc = viewController else { return }
        
        let share = UIAlertAction(title: "Share chat", style: .default) { _ in
            let text = chat.messages.joined(separator: "\n")
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("Chat.txt")
            try? text.write(to: tempURL, atomically: true, encoding: .utf8)
            let activity = UIActivityViewController(activityItems: [tempURL], applicationActivities: nil)
            vc.present(activity, animated: true)
        }
        
        let delete = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.deleteChat(document: document, chat: chat)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        AlertHelper.showAlert(on: vc, actions: [share, delete, cancel], preferredStyle: .actionSheet)
    }
    
    func deleteChat(document: Document, chat: ChatHistory) {
        // Find the original index in the flat chats array
        guard let originalIndex = viewModel.chats.firstIndex(where: { $0.created == chat.created }) else { return }
        
        var allChats = viewModel.chats.map { $0.messages }
        guard allChats.indices.contains(originalIndex) else { return }
        allChats.remove(at: originalIndex)
        
        FileChatManager.shared.updateChats(fileName: document.fileName, chats: allChats) { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.fetchChats()
            DispatchQueue.main.async {
                self.tableView?.reloadData()
                let enabled = !self.viewModel.chats.isEmpty
                self.viewController?.chatsButton.isEnabled = enabled
                self.viewController?.chatsButton.alpha = enabled ? 1.0 : 0.2
            }
        }
    }
}

