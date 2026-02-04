//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import Foundation
import UIKit
import VisionKit

final class DocumentScannerManager: NSObject {
    static let shared = DocumentScannerManager()
    private var completion: (([UIImage]) -> Void)?

    private override init() { }

    /// Presents the document scanner if supported.
    /// - Parameters:
    ///   - viewController: The view controller from which to present.
    ///   - completion: Closure with scanned images.
    func presentScanner(from viewController: UIViewController, completion: (([UIImage]) -> Void)? = nil) {
        guard VNDocumentCameraViewController.isSupported else {
            print("Document camera not supported on this device")
            return
        }
        self.completion = completion
        let scanner = VNDocumentCameraViewController()
        scanner.delegate = self
        viewController.present(scanner, animated: true, completion: nil)
    }
}

// MARK: - VNDocumentCameraViewControllerDelegate
extension DocumentScannerManager: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        var images: [UIImage] = []
        for index in 0..<scan.pageCount {
            images.append(scan.imageOfPage(at: index))
        }
        controller.dismiss(animated: true) { [weak self] in
            self?.completion?(images)
            self?.completion = nil
        }
    }

    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true) { [weak self] in
            self?.completion = nil
        }
    }

    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        print("Document scan failed: \(error.localizedDescription)")
        controller.dismiss(animated: true) { [weak self] in
            self?.completion = nil
        }
    }
}
