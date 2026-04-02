//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import UIKit

final class DashboardInteractionHelper {
    private weak var viewController: DashboardViewController?
    private let viewModel: DashboardViewModel
    var refreshNavigationBar: (() -> Void)?

    init(viewController: DashboardViewController,
         viewModel: DashboardViewModel,
         refreshNavigationBar: (() -> Void)? = nil) {
        self.viewController = viewController
        self.viewModel = viewModel
        self.refreshNavigationBar = refreshNavigationBar
    }

    // MARK: - Navigation Bar Actions
    @objc func handleMenu() {
        openSettings()
    }

    @objc func handlePremiumTapped() {
        presentPaywall()
    }

    // MARK: - Button Actions
    @objc func handleNewScanButton(_ sender: UIButton) {
        AnimationUtility.animateButtonPress(sender) { [weak self] in
            self?.requireSubscription { [weak self] in
                self?.handleNewScan()
            }
        }
    }

    @objc func handleAIButton(_ sender: UIButton) {
        AnimationUtility.animateButtonPress(sender) { [weak self] in
            self?.requireSubscription { [weak self] in
                self?.handleAI()
            }
        }
    }
    
    @objc func handleCarScanButton(_ sender: UIButton) {
        AnimationUtility.animateButtonPress(sender) { [weak self] in
            self?.requireSubscription { [weak self] in
                self?.handleCarScan()
            }
        }
    }

    // MARK: - Private Navigation Helpers
    private func openSettings() {
        guard let vc = viewController else { return }
        NavigationManager.shared.transitionToViewController(identifier: "SettingsViewController", from: vc, push: true)
    }

    private func presentPaywall() {
        guard let vc = viewController else { return }
        PaywallManager.shared.showPaywall(from: vc, configKey: "paywall_dashboard", isDismiss: true)
    }

    private func requireSubscription(allowed: @escaping () -> Void) {
        SubscriptionManager.shared.checkSubscriptionStatus { [weak self] isSubscribed in
            DispatchQueue.main.async {
                if isSubscribed {
                    allowed()
                } else {
                    self?.presentPaywall()
                }
            }
        }
    }

    private func handleNewScan() {
        guard let vc = viewController else { return }
        if Constants.isTestMode {
            let imageNames = ["test_1", "test_2", "test_3"]
            let images = imageNames.compactMap { UIImage(named: $0) }
            guard !images.isEmpty else {
                print("Failed to load test images")
                return
            }
            NavigationManager.shared.transitionToViewController(
                identifier: "EditorViewController",
                from: vc,
                push: true
            ) { viewController in
                (viewController as? EditorViewController)?.loadImages(images)
            }
        } else {
            DocumentScannerManager.shared.presentScanner(from: vc) { [weak self] images in
                guard let firstVC = self?.viewController, !images.isEmpty else {
                    print("Failed to get scanned images")
                    return
                }
                NavigationManager.shared.transitionToViewController(
                    identifier: "EditorViewController",
                    from: firstVC,
                    push: true
                ) { viewController in
                    (viewController as? EditorViewController)?.loadImages(images)
                }
            }
        }
    }

    private func handleAI() {
        guard let vc = viewController else { return }
        DocumentPickerHelper.shared.presentPicker(from: vc) { [weak self] url in
            guard let self = self else { return }

            let destinationURL: URL
            if let imported = self.importPDF(url) {
                destinationURL = imported
            } else {
                destinationURL = url
            }

            if let document = Document(fileURL: destinationURL) {
                FileChatManager.shared.saveDocument(
                    at: destinationURL,
                    fileName: document.fileName,
                    metadata: ["pages": document.pagesCount]
                ) { result in
                    if case let .failure(error) = result {
                        print("Failed to save file info: \(error.localizedDescription)")
                    }
                }
            }

            NavigationManager.shared.transitionToViewController(
                identifier: "PreviewViewController",
                from: vc,
                push: true
            ) { viewController in
                if let preview = viewController as? PreviewViewController {
                    preview.viewModel.loadPDF(at: destinationURL)
                    preview.viewModel.updateFileName(destinationURL.deletingPathExtension().lastPathComponent)
                }
            }
        }
    }
    
    private func handleCarScan() {
        guard let vc = viewController else { return }
        NavigationManager.shared.transitionToViewController(
            identifier: "AddCarViewController",
            from: vc,
            push: true
        ) { viewController in
            
        }
    }

    private func importPDF(_ url: URL) -> URL? {
        let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destURL = documentsDir.appendingPathComponent(url.lastPathComponent)
        do {
            let fm = FileManager.default
            if url.startAccessingSecurityScopedResource() { do { url.stopAccessingSecurityScopedResource() } }
            if fm.fileExists(atPath: destURL.path) { try fm.removeItem(at: destURL) }
            try fm.copyItem(at: url, to: destURL)
            return destURL
        } catch {
            print("Failed to import PDF: \(error.localizedDescription)")
            return nil
        }
    }
}
