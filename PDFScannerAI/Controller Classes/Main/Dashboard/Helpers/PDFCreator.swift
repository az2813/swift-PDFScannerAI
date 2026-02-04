//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import Foundation
import PDFKit
import UIKit

/// Utility responsible for creating PDF files from an array of images.
final class PDFCreator {
    /// Creates a PDF file from provided images and returns the file URL if successful.
    /// - Parameters:
    ///   - images: Array of `UIImage` objects representing the pages.
    ///   - fileName: Optional name for the resulting PDF file. If not provided the
    ///     name will default to "Scan_`date`.pdf".
    /// - Returns: URL to the generated PDF file or `nil` on failure.
    static func createPDF(from images: [UIImage], fileName: String? = nil) -> URL? {
        guard !images.isEmpty else { return nil }

        let pdfDocument = PDFDocument()
        for (index, image) in images.enumerated() {
            if let page = PDFPage(image: image) {
                pdfDocument.insert(page, at: index)
            }
        }

        let baseName: String
        if let name = fileName, !name.trimmingCharacters(in: .whitespaces).isEmpty {
            baseName = name
        } else {
            baseName = "Scan_\(DateHelper.fileNameDateString())"
        }
        let finalName = baseName.hasSuffix(".pdf") ? baseName : "\(baseName).pdf"
        let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = documentsDir.appendingPathComponent(finalName)

        return pdfDocument.write(to: url) ? url : nil
    }
}
