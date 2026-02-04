//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import UIKit
import UniformTypeIdentifiers

/// Helper class to present a document picker for selecting PDFs.
final class DocumentPickerHelper: NSObject {
    static let shared = DocumentPickerHelper()
    private var completion: ((URL) -> Void)?

    private override init() { }

    /// Presents the document picker from the given view controller.
    /// - Parameters:
    ///   - viewController: The presenting view controller.
    ///   - completion: Called with the selected file URL.
    func presentPicker(from viewController: UIViewController, completion: @escaping (URL) -> Void) {
        self.completion = completion
        if #available(iOS 14.0, *) {
            let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.pdf], asCopy: true)
            picker.delegate = self
            viewController.present(picker, animated: true)
        } else {
            let picker = UIDocumentPickerViewController(documentTypes: ["com.adobe.pdf"], in: .import)
            picker.delegate = self
            viewController.present(picker, animated: true)
        }
    }
}

// MARK: - UIDocumentPickerDelegate
extension DocumentPickerHelper: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        controller.dismiss(animated: true)
        guard let url = urls.first else { return }
        completion?(url)
        completion = nil
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true)
        completion = nil
    }
}
