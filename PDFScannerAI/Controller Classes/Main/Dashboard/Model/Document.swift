//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import Foundation
import PDFKit

struct Document {
    let fileURL: URL
    let fileName: String
    let pagesCount: Int
    let modificationDate: Date
    let fileSize: UInt64

    /// Creates a `Document` using information from the local file system.
    /// Fails if the file cannot be opened as a PDF.
    init?(fileURL: URL) {
        self.fileURL = fileURL
        self.fileName = fileURL.deletingPathExtension().lastPathComponent
        let attributes = try? FileManager.default.attributesOfItem(atPath: fileURL.path)
        self.modificationDate = attributes?[.modificationDate] as? Date ?? Date()
        self.fileSize = attributes?[.size] as? UInt64 ?? 0
        if let pdf = PDFDocument(url: fileURL) {
            self.pagesCount = pdf.pageCount
        } else {
            return nil
        }
    }

    /// Creates a `Document` with provided metadata. This is used when the PDF
    /// file is not available locally (e.g. when running on a simulator).
    init(fileURL: URL, pagesCount: Int, modificationDate: Date, fileSize: UInt64 = 0) {
        self.fileURL = fileURL
        self.fileName = fileURL.deletingPathExtension().lastPathComponent
        self.pagesCount = pagesCount
        self.modificationDate = modificationDate
        self.fileSize = fileSize
    }
}
