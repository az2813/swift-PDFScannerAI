//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import UIKit
import StoreKit

class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var onboardingImageView: UIImageView!
    @IBOutlet weak var onboardingTitleLabel: UILabel!
    @IBOutlet weak var onboardingSubtitleLabel: UILabel!
    @IBOutlet weak var sliderImageView: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var privacyButton: UIButton!
    @IBOutlet weak var termsButton: UIButton!
    @IBOutlet weak var separatorLabel: UILabel!
    
    private var viewModel = OnboardingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        updateUIWithCurrentItem(animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 1.0, delay: 0, options: [.autoreverse, .repeat, .allowUserInteraction], animations: {self.nextButton.transform = CGAffineTransform(scaleX: 1.02, y: 1.02)}, completion: nil)
    }
    
    @IBAction func nextOnboarding(_ sender: UIButton) {
        hapticFeedback()
        AnimationUtility.animateButtonPress(sender) {
            let isOnboardingCompleted = self.viewModel.nextOnboardingItem()
            if isOnboardingCompleted {
                self.viewModel.completeOnboarding()
            } else {
                self.updateUIWithCurrentItem(animated: true)
            }
        }
    }
    
    private func bindViewModel() {
        viewModel.onOnboardingComplete = { [weak self] in
            self?.openApp()
        }
        
        viewModel.onPaywallRequired = { [weak self] in
            self?.presentPaywallController()
        }
    }
    
    private func updateUIWithCurrentItem(animated: Bool) {
        let currentItem = viewModel.currentOnboardingItem
        
        if animated {
            let elements: [UIView] = [onboardingTitleLabel, onboardingSubtitleLabel, sliderImageView]
            
            UIView.animate(withDuration: 0.3, animations: {
                elements.forEach { $0.alpha = 0 }
                self.onboardingImageView.alpha = 0
            }, completion: { _ in
                self.onboardingImageView.image = UIImage(named: currentItem.imageName)
                self.onboardingTitleLabel.text = currentItem.title
                self.onboardingSubtitleLabel.text = currentItem.subtitle
                self.sliderImageView.image = UIImage(named: currentItem.sliderImageName)
                
                UIView.animate(withDuration: 0.6,
                               delay: 0,
                               options: .curveEaseInOut,
                               animations: {
                    self.onboardingImageView.alpha = 1
                })
                
                for (index, element) in elements.enumerated() {
                    UIView.animate(withDuration: 0.5,
                                   delay: Double(index) * 0.15,
                                   options: .curveEaseInOut,
                                   animations: {
                        element.alpha = 1
                    })
                }
            })
        } else {
            onboardingImageView.image = UIImage(named: currentItem.imageName)
            onboardingTitleLabel.text = currentItem.title
            onboardingSubtitleLabel.text = currentItem.subtitle
            sliderImageView.image = UIImage(named: currentItem.sliderImageName)
        }
        
        if viewModel.isLastItem {
            if let windowScene = view.window?.windowScene {
                SKStoreReviewController.requestReview(in: windowScene)
            }
        }
    }
}

// MARK: - UI Setup
extension OnboardingViewController {
    private func setupUI() {
        view.backgroundColor = Colors.whiteColor
        
        onboardingTitleLabel.font = FontHelper.font(.bold, size: 32)
        onboardingTitleLabel.textColor = Colors.blueColor
        
        onboardingSubtitleLabel.font = FontHelper.font(.semiBold, size: 18)
        onboardingSubtitleLabel.textColor = Colors.mainTextColor.withAlphaComponent(0.8)
        
        nextButton.titleLabel?.font = FontHelper.font(.bold, size: 16)
        RoundedStyleUtility.apply(to: nextButton, cornerRadius: 16, titleTextColor: Colors.whiteColor)
        
        privacyButton.titleLabel?.font = FontHelper.font(.regular, size: 12)
        privacyButton.setTitleColor(Colors.mainTextColor, for: .normal)
        termsButton.titleLabel?.font = FontHelper.font(.regular, size: 12)
        termsButton.setTitleColor(Colors.mainTextColor, for: .normal)
        separatorLabel.font = FontHelper.font(.black, size: 12)
        separatorLabel.textColor = Colors.secondaryTextColor
    }
}

// MARK: - Navigation
extension OnboardingViewController {
    private func openApp() {
        NavigationManager.shared.transitionToViewController(
            identifier: "DashboardViewController",
            from: self
        )
    }
    
    private func presentPaywallController() {
        PaywallManager.shared.showPaywall(from: self, configKey: "paywall_onboarding", isDismiss: false)
    }
}
