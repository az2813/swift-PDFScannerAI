//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import UIKit

final class ChatTableViewHandler: NSObject, UITableViewDataSource, UITableViewDelegate {
    private let tableView: UITableView
    private let viewModel: ChatViewModel
    private weak var viewController: ChatViewController?
    private var contextMenuHandlers: [IndexPath: MessageContextMenuHandler] = [:]

    init(tableView: UITableView, viewModel: ChatViewModel, viewController: ChatViewController) {
        self.tableView = tableView
        self.viewModel = viewModel
        self.viewController = viewController
        super.init()
        setupTableView()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(SentMessageCell.self, forCellReuseIdentifier: "SentMessageCell")
        tableView.register(ReceivedChatMessageCell.self, forCellReuseIdentifier: "ReceivedChatMessageCell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = viewModel.messages[indexPath.row]
        switch message.type {
        case .user:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SentMessageCell", for: indexPath) as! SentMessageCell
            cell.configure(with: message)
            attachContextMenu(to: cell.contentView, at: indexPath, message: message)
            return cell
        case .ai:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReceivedChatMessageCell", for: indexPath) as! ReceivedChatMessageCell
            let attributedText = MarkdownParserManager.shared.parse(message.text)
            cell.configure(with: attributedText)
            attachContextMenu(to: cell.messageHolder, at: indexPath, message: message)
            return cell
        }
    }

    private func attachContextMenu(to view: UIView, at indexPath: IndexPath, message: ChatDisplayMessage) {
        guard let vc = viewController else { return }
        let handler = MessageContextMenuHandler(viewController: vc)
        handler.attach(to: view, for: message)
        contextMenuHandlers[indexPath] = handler
    }
}
