//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import Foundation
import PDFKit

final class PreviewViewModel {
    private(set) var pdfDocument: PDFDocument?
    private(set) var pdfURL: URL?
    private(set) var fileName: String = ""
    private(set) var messages: [String] = []
    private(set) var chats: [ChatHistory] = []
    /// Sectioned chats grouped by date
    private(set) var sectionedChats: [(date: Date, items: [ChatHistory])] = []
    private(set) var document: Document?
    /// Called whenever chats are updated.
    var onChatsUpdated: (() -> Void)?

    func loadPDF(at url: URL) {
        pdfDocument = PDFDocument(url: url)
        pdfURL = url
        document = Document(fileURL: url)
    }
    
    func loadPDF(at url: URL, start: Int, count: Int) {
        pdfDocument = PDFDocument()
        if let pdf = PDFDocument(url: url) {
            for i in 0 ..< count {
                pdfDocument?.insert(pdf.page(at: i + start)!, at: i)
            }
        }
        pdfURL = url
        document = Document(fileURL: url)
    }

    func updateFileName(_ name: String) {
        fileName = name
    }

    /// Renames the underlying PDF file and updates internal state.
    /// - Parameter newName: The new name without extension.
    /// - Returns: `true` on success, `false` otherwise.
    func renamePDF(to newName: String) -> Bool {
        guard let currentURL = pdfURL else { return false }
        let ext = currentURL.pathExtension
        let finalName = newName.hasSuffix(".\(ext)") ? newName : "\(newName).\(ext)"
        let newURL = currentURL.deletingLastPathComponent().appendingPathComponent(finalName)
        do {
            try FileManager.default.moveItem(at: currentURL, to: newURL)
            pdfURL = newURL
            fileName = newName
            document = Document(fileURL: newURL)
            return true
        } catch {
            print("Failed to rename PDF: \(error.localizedDescription)")
            return false
        }
    }

    func canSendMessage(_ text: String) -> Bool {
        return !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }


    func createChatViewModel(with text: String) -> ChatViewModel? {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard canSendMessage(trimmed), let pdfURL = pdfURL else { return nil }

        let chatViewModel = ChatViewModel(allChats: chats.map { $0.messages })
        chatViewModel.updateFileName(fileName)
        chatViewModel.processInput(text: trimmed) {}
        chatViewModel.uploadPDF(at: pdfURL) { _ in }
        return chatViewModel
    }

    func fetchChats() {
        FileChatManager.shared.fetchDocuments { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let records):
                if let record = records.first(where: { $0.document.fileName == self.fileName }) {
                    self.document = record.document
                    if record.chats.isEmpty {
                        self.chats = []
                    } else {
                        self.chats = record.chats.map { ChatHistory(messages: $0, created: record.document.modificationDate) }
                    }
                } else {
                    self.chats = []
                }
                self.sectionedChats = self.groupChatsByDate(chats: self.chats)
            case .failure:
                self.chats = []
                self.sectionedChats = []
            }
            DispatchQueue.main.async {
                self.onChatsUpdated?()
            }
        }
    }

    func createChatHistoryViewModel(at index: Int = 0) -> ChatViewModel {
        let chatViewModel = ChatViewModel(allChats: chats.map { $0.messages }, chatIndex: index)
        chatViewModel.updateFileName(fileName)
        guard chats.indices.contains(index) else { return chatViewModel }
        let messages = chats[index].messages
        chatViewModel.messages = messages.enumerated().map { idx, text in
            let type: ChatDisplayMessage.MessageType = idx % 2 == 0 ? .user : .ai
            return ChatDisplayMessage(type: type, text: text)
        }
        if let url = document?.fileURL {
            chatViewModel.uploadPDF(at: url) { _ in }
        }
        return chatViewModel
    }

    // MARK: - Sectioned Table Helpers
    func numberOfSections() -> Int {
        sectionedChats.count
    }

    func numberOfChats(in section: Int) -> Int {
        guard sectionedChats.indices.contains(section) else { return 0 }
        return sectionedChats[section].items.count
    }

    func chat(at indexPath: IndexPath) -> ChatHistory? {
        guard sectionedChats.indices.contains(indexPath.section),
              sectionedChats[indexPath.section].items.indices.contains(indexPath.row) else {
            return nil
        }
        return sectionedChats[indexPath.section].items[indexPath.row]
    }

    func title(for section: Int) -> String {
        guard sectionedChats.indices.contains(section) else { return "" }
        let date = sectionedChats[section].date
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE, d MMMM"
            return formatter.string(from: date)
        }
    }

    private func groupChatsByDate(chats: [ChatHistory]) -> [(Date, [ChatHistory])] {
        let grouped = Dictionary(grouping: chats) { chat in
            Calendar.current.startOfDay(for: chat.created)
        }
        return grouped
            .sorted { $0.key > $1.key }
            .map { ($0.key, $0.value.sorted { $0.created > $1.created }) }
    }
}
