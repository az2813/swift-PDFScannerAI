//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import Foundation
import PDFKit

/// View model responsible for providing document data for the dashboard screen.

final class DashboardViewModel {
    /// Documents displayed in the dashboard.
    private(set) var documents: [Document] = []
    /// Sectioned documents grouped by date
    private(set) var sectionedItems: [(date: Date, items: [Document])] = []
    
    /// Begins observing documents stored in Firebase.
    func startObservingDocuments(onUpdate: @escaping () -> Void) {
        FileChatManager.shared.observeDocuments { [weak self] records in
            if records.isEmpty {
                self?.loadDemoDocument()
            } else {
                self?.documents = records.map { $0.document }
            }
            self?.sectionedItems = self?.groupItemsByDate(items: self?.documents ?? []) ?? []
            onUpdate()
        }
    }

    /// Fetches documents once from Firebase.
    func fetchDocuments(completion: @escaping () -> Void) {
        FileChatManager.shared.fetchDocuments { [weak self] result in
            switch result {
            case .success(let records):
                if records.isEmpty {
                    self?.loadDemoDocument()
                } else {
                    self?.documents = records.map { $0.document }
                }
            case .failure:
                self?.loadDemoDocument()
            }
            self?.sectionedItems = self?.groupItemsByDate(items: self?.documents ?? []) ?? []
            completion()
        }
    }

    /// Stops observing document updates.
    func stopObserving() {
        FileChatManager.shared.removeObservers()
    }

    func metaInfo(for document: Document) -> String {
        let dateString = DateHelper.metaInfoDateString(for: document.modificationDate)
        let sizeString = ByteCountFormatter.string(fromByteCount: Int64(document.fileSize), countStyle: .file)
        return "\(dateString) • \(sizeString)"
    }

    func deleteDocument(_ document: Document, completion: @escaping () -> Void) {
        FileChatManager.shared.deleteDocument(document) { [weak self] result in
            if case .success = result {
                self?.documents.removeAll { $0.fileURL == document.fileURL }
            }
            self?.sectionedItems = self?.groupItemsByDate(items: self?.documents ?? []) ?? []
            completion()
        }
    }

    // MARK: - Sectioned Table Helpers
    func numberOfSections() -> Int {
        sectionedItems.count
    }

    func numberOfItems(in section: Int) -> Int {
        guard sectionedItems.indices.contains(section) else { return 0 }
        return sectionedItems[section].items.count
    }

    func item(at indexPath: IndexPath) -> Document? {
        guard sectionedItems.indices.contains(indexPath.section),
              sectionedItems[indexPath.section].items.indices.contains(indexPath.row) else {
            return nil
        }
        return sectionedItems[indexPath.section].items[indexPath.row]
    }

    func title(for section: Int) -> String {
        let date = sectionedItems[section].date
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

    private func groupItemsByDate(items: [Document]) -> [(Date, [Document])] {
        let grouped = Dictionary(grouping: items) { item -> Date in
            Calendar.current.startOfDay(for: item.modificationDate)
        }
        return grouped
            .sorted { $0.key > $1.key }
            .map { ($0.key, $0.value.sorted { $0.modificationDate > $1.modificationDate }) }
    }

    private func loadDemoDocument() {
        var loaded: [Document] = []
        if let url = Bundle.main.url(forResource: "demo_doc", withExtension: "pdf"),
           let doc = Document(fileURL: url) {
            loaded.append(doc)
        }
        if let url = Bundle.main.url(forResource: "sample_tables", withExtension: "pdf"),
           let doc = Document(fileURL: url) {
            loaded.append(doc)
        }
        documents = loaded
        sectionedItems = groupItemsByDate(items: documents)
    }
}
