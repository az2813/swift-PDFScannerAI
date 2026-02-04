//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import UIKit

class PaywallThreeTableHeaderView: UIView {
    private let topImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "paywall_3_image")
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

    private let bottomImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "paywall_4_image")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
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
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(bottomImageView)

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

            bottomImageView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 24),
            bottomImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            bottomImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            bottomImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24)
        ])

        if let topImage = topImageView.image {
            let aspectRatio = topImage.size.height / topImage.size.width
            topImageView.heightAnchor.constraint(equalTo: topImageView.widthAnchor, multiplier: aspectRatio).isActive = true
        }

        if let bottomImage = bottomImageView.image {
            let aspectRatio = bottomImage.size.height / bottomImage.size.width
            bottomImageView.heightAnchor.constraint(equalTo: bottomImageView.widthAnchor, multiplier: aspectRatio).isActive = true
        }
    }
}
