//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import UIKit

final class EditorInteractionHelper {
    private weak var viewController: EditorViewController?
    private let businessLogic: EditorBusinessLogic
    private var bottomItems: [(UIView, UIImageView, UILabel)] = []
    private var filterButtonMap: [UIButton: FilterType] = [:]

    init(viewController: EditorViewController, businessLogic: EditorBusinessLogic) {
        self.viewController = viewController
        self.businessLogic = businessLogic
        bottomItems = EditorUIConfigurator
            .bottomItems(for: viewController)
            .filter { $0.0 !== viewController.saveView }
        filterButtonMap = zip(
            EditorUIConfigurator.filterButtons(for: viewController),
            [FilterType.enhance, .contrastBW, .softBW, .sharpenBW, .original]
        ).reduce(into: [:]) { $0[$1.0] = $1.1 }
    }

    // MARK: - Selection Handling
    func selectBottomOption(_ view: UIView) {
        guard let vc = viewController, view !== vc.addPageView else { return }

        for (itemView, icon, label) in bottomItems {
            let isSelected = itemView === view
            applySelection(to: itemView, icon: icon, label: label, selected: isSelected)
        }

        if view === vc.contrastView {
            vc.showAdjustmentSlider(for: .contrast)
        } else if view === vc.brightnessView {
            vc.showAdjustmentSlider(for: .brightness)
        } else if view === vc.filtersView {
            vc.showAdjustmentSlider(for: .none)
        }
    }

    func applySelection(to view: UIView, icon: UIImageView, label: UILabel, selected: Bool) {
        RoundedStyleUtility.apply(to: view, cornerRadius: 16, backgroundColor: selected ? Colors.blueColor : Colors.whiteColor)
        icon.tintColor = selected ? Colors.whiteColor : Colors.blueColor
        label.textColor = selected ? Colors.whiteColor : Colors.blueColor
    }

    func selectFilterButton(_ button: UIButton) {
        for btn in filterButtonMap.keys {
            let isSelected = btn === button
            RoundedStyleUtility.apply(to: btn, cornerRadius: 16, backgroundColor: Colors.whiteColor, borderColor: isSelected ? Colors.blueColor : .clear, borderWidth: isSelected ? 2.0 : 0)
        }
    }

    func updateFilterSelection(for filter: FilterType) {
        if let button = filterButtonMap.first(where: { $0.value == filter })?.key {
            selectFilterButton(button)
        }
    }

    // MARK: - Actions
    @objc func handleBottomTap(_ gesture: UITapGestureRecognizer) {
        guard let tappedView = gesture.view, let vc = viewController else { return }
        if tappedView === vc.saveView {
            AnimationUtility.animateViewPress(tappedView) { [weak self] in
                self?.openPreview()
            }
        } else {
            AnimationUtility.animateViewPress(tappedView) { [weak self] in
                self?.selectBottomOption(tappedView)
                if tappedView === vc.addPageView {
                    self?.presentScannerForNewPage()
                }
            }
        }
    }

    @objc func handleFilterButton(_ sender: UIButton) {
        AnimationUtility.animateButtonPress(sender) { [weak self] in
            guard let self = self,
                  let vc = self.viewController,
                  let filter = self.filterButtonMap[sender] else { return }
            self.selectFilterButton(sender)
            self.businessLogic.applyFilter(filter, at: vc.currentPageIndex)
            vc.showCurrentPage()
        }
    }

    @objc func handleRotateButton(_ sender: UIButton) {
        AnimationUtility.animateButtonPress(sender) { [weak self] in
            guard let vc = self?.viewController else { return }
            self?.businessLogic.rotatePage(at: vc.currentPageIndex)
            vc.showCurrentPage()
        }
    }

    @objc func handleRemovePageButton(_ sender: UIButton) {
        AnimationUtility.animateButtonPress(sender) { [weak self] in
            guard let vc = self?.viewController else { return }
            self?.businessLogic.removePage(at: vc.currentPageIndex)
            if vc.currentPageIndex >= self?.businessLogic.pageCount ?? 0 {
                vc.currentPageIndex = max(0, (self?.businessLogic.pageCount ?? 1) - 1)
            }
            vc.showCurrentPage()
            vc.updatePageCount()
        }
    }

    // MARK: - Scanning & Navigation
    func presentScannerForNewPage() {
        guard let vc = viewController else { return }
        if Constants.isTestMode {
            let imageNames = ["test_1", "test_2", "test_3"]
            let images = imageNames.compactMap { UIImage(named: $0) }
            addPages(images)
        } else {
            DocumentScannerManager.shared.presentScanner(from: vc) { [weak self] images in
                self?.addPages(images)
            }
        }
    }

    func startInitialScan() {
        guard let vc = viewController else { return }
        if Constants.isTestMode {
            let imageNames = ["test_1", "test_2", "test_3"]
            let images = imageNames.compactMap { UIImage(named: $0) }
            vc.loadImages(images)
        } else {
            DocumentScannerManager.shared.presentScanner(from: vc) { images in
                vc.loadImages(images)
            }
        }
    }

    func openPreview() {
        guard let vc = viewController, let url = businessLogic.exportPDF() else { return }
        FileChatManager.shared.saveDocument(
            at: url,
            fileName: businessLogic.fileName,
            metadata: ["pages": businessLogic.pageCount]
        ) { result in
            if case let .failure(error) = result {
                print("Failed to save file info: \(error.localizedDescription)")
            }
        }
        NavigationManager.shared.transitionToViewController(
            identifier: "PreviewViewController",
            from: vc,
            push: true
        ) { viewController in
            if let previewVC = viewController as? PreviewViewController {
                previewVC.viewModel.loadPDF(at: url)
                previewVC.viewModel.updateFileName(self.businessLogic.fileName)
            }
        }
    }

    private func addPages(_ images: [UIImage]) {
        businessLogic.addPages(images)
        guard let vc = viewController else { return }
        vc.currentPageIndex = businessLogic.pageCount - 1
        vc.showCurrentPage()
        vc.updatePageCount()
    }
}
