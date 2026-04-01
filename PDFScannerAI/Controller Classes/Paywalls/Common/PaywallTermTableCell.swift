//
//  PaywallTermTableCell.swift
//  PDFScannerAI
//
//  Created by dev on 23.02.2026.
//

import UIKit

class PaywallTermTableCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var termLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var saveLabel: UILabel!
    
    var selection: Bool = false {
        didSet {
            if selection {
                containerView.layer.borderColor = Colors.blueColor.cgColor
            } else {
                containerView.layer.borderColor = Colors.grayColor.cgColor
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        termLabel.font = FontHelper.font(.regular, size: 14)
        priceLabel.font = FontHelper.font(.bold, size: 16)
        saveLabel.font = FontHelper.font(.regular, size: 14)
        RoundedStyleUtility.apply(to: containerView, cornerRadius: 12.0, backgroundColor: Colors.whiteColor, borderColor: Colors.grayColor, borderWidth: 2.0)
        RoundedStyleUtility.apply(to: saveLabel, cornerRadius: 12.0, backgroundColor: Colors.blueColor)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
