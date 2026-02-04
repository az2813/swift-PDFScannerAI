//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import UIKit

class ReceivedChatMessageCell: UITableViewCell {

    private let messageLabel = UILabel()
    private let messageHolderView = UIView()
    private let mainStackView = UIStackView()

    private var linkRanges: [NSRange: URL] = [:]
    
    var messageHolder: UIView {
        return messageHolderView
    }


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
        contentView.backgroundColor = .clear

        messageLabel.numberOfLines = 0
        messageLabel.textColor = Colors.mainTextColor
        messageLabel.isUserInteractionEnabled = true
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLabelTap(_:)))
        messageLabel.addGestureRecognizer(tapGesture)

        messageHolderView.translatesAutoresizingMaskIntoConstraints = false
        messageHolderView.layer.cornerRadius = 16
        messageHolderView.layer.borderWidth = 0
        messageHolderView.layer.borderColor = UIColor.clear.cgColor
        messageHolderView.backgroundColor = Colors.backgroundColor.withAlphaComponent(0.35)
        messageHolderView.clipsToBounds = true
        messageHolderView.addSubview(messageLabel)

        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: messageHolderView.topAnchor, constant: 16),
            messageLabel.leadingAnchor.constraint(equalTo: messageHolderView.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: messageHolderView.trailingAnchor, constant: -16),
            messageLabel.bottomAnchor.constraint(equalTo: messageHolderView.bottomAnchor, constant: -16)
        ])

        mainStackView.axis = .vertical
        mainStackView.spacing = 8
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.addArrangedSubview(messageHolderView)

        contentView.addSubview(mainStackView)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -40),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }

    func configure(with attributedText: NSAttributedString) {
        messageLabel.attributedText = attributedText
        extractLinks(from: attributedText)
    }

    private func extractLinks(from attributedText: NSAttributedString) {
        linkRanges.removeAll()
        attributedText.enumerateAttribute(.link, in: NSRange(location: 0, length: attributedText.length), options: []) { value, range, _ in
            if let url = value as? URL {
                linkRanges[range] = url
            }
        }
    }

    @objc private func handleLabelTap(_ gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.location(in: messageLabel)
        guard let index = indexOfCharacter(at: tapLocation) else { return }

        for (range, url) in linkRanges {
            if NSLocationInRange(index, range) {
                UIApplication.shared.open(url)
                break
            }
        }
    }

    private func indexOfCharacter(at point: CGPoint) -> Int? {
        guard let attributedText = messageLabel.attributedText else { return nil }

        let textStorage = NSTextStorage(attributedString: attributedText)
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: messageLabel.bounds.size)

        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = messageLabel.numberOfLines
        textContainer.lineBreakMode = messageLabel.lineBreakMode

        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        return layoutManager.characterIndex(
            for: point,
            in: textContainer,
            fractionOfDistanceBetweenInsertionPoints: nil
        )
    }

    func updateMessageText(_ newText: String) {
        messageLabel.text = newText
    }
}
