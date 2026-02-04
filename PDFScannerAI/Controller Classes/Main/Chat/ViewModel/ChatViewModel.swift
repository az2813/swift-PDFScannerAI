//
//  2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import Foundation

class ChatViewModel {

    static let summaryPrompt = "Summarize this document"
    static let keyPointsPrompt = "List key points of this document"
    static let aiPrompt = "What does the AI say about this document?"

    // MARK: - Properties
    var messages: [ChatDisplayMessage] = []
    var onMessagesUpdated: (() -> Void)?
    var onErrorOccurred: ((String) -> Void)?
    var onLoadingTextUpdated: ((String) -> Void)?
    var fileName: String = ""

    private let service: ChatPDFService
    private var sourceId: String?
    private var previousMessageCount: Int = 0
    private let loadingAnimator = LoadingMessageAnimator()
    private var loadingMessageIndex: Int?
    private var pendingQuestion: String?
    private var pendingCompletion: (() -> Void)?

    /// All chats for the current file. The view model updates the array when
    /// persisting messages.
    var allChats: [[String]] = []
    /// Index of the chat session represented by `messages` within `allChats`.
    private var chatIndex: Int?

    init(service: ChatPDFService = ChatPDFService(), allChats: [[String]] = [], chatIndex: Int? = nil) {
        self.service = service
        self.allChats = allChats
        self.chatIndex = chatIndex
    }

    func setSourceId(_ id: String) {
        sourceId = id
    }

    func canSendMessage(_ text: String) -> Bool {
        return !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    // MARK: - Upload
    func uploadPDF(at url: URL, completion: @escaping (Bool) -> Void) {
        service.uploadPDF(fileURL: url) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let id):
                    self?.sourceId = id
                    completion(true)
                    self?.continuePendingQuestion(success: true)
                case .failure(let error):
                    self?.onErrorOccurred?(error.localizedDescription)
                    completion(false)
                    self?.continuePendingQuestion(success: false)
                }
            }
        }
    }

    private func continuePendingQuestion(success: Bool) {
        guard let question = pendingQuestion else { return }
        let completion = pendingCompletion ?? {}
        pendingQuestion = nil
        pendingCompletion = nil

        guard success, let sourceId = sourceId else {
            loadingAnimator.stopAnimating()
            removeLastMessage()
            onErrorOccurred?("Failed to upload PDF")
            completion()
            return
        }

        service.askQuestion(sourceId: sourceId, question: question) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                completion()
                self.loadingAnimator.stopAnimating()

                switch result {
                case .failure(let error):
                    self.removeLastMessage()
                    self.onErrorOccurred?(error.localizedDescription)
                case .success(let answer):
                    self.replaceLastMessage(with: ChatDisplayMessage(type: .ai, text: answer))
                }
            }
        }
    }

    // MARK: - Public Methods
    func processInput(text: String?, completion: @escaping () -> Void) {
        let trimmedText = text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !trimmedText.isEmpty else {
            completion()
            return
        }

        appendMessage(ChatDisplayMessage(type: .user, text: trimmedText))
        persistChats()

        let initialStatus = loadingAnimator.randomInitialStatus()
        appendMessage(ChatDisplayMessage(type: .ai, text: initialStatus))
        loadingMessageIndex = messages.count - 1

        loadingAnimator.startAnimating { [weak self] updatedText in
            guard let self = self,
                  let index = self.loadingMessageIndex,
                  index < self.messages.count else { return }
            self.messages[index] = ChatDisplayMessage(type: .ai, text: updatedText)
            self.onLoadingTextUpdated?(updatedText)
        }

        guard let sourceId = sourceId else {
            pendingQuestion = trimmedText
            pendingCompletion = completion
            return
        }

        service.askQuestion(sourceId: sourceId, question: trimmedText) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                completion()
                self.loadingAnimator.stopAnimating()

                switch result {
                case .failure(let error):
                    self.removeLastMessage()
                    self.onErrorOccurred?(error.localizedDescription)
                case .success(let answer):
                    self.replaceLastMessage(with: ChatDisplayMessage(type: .ai, text: answer))
                }
            }
        }
    }

    // MARK: - Helpers
    func appendAIMessage(_ text: String) {
        appendMessage(ChatDisplayMessage(type: .ai, text: text))
    }

    private func appendMessage(_ message: ChatDisplayMessage) {
        previousMessageCount = messages.count
        messages.append(message)
        onMessagesUpdated?()
    }

    func replaceLastMessage(with newMessage: ChatDisplayMessage) {
        guard !messages.isEmpty else { return }
        messages[messages.count - 1] = newMessage
        onMessagesUpdated?()
        persistChats()
    }

    private func removeLastMessage() {
        guard !messages.isEmpty else { return }
        messages.removeLast()
        onMessagesUpdated?()
    }

    func didAppendNewMessage() -> Bool {
        let isNew = messages.count > previousMessageCount
        previousMessageCount = messages.count
        return isNew
    }

    func updateFileName(_ name: String) {
        fileName = name
    }

    private func persistChats() {
        guard !fileName.isEmpty else { return }
        let chatTexts = messages.map { $0.text }

        if let index = chatIndex {
            if allChats.indices.contains(index) {
                allChats[index] = chatTexts
            } else {
                allChats.append(chatTexts)
                chatIndex = allChats.count - 1
            }
        } else {
            allChats.append(chatTexts)
            chatIndex = allChats.count - 1
        }

        FileChatManager.shared.updateChats(fileName: fileName, chats: allChats) { _ in
            NotificationCenter.default.post(name: .chatsUpdated, object: nil)
        }
    }
}
