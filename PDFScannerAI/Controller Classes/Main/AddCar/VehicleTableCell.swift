//
//  VehicleTableCell.swift
//  PDFScannerAI
//
//  Created by dev on 18.02.2026.
//

import UIKit

class VehicleTableCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var receiptButton: UIButton!
    
    var date: String = "" {
        didSet {
            dateLabel.text = date
        }
    }
    var service: [String: String] = [:] {
        didSet {
            titleLabel.text = service["title"]
        }
    }
    var didTapReceipt: (() -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        containerView.layer.cornerRadius = 16
        containerView.layer.masksToBounds = true
        titleLabel.font = FontHelper.font(.bold, size: 16)
        dateLabel.font = FontHelper.font(.regular, size: 13)
        receiptButton.titleLabel?.font = FontHelper.font(.regular, size: 13)
        receiptButton.layer.borderColor = UIColor.gray.cgColor
        receiptButton.layer.borderWidth = 1.0
        receiptButton.layer.cornerRadius = 8.0
        receiptButton.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func handleReceipt(_ sender: UIButton) {
        didTapReceipt?()
    }
}
