//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import UIKit

protocol DocumentTableCellDelegate: AnyObject {
    func documentTableCell(_ cell: DocumentTableCell, didTapMoreFor document: Document)
}

class DocumentTableCell: UITableViewCell {

    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var documentView: UIView!
    @IBOutlet weak var pdfImageView: UIImageView!
    @IBOutlet weak var pagesCountLabel: UILabel!
    @IBOutlet weak var fileNameLabel: UILabel!
    @IBOutlet weak var fileMetaLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!

    weak var delegate: DocumentTableCellDelegate?
    private var document: Document?
    
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
        RoundedStyleUtility.apply(to: documentView, cornerRadius: 16, backgroundColor: Colors.secondaryBackgroundColor)

        pagesCountLabel.font = FontHelper.font(.medium, size: 14)
        pagesCountLabel.textColor = Colors.mainTextColor
        
        fileNameLabel.font = FontHelper.font(.semiBold, size: 18)
        fileNameLabel.textColor = Colors.mainTextColor
        
        fileMetaLabel.font = FontHelper.font(.medium, size: 14)
        fileMetaLabel.textColor = Colors.grayColor
        
        moreButton.tintColor = Colors.grayColor
    }
    
    // MARK: - Configuration
    func configure(with document: Document, metaInfo: String) {
        self.document = document
        fileNameLabel.text = document.fileName
        pagesCountLabel.text = "Pages: \(document.pagesCount)"
        fileMetaLabel.text = metaInfo
        pdfImageView.image = UIImage(named: "pdf_image")
        setNeedsLayout()
    }

    @objc private func handleMoreButton() {
        guard let document else { return }
        delegate?.documentTableCell(self, didTapMoreFor: document)
    }
}
