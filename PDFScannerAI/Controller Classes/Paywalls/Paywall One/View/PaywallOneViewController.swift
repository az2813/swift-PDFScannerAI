//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import UIKit

class PaywallOneViewController: UIViewController {

    @IBOutlet weak var onboardingImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var subscribeButton: UIButton!
    @IBOutlet weak var privacyButton: UIButton!
    @IBOutlet weak var termsButton: UIButton!
    @IBOutlet weak var separatorLabel: UILabel!
    
    @objc dynamic var isDismiss: Bool = false

    private let viewModel = PaywallOneViewModel()
    private let uiConfigurator = PaywallOneUIConfigurator()
    private var interactionHelper: PaywallOneInteractionHelper!
    private var slideshowHelper: PaywallOneSlideshowHelper?
    private func setupBindings() {
        viewModel.onProductsUpdated = { [weak self] in
            self?.updateUI()
        }
        viewModel.onError = { [weak self] error in
            if let vc = self {
                AlertHelper.showAlert(on: vc, title: "Error", message: error.localizedDescription, actions: [UIAlertAction(title: "OK", style: .default)])
            }
        }
    }
    
    private func updateUI() {
        guard let info = viewModel.selectedProduct else { return }
        titleLabel.text = info.titleText
        subtitleLabel.text = info.descriptionText
        priceLabel.text = info.priceLabelText
        let hasTrial = SubscriptionTrialHelper.hasTrial(info.product)
        if hasTrial {
            let trial = SubscriptionTrialHelper.extractTrialDuration(from: info.product)
            let title = "Try \(trial.capitalized)"
            subscribeButton.setTitle(title, for: .normal)
        } else {
            subscribeButton.setTitle("Let's get started", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiConfigurator.configureUI(for: self)
        interactionHelper = PaywallOneInteractionHelper(viewController: self, viewModel: viewModel)
        interactionHelper.setupInteractions()
        setupBindings()
        viewModel.fetchProducts()
        setupSlideshow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LoadingIndicatorManager.shared.setup(for: self.view, navigationController: navigationController)
        slideshowHelper?.start()
    }
    
    // MARK: - Navigation Button Actions
    @objc func customBackButtonTapped() {
        interactionHelper.customBackButtonTapped()
    }
    
    @objc func restorePurchasesTapped() {
        interactionHelper.restorePurchasesTapped()
    }

    private func setupSlideshow() {
        let imageNames = ["onb_1_image", "onb_2_image", "onb_3_image", "onb_4_image"]
        slideshowHelper = PaywallOneSlideshowHelper(
            imageView: onboardingImageView,
            imageNames: imageNames,
            slideInterval: 3.0,
            crossfadeDuration: 0.8
        )
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        slideshowHelper?.stop()
    }
}

