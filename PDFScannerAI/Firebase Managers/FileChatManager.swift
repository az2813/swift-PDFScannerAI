import Foundation
import FirebaseDatabase

/// Represents a document saved on the device along with its associated chats.
struct FileChatRecord {
    let document: Document
    /// Array of chat sessions, each containing an array of messages.
    let chats: [[String]]
}

/// Handles storing and retrieving PDF file information and chats in Firebase
/// Realtime Database.
final class FileChatManager {
    static let shared = FileChatManager()
    private init() {}

    /// Firebase Realtime Database reference scoped to the configured URL.
    private var ref: DatabaseReference {
        Database.database(url: Constants.databaseURL).reference()
    }

    /// Returns a reference to the current user's files node (now under users/<uid>/files).
    private func getUserFilesRef(completion: @escaping (DatabaseReference?) -> Void) {
        AuthManager.shared.getCurrentUserUID { result in
            switch result {
            case .success(let uid):
                let userRef = self.ref.child("users/\(uid)/files")
                completion(userRef)
            case .failure(let error):
                print("Error retrieving user UID: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }

    /// Saves document information and chats to Firebase.
    /// - Parameters:
    ///   - url: Local file URL of the PDF.
    ///   - fileName: Name of the file used as the database key.
    ///   - metadata: Optional additional metadata such as page count.
    ///   - chats: Array of chat messages associated with the document.
    ///   - completion: Completion block with optional error.
    func saveDocument(at url: URL,
                      fileName: String,
                      metadata: [String: Any] = [:],
                      chats: [[String]] = [],
                      completion: ((Result<Void, Error>) -> Void)? = nil) {
        getUserFilesRef { filesRef in
            guard let filesRef = filesRef else {
                completion?(.failure(NSError(domain: "DatabaseError", code: 0,
                                           userInfo: [NSLocalizedDescriptionKey: "Failed to get user files reference."])))
                return
            }

            let fileRef = filesRef.child(fileName)
            var values: [String: Any] = [
                "path": url.path,
                "created": DateHelper.currentTimestamp(),
                "chats": chats
            ]
            if !metadata.isEmpty { values["metadata"] = metadata }
            fileRef.setValue(values) { error, _ in
                if let error = error {
                    completion?(.failure(error))
                } else {
                    completion?(.success(()))
                }
            }
        }
    }

    /// Updates chat messages for an existing document.
    /// - Parameters:
    ///   - fileName: Name of the file used as the database key.
    ///   - chats: Array of chat messages to store.
    ///   - completion: Completion block with optional error.
    func updateChats(fileName: String,
                     chats: [[String]],
                     completion: ((Result<Void, Error>) -> Void)? = nil) {
        getUserFilesRef { filesRef in
            guard let filesRef = filesRef else {
                completion?(.failure(NSError(domain: "DatabaseError", code: 0,
                                           userInfo: [NSLocalizedDescriptionKey: "Failed to get user files reference."])))
                return
            }
            let chatsRef = filesRef.child(fileName).child("chats")
            chatsRef.setValue(chats) { error, _ in
                if let error = error {
                    completion?(.failure(error))
                } else {
                    completion?(.success(()))
                }
            }
        }
    }

    private var documentsHandle: DatabaseHandle?

    /// Observes all documents for the current user and returns updates whenever
    /// the data changes.
    /// - Parameter onUpdate: Callback with the latest array of `FileChatRecord`.
    func observeDocuments(onUpdate: @escaping ([FileChatRecord]) -> Void) {
        getUserFilesRef { [weak self] filesRef in
            guard let self = self, let filesRef = filesRef else {
                onUpdate([])
                return
            }

            self.documentsHandle = filesRef.observe(.value) { snapshot in
                let records = self.parseRecords(from: snapshot)
                onUpdate(records)
            }
        }
    }

    /// Removes any active observers on the database reference.
    func removeObservers() {
        if let handle = documentsHandle {
            ref.removeObserver(withHandle: handle)
            documentsHandle = nil
        }
    }

    /// Fetches all documents for the current user.
    /// - Parameter completion: Array of `FileChatRecord`.
    func fetchDocuments(completion: @escaping (Result<[FileChatRecord], Error>) -> Void) {
        getUserFilesRef { filesRef in
            guard let filesRef = filesRef else {
                completion(.failure(NSError(domain: "DatabaseError", code: 0,
                                           userInfo: [NSLocalizedDescriptionKey: "Failed to get user files reference."])))
                return
            }

            filesRef.observeSingleEvent(of: .value) { [weak self] snapshot in
                guard let self = self else { return }
                let records = self.parseRecords(from: snapshot)
                completion(.success(records))
            }
        }
    }

    private func parseRecords(from snapshot: DataSnapshot) -> [FileChatRecord] {
        var records: [FileChatRecord] = []
        for child in snapshot.children {
            guard
                let childSnap = child as? DataSnapshot,
                let dict = childSnap.value as? [String: Any],
                let path = dict["path"] as? String
            else { continue }
            let url = URL(fileURLWithPath: path)
            var document: Document?
            if let localDoc = Document(fileURL: url) {
                document = localDoc
            } else {
                let metadata = dict["metadata"] as? [String: Any]
                let pages = metadata?["pages"] as? Int ?? 0
                let date: Date
                if let created = dict["created"] as? String, let parsed = DateHelper.dateFromTimestamp(created) {
                    date = parsed
                } else {
                    date = Date()
                }
                document = Document(fileURL: url, pagesCount: pages, modificationDate: date)
            }
            if let document = document {
                if let rawChats = dict["chats"] as? [[String]] {
                    records.append(FileChatRecord(document: document, chats: rawChats))
                } else if let singleChat = dict["chats"] as? [String] {
                    // Backwards compatibility with old schema
                    records.append(FileChatRecord(document: document, chats: [singleChat]))
                } else {
                    records.append(FileChatRecord(document: document, chats: []))
                }
            }
        }
        return records
    }

    /// Deletes a document entry from Firebase and removes the local file if present.
    func deleteDocument(_ document: Document, completion: ((Result<Void, Error>) -> Void)? = nil) {
        getUserFilesRef { filesRef in
            guard let filesRef = filesRef else {
                completion?(.failure(NSError(domain: "DatabaseError", code: 0,
                                           userInfo: [NSLocalizedDescriptionKey: "Failed to get user files reference."])))
                return
            }

            let fileRef = filesRef.child(document.fileName)
            fileRef.removeValue { error, _ in
                if let error = error {
                    completion?(.failure(error))
                } else {
                    do {
                        if FileManager.default.fileExists(atPath: document.fileURL.path) {
                            try FileManager.default.removeItem(at: document.fileURL)
                        }
                        completion?(.success(()))
                    } catch {
                        completion?(.failure(error))
                    }
                }
            }
        }
    }

    /// Renames a document entry and the underlying file on disk.
    /// - Parameters:
    ///   - oldName: Existing file name used as the database key.
    ///   - newName: Desired new file name without extension.
    ///   - completion: Completion block with optional error.
    func renameDocument(oldName: String,
                        newName: String,
                        completion: ((Result<Void, Error>) -> Void)? = nil) {
        getUserFilesRef { filesRef in
            guard let filesRef = filesRef else {
                completion?(.failure(NSError(domain: "DatabaseError", code: 0,
                                           userInfo: [NSLocalizedDescriptionKey: "Failed to get user files reference."])))
                return
            }

            let oldRef = filesRef.child(oldName)
            oldRef.observeSingleEvent(of: .value) { snapshot in
                guard var dict = snapshot.value as? [String: Any] else {
                    completion?(.failure(NSError(domain: "DatabaseError", code: 0,
                                               userInfo: [NSLocalizedDescriptionKey: "Document not found."])))
                    return
                }

                if let path = dict["path"] as? String {
                    let oldURL = URL(fileURLWithPath: path)
                    let ext = oldURL.pathExtension
                    let finalName = newName.hasSuffix(".\(ext)") ? newName : "\(newName).\(ext)"
                    let newURL = oldURL.deletingLastPathComponent().appendingPathComponent(finalName)

                    if FileManager.default.fileExists(atPath: oldURL.path) {
                        do {
                            try FileManager.default.moveItem(at: oldURL, to: newURL)
                        } catch {
                            completion?(.failure(error))
                            return
                        }
                    }

                    dict["path"] = newURL.path
                }

                let newRef = filesRef.child(newName)
                newRef.setValue(dict) { error, _ in
                    if let error = error {
                        completion?(.failure(error))
                    } else {
                        oldRef.removeValue { error, _ in
                            if let error = error {
                                completion?(.failure(error))
                            } else {
                                completion?(.success(()))
                            }
                        }
                    }
                }
            }
        }
    }
}
