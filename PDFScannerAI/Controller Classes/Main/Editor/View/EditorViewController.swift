//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import UIKit
import PDFKit

class EditorViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var countView: UIView!
    @IBOutlet weak var pageCountLabel: UILabel!
    @IBOutlet weak var rotateButton: UIButton!
    @IBOutlet weak var removePageButton: UIButton!
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var optionsView: UIView!
    @IBOutlet weak var filtersView: UIView!
    @IBOutlet weak var filtersIcon: UIImageView!
    @IBOutlet weak var filtersLabel: UILabel!
    @IBOutlet weak var contrastView: UIView!
    @IBOutlet weak var contrastIcon: UIImageView!
    @IBOutlet weak var contrastLabel: UILabel!
    @IBOutlet weak var brightnessView: UIView!
    @IBOutlet weak var brightnessIcon: UIImageView!
    @IBOutlet weak var brightnessLabel: UILabel!
    @IBOutlet weak var addPageView: UIView!
    @IBOutlet weak var addPageIcon: UIImageView!
    @IBOutlet weak var addPageLabel: UILabel!
    @IBOutlet weak var saveView: UIView!
    @IBOutlet weak var saveIcon: UIImageView!
    @IBOutlet weak var saveLabel: UILabel!
    @IBOutlet weak var filtersOptionsStackView: UIStackView!
    @IBOutlet weak var enhanceButton: UIButton!
    @IBOutlet weak var contrastBwButton: UIButton!
    @IBOutlet weak var softBwButton: UIButton!
    @IBOutlet weak var sharpenBwButton: UIButton!
    @IBOutlet weak var originalButton: UIButton!
    @IBOutlet weak var contrastBrightnessSlider: UISlider!
    
    private var uiConfigurator = EditorUIConfigurator()
    private var interactionHelper: EditorInteractionHelper!
    let viewModel = EditorViewModel()
    private lazy var businessLogic = EditorBusinessLogic(viewModel: viewModel)
    var scrollView: UIScrollView!
    var imageViews: [UIImageView] = []
    var currentPageIndex: Int = 0
    var backgroundImageView: UIImageView!
    var blurView: UIVisualEffectView!
    private var filterWorkItem: DispatchWorkItem?
    var isFromAddCar: Bool = false {
        didSet {
            viewModel.isFromAddCar = isFromAddCar
        }
    }
    var isCarImage: Bool = false {
        didSet {
            viewModel.isFromAddCar = isFromAddCar
        }
    }
    var didSavePDF: ((URL, [UIImage]) -> Void)? = nil
    var document: Document? = nil {
        didSet {
            viewModel.document = document
        }
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.isFromAddCar = isFromAddCar
        viewModel.isCarImage = isCarImage
        viewModel.document = document
        uiConfigurator.configureUI(for: self)
        uiConfigurator.setupBackground(for: self)
        interactionHelper = EditorInteractionHelper(viewController: self, businessLogic: businessLogic)
        setupActions()
        uiConfigurator.setupScrollView(for: self)
        interactionHelper.selectBottomOption(filtersView)
        interactionHelper.selectFilterButton(originalButton)
        showAdjustmentSlider(for: .none)
        showCurrentPage()
        updatePageCount()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if businessLogic.pageCount == 0 {
            interactionHelper.startInitialScan()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        showCurrentPage()
    }

    func layoutImages() {
        imageViews.forEach { $0.removeFromSuperview() }
        imageViews = []

        let pageCount = businessLogic.pageCount
        let pageWidth = scrollView.bounds.width
        let pageHeight = scrollView.bounds.height

        for i in 0..<pageCount {
            let image = businessLogic.displayImage(for: i)
            let imageView = UIImageView(frame: CGRect(x: 0, y: CGFloat(i) * pageHeight, width: pageWidth, height: pageHeight))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            imageView.clipsToBounds = true
            imageView.backgroundColor = .clear
            scrollView.addSubview(imageView)
            imageViews.append(imageView)
        }

        scrollView.contentSize = CGSize(width: pageWidth, height: pageHeight * CGFloat(pageCount))
    }

    private func updateCurrentPage(from scrollView: UIScrollView, finalize: Bool) {
        let page = Int(round(scrollView.contentOffset.y / scrollView.frame.height))
        currentPageIndex = min(max(page, 0), businessLogic.pageCount - 1)
        updatePageCount()
        backgroundImageView.image = businessLogic.displayImage(for: currentPageIndex)
        if finalize {
            updateFilterButtonSelection()
            showAdjustmentSlider(for: viewModel.adjustmentMode)
        }
    }

    func showCurrentPage() {
        layoutImages()
        let pageHeight = scrollView.frame.height
        let yOffset = CGFloat(currentPageIndex) * pageHeight
        scrollView.setContentOffset(CGPoint(x: 0, y: yOffset), animated: false)
        backgroundImageView.image = businessLogic.displayImage(for: currentPageIndex)
        updateFilterButtonSelection()
        showAdjustmentSlider(for: viewModel.adjustmentMode)
    }

    func showAdjustmentSlider(for mode: AdjustmentMode) {
        viewModel.adjustmentMode = mode
        switch mode {
        case .contrast:
            filtersOptionsStackView.isHidden = true
            optionsView.isHidden = false
            optionsView.backgroundColor = .white
            contrastBrightnessSlider.isHidden = false
            contrastBrightnessSlider.value = Float(viewModel.getContrast(for: currentPageIndex))
        case .brightness:
            filtersOptionsStackView.isHidden = true
            optionsView.isHidden = false
            optionsView.backgroundColor = .white
            contrastBrightnessSlider.isHidden = false
            contrastBrightnessSlider.value = Float(viewModel.getBrightness(for: currentPageIndex))
        case .none:
            filtersOptionsStackView.isHidden = false
            contrastBrightnessSlider.isHidden = true
            optionsView.isHidden = false
            optionsView.backgroundColor = .clear
        }
    }

}

