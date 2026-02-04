//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import UIKit

class PaywallFourTableHeaderView: UIView {
    private let topImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "paywall_2_image")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Unlimited PDF Scans & AI Chat"
        label.font = FontHelper.font(.bold, size: 32)
        label.textColor = Colors.blueColor
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Instant PDF scans, smart chats & quick sharing"
        label.font = FontHelper.font(.bold, size: 22)
        label.textColor = Colors.mainTextColor
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let trialLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let trialToggleContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 32
        view.backgroundColor = Colors.backgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let trialToggleLabel: UILabel = {
        let label = UILabel()
        label.text = "Doubting? Activate free trial now"
        label.font = FontHelper.font(.medium, size: 16)
        label.textColor = Colors.mainTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let trialToggleSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.onTintColor = Colors.blueColor
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()

    var onToggleChanged: ((Bool) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setBottomMessage("Get access to all our features")
        trialToggleSwitch.addTarget(self, action: #selector(trialSwitchChanged), for: .valueChanged)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
        setBottomMessage("Get access to all our features")
        trialToggleSwitch.addTarget(self, action: #selector(trialSwitchChanged), for: .valueChanged)
    }

    private func setupLayout() {
        addSubview(topImageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(trialLabel)
        addSubview(trialToggleContainer)

        trialToggleContainer.addSubview(trialToggleLabel)
        trialToggleContainer.addSubview(trialToggleSwitch)

        NSLayoutConstraint.activate([
            topImageView.topAnchor.constraint(equalTo: topAnchor),
            topImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topImageView.trailingAnchor.constraint(equalTo: trailingAnchor),

            titleLabel.topAnchor.constraint(equalTo: topImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            trialLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 16),
            trialLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            trialLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            trialToggleContainer.topAnchor.constraint(equalTo: trialLabel.bottomAnchor, constant: 16),
            trialToggleContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            trialToggleContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            trialToggleContainer.heightAnchor.constraint(equalToConstant: 64),
            trialToggleContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),

            trialToggleLabel.centerYAnchor.constraint(equalTo: trialToggleContainer.centerYAnchor),
            trialToggleLabel.leadingAnchor.constraint(equalTo: trialToggleContainer.leadingAnchor, constant: 24),

            trialToggleSwitch.centerYAnchor.constraint(equalTo: trialToggleContainer.centerYAnchor),
            trialToggleSwitch.trailingAnchor.constraint(equalTo: trialToggleContainer.trailingAnchor, constant: -24)
        ])

        if let topImage = topImageView.image {
            let aspectRatio = topImage.size.height / topImage.size.width
            topImageView.heightAnchor.constraint(equalTo: topImageView.widthAnchor, multiplier: aspectRatio).isActive = true
        }
    }

    @objc private func trialSwitchChanged() {
        onToggleChanged?(trialToggleSwitch.isOn)
    }

    func setBottomMessage(_ text: String) {
        let fullText = text
        let highlight = "all our features"
        let attributed = NSMutableAttributedString(string: fullText)

        let fullRange = NSRange(location: 0, length: fullText.count)
        attributed.addAttribute(.font, value: FontHelper.font(.bold, size: 22), range: fullRange)
        attributed.addAttribute(.foregroundColor, value: Colors.mainTextColor, range: fullRange)

        if let range = fullText.range(of: highlight) {
            let nsRange = NSRange(range, in: fullText)
            attributed.addAttribute(.foregroundColor, value: Colors.blueColor, range: nsRange)
        }

        trialLabel.attributedText = attributed
    }

    func updateTrialToggleText(_ text: String) {
        trialToggleLabel.text = text
    }

    func updateTrialLabelText(_ text: String) {
        trialLabel.text = text
    }
}
