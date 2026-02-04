//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import UIKit

class SentMessageCell: UITableViewCell {
    private let messageLabel = UILabel()
    private let messageImageView = UIImageView()
    private let messageHolderView = UIView()
    private let mainStackView = UIStackView()

    private var imageAspectRatioConstraint: NSLayoutConstraint?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = .clear
        selectionStyle = .none
        contentView.backgroundColor = Colors.whiteColor

        messageLabel.numberOfLines = 0
        messageLabel.font = FontHelper.font(.medium, size: 16)
        messageLabel.textColor = Colors.mainTextColor
        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        messageHolderView.translatesAutoresizingMaskIntoConstraints = false
        messageHolderView.layer.cornerRadius = 16
        messageHolderView.layer.borderWidth = 0
        messageHolderView.layer.borderColor = UIColor.clear.cgColor
        messageHolderView.backgroundColor = Colors.backgroundColor
        messageHolderView.clipsToBounds = true
        messageHolderView.addSubview(messageLabel)

        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: messageHolderView.topAnchor, constant: 16),
            messageLabel.leadingAnchor.constraint(equalTo: messageHolderView.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: messageHolderView.trailingAnchor, constant: -16),
            messageLabel.bottomAnchor.constraint(equalTo: messageHolderView.bottomAnchor, constant: -16)
        ])

        messageImageView.contentMode = .scaleAspectFill
        messageImageView.clipsToBounds = true
        messageImageView.layer.cornerRadius = 12
        messageImageView.translatesAutoresizingMaskIntoConstraints = false

        mainStackView.axis = .vertical
        mainStackView.spacing = 8
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.addArrangedSubview(messageImageView)
        mainStackView.addArrangedSubview(messageHolderView)

        contentView.addSubview(mainStackView)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            mainStackView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 40),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(with message: ChatDisplayMessage) {
        messageLabel.text = message.text

        if let image = message.image {
            messageImageView.image = image
            messageImageView.isHidden = false

            if let existing = imageAspectRatioConstraint {
                messageImageView.removeConstraint(existing)
            }

            imageAspectRatioConstraint = messageImageView.heightAnchor.constraint(equalTo: messageImageView.widthAnchor, multiplier: 1.0)
            imageAspectRatioConstraint?.priority = .required
            imageAspectRatioConstraint?.isActive = true
        } else {
            messageImageView.image = nil
            messageImageView.isHidden = true

            if let existing = imageAspectRatioConstraint {
                messageImageView.removeConstraint(existing)
                imageAspectRatioConstraint = nil
            }
        }
    }
}