// MARK: - Actions
extension EditorViewController {
    func updatePageCount() {
        if businessLogic.pageCount == 0 {
            pageCountLabel.text = "0/0"
        } else {
            pageCountLabel.text = "\(currentPageIndex + 1)/\(businessLogic.pageCount)"
        }
    }

    func updateFilterButtonSelection() {
        let filter = viewModel.pages[currentPageIndex].filter
        interactionHelper.updateFilterSelection(for: filter)
    }

    private func setupActions() {
        for (view, _, _) in EditorUIConfigurator.bottomItems(for: self) {
            view.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: interactionHelper, action: #selector(EditorInteractionHelper.handleBottomTap(_:)))
            view.addGestureRecognizer(tapGesture)
        }

        EditorUIConfigurator.filterButtons(for: self).forEach {
            $0.addTarget(interactionHelper, action: #selector(EditorInteractionHelper.handleFilterButton(_:)), for: .touchUpInside)
        }

        rotateButton.addTarget(interactionHelper, action: #selector(EditorInteractionHelper.handleRotateButton(_:)), for: .touchUpInside)
        removePageButton.addTarget(interactionHelper, action: #selector(EditorInteractionHelper.handleRemovePageButton(_:)), for: .touchUpInside)
    }

    func loadImages(_ images: [UIImage]) {
        businessLogic.loadImages(images)
        currentPageIndex = 0
        if isViewLoaded {
            showCurrentPage()
            updatePageCount()
            configureNavigationBar()
        }
    }

    private func configureNavigationBar() {
        EditorNavigationBarHelper.configureNavigationBar(
            for: self,
            fileName: businessLogic.fileName,
            tapTarget: self,
            tapAction: #selector(handleTitleTap),
            pagesTarget: self,
            pagesAction: nil//#selector(handlePagesButton)
        )
    }

    @objc private func handleTitleTap() {
        InputAlertHelper.showInputAlert(
            from: self,
            title: "Edit File Name",
            message: nil,
            textFieldPlaceholder: "File Name",
            textFieldDefaultValue: businessLogic.fileName,
            confirmButtonTitle: "OK",
            cancelButtonTitle: "Cancel"
        ) { [weak self] newName in
            guard let self = self, let name = newName, !name.isEmpty else { return }
            self.businessLogic.updateFileName(name)
            self.configureNavigationBar()
        }
    }

    @objc private func handlePagesButton() {
        print("Pages button tapped")
    }

    @objc func handlePDFViewPageChanged(_ notification: Notification) {
        updatePageCount()
    }

    @IBAction func contrastBrightnessSliderChanged(_ sender: UISlider, forEvent event: UIEvent) {
        let value = CGFloat(sender.value)
        switch viewModel.adjustmentMode {
        case .contrast:
            viewModel.setContrast(value, for: currentPageIndex)
        case .brightness:
            viewModel.setBrightness(value, for: currentPageIndex)
        default: break
        }

        if let touch = event.allTouches?.first {
            if touch.phase == .moved {
                let page = viewModel.pages[currentPageIndex]
                var preview = page.image.thumbnail()
                if page.filter != .original {
                    preview = ImageFilterUtility.apply(page.filter.imageFilter, to: preview)
                }
                preview = ImageFilterUtility.applyContrastAndBrightness(
                    to: preview,
                    contrast: viewModel.getContrast(for: currentPageIndex),
                    brightness: viewModel.getBrightness(for: currentPageIndex)
                )
                if page.rotation != 0 {
                    preview = preview.rotated(by: CGFloat(page.rotation))
                }
                backgroundImageView.image = preview
                if imageViews.indices.contains(currentPageIndex) {
                    imageViews[currentPageIndex].image = preview
                }
            } else if touch.phase == .ended || touch.phase == .cancelled {
                showCurrentPage()
            }
        }
    }
}

// MARK: - PDFViewDelegate
extension EditorViewController: PDFViewDelegate {
    func pdfViewPageChanged(_ notification: Notification) {
        updatePageCount()
    }
}

extension EditorViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateCurrentPage(from: scrollView, finalize: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateCurrentPage(from: scrollView, finalize: false)
    }
}
