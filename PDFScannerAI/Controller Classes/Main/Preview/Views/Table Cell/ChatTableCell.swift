//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
// by Iurii Dolotov on 31.07.25.
//

import UIKit

protocol ChatTableCellDelegate: AnyObject {
    func chatTableCell(_ cell: ChatTableCell, didTapMoreFor document: Document, chat: ChatHistory)
}

class ChatTableCell: UITableViewCell {

    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var chatView: UIView!
    @IBOutlet weak var pdfImageView: UIImageView!
    @IBOutlet weak var chatNameLabel: UILabel!
    @IBOutlet weak var chatDateLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!

    weak var delegate: ChatTableCellDelegate?
    private var document: Document?
    private var chat: ChatHistory?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        selectionStyle = .none
        moreButton.addTarget(self, action: #selector(handleMoreButton), for: .touchUpInside)
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        holderView.layoutIfNeeded()
        RoundedStyleUtility.apply(to: holderView, backgroundColor: .clear)
        RoundedStyleUtility.apply(to: chatView, cornerRadius: 16, backgroundColor: Colors.secondaryBackgroundColor)
        
        chatNameLabel.font = FontHelper.font(.semiBold, size: 18)
        chatNameLabel.textColor = Colors.mainTextColor
        
        chatDateLabel.font = FontHelper.font(.medium, size: 14)
        chatDateLabel.textColor = Colors.grayColor
        
        moreButton.tintColor = Colors.grayColor
    }
    
    // MARK: - Configuration
    func configure(with chat: ChatHistory, document: Document) {
        self.document = document
        self.chat = chat
        chatNameLabel.text = chat.messages.first ?? ""
        chatDateLabel.text = DateHelper.metaInfoDateString(for: chat.created)
        pdfImageView.image = UIImage(named: "chat_image")
    }

    @objc private func handleMoreButton() {
        guard let document, let chat else { return }
        delegate?.chatTableCell(self, didTapMoreFor: document, chat: chat)
    }
}

