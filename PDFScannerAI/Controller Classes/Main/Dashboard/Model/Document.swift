//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import Foundation
import PDFKit

struct Document {
    var fileURL: URL
    let fileName: String
    var pagesCount: Int
    var modificationDate: Date
    var fileSize: UInt64
    var carData: [String: Any]? = nil
    
    var services: [String: Any] {
        if let data = carData {
            return data["service"] as? [String: Any] ?? [:]
        } else {
            return [:]
        }
    }

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
            let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileName = fileURL.lastPathComponent
            let url = documentsDir.appendingPathComponent(fileName)
            self.fileURL = url
            let attributes = try? FileManager.default.attributesOfItem(atPath: url.path)
            self.modificationDate = attributes?[.modificationDate] as? Date ?? Date()
            self.fileSize = attributes?[.size] as? UInt64 ?? 0
            if let pdf = PDFDocument(url: url) {
                self.pagesCount = pdf.pageCount
            } else {
                return nil
            }
        }
    }

    /// Creates a `Document` with provided metadata. This is used when the PDF
    /// file is not available locally (e.g. when running on a simulator).
    init(fileURL: URL, pagesCount: Int, modificationDate: Date, fileSize: UInt64 = 0, carData: [String: Any]? = nil) {
        self.fileURL = fileURL
        self.fileName = fileURL.deletingPathExtension().lastPathComponent
        self.pagesCount = pagesCount
        self.modificationDate = modificationDate
        self.fileSize = fileSize
        self.carData = carData
    }
}
