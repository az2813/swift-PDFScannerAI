//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import UIKit

class GenericPaywallTableFooterView: UIView {

    var onContinueTapped: (() -> Void)?
    var onPrivacyTapped: (() -> Void)?
    var onTermsTapped: (() -> Void)?
    var onRestoreTapped: (() -> Void)?

    private let topImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "secured_bage_image")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Continue", for: .normal)
        button.titleLabel?.font = FontHelper.font(.bold, size: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        RoundedStyleUtility.apply(
            to: button,
            cornerRadius: 16,
            backgroundColor: Colors.blueColor,
            titleTextColor: Colors.whiteColor
        )
        return button
    }()

    private lazy var policyStackView: UIStackView = {
        let terms = createPolicyButton(title: "Terms", action: #selector(didTapTerms))
        let dot1 = createDotLabel()
        let privacy = createPolicyButton(title: "Privacy", action: #selector(didTapPrivacy))
        let dot2 = createDotLabel()
        let restore = createPolicyButton(title: "Restore", action: #selector(didTapRestore))

        let stack = UIStackView(arrangedSubviews: [terms, dot1, privacy, dot2, restore])
        stack.axis = .horizontal
        stack.spacing = 16
        stack.alignment = .center
        stack.distribution = .equalCentering
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }

    private func setupLayout() {
        addSubview(topImageView)
        addSubview(continueButton)
        addSubview(policyStackView)

        NSLayoutConstraint.activate([
            topImageView.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            topImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            topImageView.heightAnchor.constraint(equalToConstant: 24),
            topImageView.widthAnchor.constraint(lessThanOrEqualToConstant: 180),

            continueButton.topAnchor.constraint(equalTo: topImageView.bottomAnchor, constant: 16),
            continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            continueButton.heightAnchor.constraint(equalToConstant: 66),

            policyStackView.topAnchor.constraint(equalTo: continueButton.bottomAnchor, constant: 16),
            policyStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            policyStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])

        continueButton.addTarget(self, action: #selector(didTapContinue), for: .touchUpInside)
    }


    private func createPolicyButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = FontHelper.font(.regular, size: 14)
        button.setTitleColor(Colors.secondaryTextColor, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

    private func createDotLabel() -> UILabel {
        let dot = UILabel()
        dot.text = "•"
        dot.font = FontHelper.font(.black, size: 16)
        dot.textColor = Colors.secondaryTextColor
        return dot
    }

    // MARK: - Actions

    @objc private func didTapContinue() {
        AnimationUtility.animateButtonPress(continueButton) { [weak self] in
            self?.onContinueTapped?()
        }
    }

    @objc private func didTapPrivacy() {
        onPrivacyTapped?()
    }

    @objc private func didTapTerms() {
        onTermsTapped?()
    }

    @objc private func didTapRestore() {
        onRestoreTapped?()
    }
}
